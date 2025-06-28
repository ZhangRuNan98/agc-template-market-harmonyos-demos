import { FeedbackInfo } from '../http/Types';
import { UrlMap } from '../common/Constant';


@ObservedV2
export class FeedbackDetailVM {
  @Trace feedbackDetail: FeedbackInfo | undefined = undefined;
  stack: NavPathStack = new NavPathStack();
  private static _instance: FeedbackDetailVM;

  public static get instance() {
    if (!FeedbackDetailVM._instance) {
      FeedbackDetailVM._instance = new FeedbackDetailVM();
    }
    return FeedbackDetailVM._instance;
  }

  setStack(stack: NavPathStack) {
    this.stack = stack;
  }


  public getFeedbackDetail() {
    const params: FeedbackInfo[] = this.stack.getParamByName(UrlMap.FEEDBACK_DETAIL) as FeedbackInfo[];
    if (params.length && params[params.length - 1]) {
      this.feedbackDetail = params[params.length - 1];
    }

  }
}