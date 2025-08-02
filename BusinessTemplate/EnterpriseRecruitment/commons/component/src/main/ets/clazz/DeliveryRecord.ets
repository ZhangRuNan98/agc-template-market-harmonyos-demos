import { OptionsModel } from 'ui_steps';
import { Type } from '@kit.ArkUI';

/**
 * 投递记录
 */
@ObservedV2
export class DeliveryRecord {
  // 职位Id
  @Trace jobId: string = '';
  // 投递时间
  @Trace submitTime: string = '';
  // 投递流程详情Id
  @Trace deliveryDetailId: string = '';
}


export interface DeliveryDetail {
  id: string;
  active: number;
  optionArray: Array<OptionsModel>;

}

export const deliveryDetailData: Array<DeliveryDetail> = [
  {
    id: '0',
    active: 2,
    optionArray: [
      new OptionsModel('流程启动', true),
      new OptionsModel('笔试', true),
      new OptionsModel('一轮面试'),
      new OptionsModel('二轮面试'),
      new OptionsModel('流程结束'),
    ],
  },
  {
    id: '1',
    active: 3,
    optionArray: [
      new OptionsModel('流程启动', true),
      new OptionsModel('笔试', true),
      new OptionsModel('一轮面试', true),
      new OptionsModel('二轮面试'),
      new OptionsModel('流程结束'),
    ],
  },
  {
    id: '2',
    active: 4,
    optionArray: [
      new OptionsModel('流程启动', true),
      new OptionsModel('笔试', true),
      new OptionsModel('一轮面试', true),
      new OptionsModel('二轮面试', true),
      new OptionsModel('流程结束'),
    ],
  },
  {
    id: '3',
    active: 1,
    optionArray: [
      new OptionsModel('流程启动', true),
      new OptionsModel('笔试', false),
      new OptionsModel('一轮面试'),
      new OptionsModel('二轮面试'),
      new OptionsModel('流程结束'),
    ],
  },
  {
    id: '4',
    active: 2,
    optionArray: [
      new OptionsModel('流程启动', true),
      new OptionsModel('笔试', true),
      new OptionsModel('一轮面试', false),
      new OptionsModel('二轮面试'),
      new OptionsModel('流程结束'),
    ],
  },
  {
    id: '5',
    active: 3,
    optionArray: [
      new OptionsModel('流程启动', true),
      new OptionsModel('笔试', true),
      new OptionsModel('一轮面试', true),
      new OptionsModel('二轮面试', false),
      new OptionsModel('流程结束'),
    ],
  },
];