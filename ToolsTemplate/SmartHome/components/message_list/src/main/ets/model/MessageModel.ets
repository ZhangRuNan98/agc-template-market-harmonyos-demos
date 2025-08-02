import { intl } from '@kit.LocalizationKit';

export class MessageRecordViewModel {
  message: string;
  day: string;
  week: string;
  hourMinute: string;

  constructor(message:string, date:Date) {
    this.message = message;

    let dateFormat1 = new intl.DateTimeFormat('zh-CN', { dateStyle: 'short', timeStyle: 'medium' });
    let time = dateFormat1.format(date);
    this.day = time.split(' ')[0];
    this.hourMinute = time.split(' ')[1];

    let dateFormat2 = new intl.DateTimeFormat('zh-CN', { weekday: 'long' });
    this.week = dateFormat2.format(date);
  }
}