import { FeedbackApi } from '../http/Api';
import { FeedbackInfo } from '../http/Types';

@ObservedV2
export class FeedbackHistoryVM {
  @Trace feedbackList: FeedbackInfo[] = [];
  private static _instance: FeedbackHistoryVM;
  stack: NavPathStack = new NavPathStack();

  public static get instance() {
    if (!FeedbackHistoryVM._instance) {
      FeedbackHistoryVM._instance = new FeedbackHistoryVM();
    }
    return FeedbackHistoryVM._instance;
  }


  setStack(stack: NavPathStack) {
    this.stack = stack;
  }

  public async getFeedBack() {
    this.feedbackList = await FeedbackApi.queryFeedback();
  }
}