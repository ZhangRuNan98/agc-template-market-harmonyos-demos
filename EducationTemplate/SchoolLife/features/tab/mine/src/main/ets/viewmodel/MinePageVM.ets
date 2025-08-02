import { AccountUtil, UserInfoModel, SimpleDialog } from 'commonlib';
import { UserApi } from 'network';

import common from '@ohos.app.ability.common';
import authentication from '@hms.core.authentication';
import { BusinessError } from '@ohos.base';
import { PromptAction, UIContext } from '@ohos.arkui.UIContext';

@ObservedV2
export class MinePageVM {

  @Trace
  public userInfo: UserInfoModel = AccountUtil.getUserInfo();

  @Trace
  public hasBindAccount: boolean = false;

  @Trace
  public isLoading: boolean = false;

  @Monitor('userInfo.phone')
  public bindPhoneStatusChange(monitor: IMonitor) {
    this.hasBindAccount = monitor.value()?.now !== '';
  }

  private static instance: MinePageVM;

  private uiContext: UIContext;

  private promptAction: PromptAction;

  public static getInstance(uiContext: UIContext): MinePageVM {
    if (!MinePageVM.instance) {
      MinePageVM.instance = new MinePageVM(uiContext);
    }
    return MinePageVM.instance;
  }

  public connectHuaweiAccount(): void {
    if (this.hasBindAccount || this.isLoading) {
      return;
    }
    this.isLoading = true;
    const context: Nullable<common.Context> = this.uiContext.getHostContext();
    AccountUtil.connectHuaweiAccount(context ? context : getContext())
      .then((authorizationCode: string) => {
        this.doRealLoginByHuaweiAccount(authorizationCode);
      })
      .catch((e: BusinessError<void>) => {
        if (e.code === authentication.AuthenticationErrorCode.USER_CANCELED) {
          this.isLoading = false;
        } else if (e.code === authentication.AuthenticationErrorCode.SCOPE_OR_PERMISSION_NOT_REQUESTED) {
          const dialog: SimpleDialog = new SimpleDialog(this.uiContext)
            .setTitle('授权服务拉起失败')
            .setMessage('当前元服务未获取phone权限，您可以通过模拟关联继续流程。')
            .setConfirmButtonText('模拟关联')
            .setCancelButtonText('取消')
            .onWillDismiss(() => {
              this.promptAction.showToast({ message: '手机号关联失败' });
              this.isLoading = false;
              return true;
            })
            .onCancel(() => {
              this.promptAction.showToast({ message: '手机号关联失败' });
              this.isLoading = false;
            })
            .onConfirm(() => {
              this.doRealLoginByHuaweiAccount('mock_authorization_code');
            });
          dialog.open();
        } else {
          this.showErrorToast(e);
          this.isLoading = false;
        }
      });
  }

  public disconnectHuaweiAccount(): void {
    AccountUtil.cancelAuthorization();
  }

  private async doRealLoginByHuaweiAccount(authorizationCode: string): Promise<void> {
    try {
      const bindRes = await UserApi.bindPhone(authorizationCode);
      if (!bindRes || bindRes.code !== 0) {
        throw new Error();
      }
      const userInfoRes = await UserApi.getUserInfo();
      if (!userInfoRes || userInfoRes.code !== 0) {
        throw new Error();
      }
      const userInfo: UserInfoModel = userInfoRes.data as UserInfoModel;
      if (!userInfo.phone) {
        throw new Error();
      }
      AccountUtil.setUserInfo(userInfo);
      this.promptAction.showToast({ message: '手机号关联成功！' });
    } catch {
      this.promptAction.showToast({ message: '手机号关联失败，请稍后重试' });
    } finally {
      this.isLoading = false;
    }
  }

  public updateNickName(name: string): void {
    UserApi.updateUserNickname(name).then(() => {
      this.userInfo.nickname = name;
    });
  }

  private showErrorToast(error: BusinessError<void> | string): void {
    let message: string = '';
    if (typeof error === 'string') {
      message = 'error: ' + error;
    } else if (!error.code) {
      message = 'error: ' + error.message;
    } else {
      message = `code: ${error.code}, msg: ${error.message}`;
    }
    this.promptAction.showToast({
      message: message,
      backgroundBlurStyle: BlurStyle.NONE,
      backgroundColor: '#FFFF9800',
      textColor: '#E6000000'
    });
  }

  constructor(uiContext: UIContext) {
    this.uiContext = uiContext;
    this.promptAction = this.uiContext.getPromptAction();
  }
}
