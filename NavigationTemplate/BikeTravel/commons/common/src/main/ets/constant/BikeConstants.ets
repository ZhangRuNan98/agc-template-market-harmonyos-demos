/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

export class BikeConstants {
  /**
   * CyclingStatus
   */
  public static readonly CYCLING_STATUS = 'CyclingStatus';
  /**
   * Title for waiting payment
   */
  public static readonly WAITING_PAYMENT_TITLE: string = '行程结束';
  /**
   * Content for waiting payment
   */
  public static readonly WAITING_PAYMENT_CONTENT: string = '骑行时长10:00';
  /**
   * Title for waiting payment layout
   */
  public static readonly WAITING_PAYMENT_LAYOUT_TITLE: string = '待支付';
  /**
   * Content for waiting payment layout
   */
  public static readonly WAITING_PAYMENT_LAYOUT_CONTENT: string = '1.5元';
  /**
   * Extension data for waiting payment
   */
  public static readonly WAITING_PAYMENT_EXTENSION_DATA: string = '去支付';
  /**
   * Pay method for waiting payment
   */
  public static readonly WAITING_PAYMENT_PAY: string = '免密支付';
  /**
   * Success message for payment
   */
  public static readonly WAITING_PAYMENT_PAY_SUCCESS: string = '扣费成功';
  /**
   * End message for payment
   */
  public static readonly WAITING_PAYMENT_PAY_END: string = '已支付';
  /**
   * Check message for payment completed
   */
  public static readonly PAYMENT_COMPLETED_CHECK: string = '去查看';
  /**
   * Title for payment completed capsule
   */
  public static readonly PAYMENT_COMPLETED_CAPSULE_TITLE: string = '已完成';
  /**
   * Title for default view layout
   */
  public static readonly DEFAULT_VIEW_LAYOUT_TITLE: string = '预估费用';
  /**
   * Status for riding
   */
  public static readonly DEFAULT_VIEW_RIDING: string = '骑行中';
  /**
   * Riding time in default view
   */
  public static readonly DEFAULT_VIEW_RIDING_TIME: string = '骑行时长01:21';
  /**
   * Default zoom level
   */
  public static readonly ZOOM: number = 15;
}


