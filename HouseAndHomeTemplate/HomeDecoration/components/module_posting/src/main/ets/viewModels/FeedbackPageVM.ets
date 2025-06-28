import { promptAction } from '@kit.ArkUI';
import {FeedbackApi} from '../http/Api'
import { UrlMap } from '../common/Constant';


@ObservedV2
export class FeedbackPageVM {
  private static _instance: FeedbackPageVM;
  stack: NavPathStack = new NavPathStack();

  public static get instance() {
    if (!FeedbackPageVM._instance) {
      FeedbackPageVM._instance = new FeedbackPageVM();
    }
    return FeedbackPageVM._instance;
  }

  public dateAsISO(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }


  setStack(stack: NavPathStack) {
    this.stack = stack;
  }


  public async uploadFeedback(title: string, type: string, mainPoint?: string, idea?: string) {
    const postTime = this.dateAsISO(new Date());
    const res = await FeedbackApi.uploadFeedback({
      title,
      type,
      mainPoint,
      idea,
      postTime,
    });

    if (res) {
      promptAction.showToast({ message: '反馈成功！' });
      this.stack.pushPath({name:UrlMap.FEEDBACK_HISTORY})
    }

  }
}