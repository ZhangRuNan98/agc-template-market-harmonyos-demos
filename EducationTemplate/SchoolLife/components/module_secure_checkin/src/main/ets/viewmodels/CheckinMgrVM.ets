import { Api } from '../http/Api';
import { CheckinContext, ViewModelState } from '../common/CustomTypes';
import { CheckinStatusDTO, CheckinInfoDTO } from '../models/ApiModels';
import { PermissionUtil } from '../utils/PermissionUtil';
import { VerifyEventType } from '../components/UIVerifyCodeInput';

import common from '@ohos.app.ability.common';
import geoLocationManager from '@ohos.geoLocationManager';
import { Permissions } from '@ohos.abilityAccessCtrl';
import { PromptAction } from '@ohos.arkui.UIContext';

@ObservedV2
export class CheckinMgrVM {

  @Trace
  public state: ViewModelState = ViewModelState.UNINITIALIZED;

  @Trace
  public isLoading: boolean = false;

  @Trace
  public isCheckedIn: boolean = false;

  @Trace
  public checkinCode: string = '';

  @Trace
  public showErrorTips: boolean = false;

  public readonly courseName: string;

  public readonly studentId: string;

  public readonly courseId: string;

  private context: common.UIAbilityContext;

  private promptAction: PromptAction;

  private hasLocationPermission: boolean = false;

  public async initialize(): Promise<void> {
    if (this.isLoading || this.state === ViewModelState.READY) {
      return;
    }
    try {
      this.isLoading = true;
      // 尝试获取签到状态，如果当前 Model 处于未初始化状态，则一并请求位置权限
      const status: CheckinStatusDTO = (await Promise.all([
        Api.requestCheckinStatus(this.studentId, this.courseName),
        this.state === ViewModelState.UNINITIALIZED ? this.requestLocationPermission() : Promise.resolve()
      ]))[0];
      // 校验是否已经签到，并获取签到码
      if (status.isCheckedIn && status.checkinInfo) {
        this.isCheckedIn = true;
        this.checkinCode = status.checkinInfo.checkinCode;
      }
      // Model 设置为就绪状态
      this.state = ViewModelState.READY;
    } catch {
      // Model 设置为初始化失败状态
      this.state = ViewModelState.INIT_FAILED;
    } finally {
      this.isLoading = false;
    }
  }

  public async doCheckin(): Promise<void> {
    if (this.isLoading || this.state !== ViewModelState.READY) {
      return;
    }
    this.isLoading = true;
    if (!this.hasLocationPermission) {
      await this.requestLocationPermission();
    }
    if (!this.hasLocationPermission) {
      this.promptAction.showToast({ message: '位置权限获取失败' });
      this.isLoading = false;
      return;
    }
    try {
      const location = await geoLocationManager.getCurrentLocation({
        priority: geoLocationManager.LocationRequestPriority.FIRST_FIX,
        timeoutMs: 10000
      });
      this.doRealCheckin({
        studentId: this.studentId,
        courseName: this.courseName,
        courseId: this.courseId,
        checkinCode: this.checkinCode,
        location: {
          latitude: location.latitude,
          longitude: location.longitude
        }
      });
    } catch {
      this.promptAction.showToast({ message: '位置信息获取失败，请重试' });
      this.isLoading = false;
    }
  }

  private doRealCheckin(checkinInfo: CheckinInfoDTO): void {
    Api.submitCheckin(checkinInfo)
      .then((isSuccess: boolean) => {
        this.isCheckedIn = isSuccess;
        if (!this.isCheckedIn) {
          this.showErrorTips = true;
          this.checkinCode = '';
          this.context.eventHub.emit(VerifyEventType.CODE_ERROR);
        }
      })
      .catch(() => {
        this.promptAction.showToast({ message: '未知异常' });
      })
      .finally(() => {
        this.isLoading = false;
      })
  }

  private async requestLocationPermission(): Promise<void> {
    if (!this.context) {
      return;
    }
    const permissions: Permissions[] = ['ohos.permission.APPROXIMATELY_LOCATION', 'ohos.permission.LOCATION'];
    this.hasLocationPermission = await PermissionUtil.requestPermissions(this.context, permissions);
  }

  constructor(checkinContext: CheckinContext, uiContext: UIContext) {
    this.promptAction = uiContext.getPromptAction();
    this.context = uiContext.getHostContext() as common.UIAbilityContext;
    this.courseName = checkinContext.courseName;
    this.studentId = checkinContext.studentId;
    this.courseId = checkinContext.courseId;
    this.initialize();
  }
}
