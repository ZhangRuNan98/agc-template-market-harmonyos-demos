/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { IAddrInfo, ISetting, ITemplate } from '../http/Type';


export enum TypeAddressPage {
  NEW = 1,
  EDIT = 2,
}

export interface ParamAddressPage {
  type: TypeAddressPage;
  param?: ITemplate;
}

// 手机号正则
export const PHONE_REG = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;

export enum ShippingMethod {
  PICK_UP_AT_HOME = '上门取件',
  SELF_SENDING = '自寄',
}


export enum PaymentMethod {
  'PAY_NOW' = 1,
  'PAY_ON_DELIVERY' = 2,
}

export enum OrderType {
  ALL = '全部',
  SEND = '寄快递',
  RECEIVE = '收快递',
}

export const methodList: ISetting[] = [
  {
    text: '上门取件',
    value: 1,
  },
  {
    text: '服务点自寄',
    value: 2,
  }
]

export const payMethodList: ISetting[] = [
  {
    text: '寄付现结',
    value: 1
  },
  {
    text: '到付',
    value: 2
  }
]

export const gridList: ISetting[] = [
  {
    text: '小格口',
    value: 1
  },
  {
    text: '中格口',
    value: 2
  },
  {
    text: '大格口',
    value: 3
  }
]

export const dayList: ISetting[] = [
  {
    text: '今天',
    value: 1
  },
  {
    text: '明天',
    value: 2
  },
  {
    text: '后天',
    value: 3
  }
]

export const shippingMethodList: ISetting[] = [
  {
    text: '网点自寄',
    value: 1
  },
  {
    text: '自行联系快递员',
    value: 2
  },
  {
    text: '每天固定时间',
    value: 3
  }
]

export const timeList: string[] =
  ['8:00 - 9:00', '9:00 - 10:00', '10:00 - 11:00', '11:00 - 12:00', '14:00 - 15:00', '15:00 - 16:00', '16:00 - 17:00',
    '17:00 - 18:00']