import { RouterMap } from 'commonlib';

export interface ServerItem {
  label: string,
  icon: ResourceStr
}


export interface SettingItem {
  label: string,
  page: RouterMap
}


// 反馈类型
export enum FeedbackType {
  suggestion = '0',
  want = '1'
}