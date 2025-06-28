
@ObservedV2
export class WantData {
  @Trace title: string;
  @Trace painPoint: string;
  @Trace idea: string;

  constructor(title: string = '', painPoint: string = '', idea: string = '') {
    this.title = title;
    this.painPoint = painPoint;
    this.idea = idea;
  }
}

export enum PostType {
  want = '0',
  suggestion = '1'
}



// 上传反馈
export interface FeedbackBody {
  title: string,
  type: string,
  postTime: string,
  mainPoint?: string,
  idea?: string,
}

// 历史反馈
export interface FeedbackInfo extends FeedbackBody {
  answer: string;
}