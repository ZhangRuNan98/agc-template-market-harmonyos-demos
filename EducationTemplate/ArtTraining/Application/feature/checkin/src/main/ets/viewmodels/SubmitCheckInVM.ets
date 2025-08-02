import {
  CheckInActivity,
  Logger,
  RouterMap,
  RouterModule,
  CheckInTaskItem,
  CloudStorageUtil,
  FullLoading,
  WindowUtil,
} from 'commonlib';
import { CheckInRecordModel } from '../models/Index';
import { CheckInLogRouteParam, TaskCheckInPopParam } from '../types/Index';
import { promptAction } from '@kit.ArkUI';
import { https } from 'network';
import { CheckInDataModel } from 'module_check_in';

const TAG = '[SubmitCheckInVM]';

@ObservedV2
export class SubmitCheckInVM {
  // 活动信息
  @Trace activity: CheckInActivity | null = null;
  // 任务信息
  @Trace taskItem: CheckInTaskItem | null = null;
  // 打卡内容
  @Trace checkInData = new CheckInRecordModel();
  videoController: VideoController = new VideoController();
  private static _instance: SubmitCheckInVM;

  public static get instance() {
    if (!SubmitCheckInVM._instance) {
      SubmitCheckInVM._instance = new SubmitCheckInVM();
    }
    return SubmitCheckInVM._instance;
  }

  public initRecord() {
    const params = RouterModule.getNavParam<CheckInLogRouteParam>({
      url: RouterMap.ACTIVITY_SUBMIT,
    });
    if (params) {
      this.checkInData.activityId = params.activity.activityId;
      this.checkInData.taskId = params.task.taskId;
      this.taskItem = params.task;
      this.activity = params.activity;
    }
  }

  public async submitRecord(data: CheckInDataModel) {
    if (!this.checkInData.taskId || !this.checkInData.activityId) {
      WindowUtil.promptAction.showToast({ message: '任务信息获取失败，请稍后重试' });
      return;
    }
    const requirement = this.activity?.requirement;
    if (requirement) {
      if (requirement.textSwitch && data.textDetail.length < requirement.textMinLimit) {
        WindowUtil.promptAction.showToast({ message: `打卡文字不得少于${requirement.textMinLimit}个字~` });
        return;
      }
      if (requirement.pictureSwitch) {
        if (data.pictureDetail.length < requirement.pictureMinLimit) {
          WindowUtil.promptAction.showToast({ message: `打卡图片不得少于${requirement.pictureMinLimit}张~` });
          return;
        }
      }
      if (requirement.audioSwitch) {
        if (!data.audioDetail.length) {
          WindowUtil.promptAction.showToast({ message: '请至少上传一个打卡音频~' });
          return;
        }
      }
      if (requirement.videoSwitch) {
        if (!data.videoDetail.length) {
          WindowUtil.promptAction.showToast({ message: '请至少上传一个打卡视频~' });
          return;
        }
      }
      this._uploadCheckInFile(data);
    }
  }

  private async _uploadCheckInFile(data: CheckInDataModel) {
    this.checkInData.pictureDetail = [];
    this.checkInData.audioDetail = [];
    this.checkInData.videoDetail = [];
    const fileList = data.pictureDetail.concat(data.audioDetail).concat(data.videoDetail);
    const fileNum = fileList.length;
    let completedNum: number = 0;
    FullLoading.show('文件上传中...');
    let flag = true;
    for (const item of fileList) {
      if (!flag) {
        return;
      }
      try {
        await CloudStorageUtil.upload(item as string, async (url: string, isSuccess: boolean = true) => {
          flag = isSuccess;
          if (!flag) {
            Logger.error(TAG, 'upload file failed');
            WindowUtil.promptAction.showToast({ message: '打卡失败，请稍后重试~' });
            FullLoading.hide();
            return;
          }
          if (data.pictureDetail.includes(item)) {
            this.checkInData.pictureDetail.push(url)
          } else if (data.audioDetail.includes(item)) {
            this.checkInData.audioDetail.includes(url)
          } else {
            this.checkInData.videoDetail.push(url)
          }
          completedNum++;
          if (completedNum === fileNum) {
            Logger.info(TAG, 'files upload completed');
            try {
              const res = await https.commitUserCheckIn(this.checkInData);
              if (res.ret.code === 0) {
                WindowUtil.promptAction.showToast({ message: '打卡成功！' });
                this.clearData();
                const popInfo: TaskCheckInPopParam = {
                  needUpdate: true,
                };
                const timer = setTimeout(() => {
                  RouterModule.pop(popInfo);
                  clearTimeout(timer)
                }, 100)
              } else {
                WindowUtil.promptAction.showToast({ message: '打卡失败，请稍后重试~' });
              }
            } catch (err) {
              Logger.error(TAG, 'commit check-in data failed:' + err);
              WindowUtil.promptAction.showToast({ message: '打卡失败，请稍后重试~' });
            } finally {
              FullLoading.hide();
            }
          }
        });
      } catch (err) {
        Logger.error(TAG, 'upload failed,error:' + err);
        promptAction.showToast({ message: '打卡失败，请稍后重试~' });
        FullLoading.hide();
      }
    }
  }

  public backToLastPage() {
    RouterModule.pop();
  }

  public clearData() {
    this.checkInData.textDetail = '';
    this.checkInData.pictureDetail = [];
    this.checkInData.videoDetail = [];
    this.checkInData.audioDetail = [];
  }
}