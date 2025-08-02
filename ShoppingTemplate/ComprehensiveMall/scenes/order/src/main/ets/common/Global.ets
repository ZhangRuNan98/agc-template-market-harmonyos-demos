import { OrderApi } from '../http/Api';
import { AppStorageV2 } from '@kit.ArkUI';
import { OrderCardDto } from 'lib_foundation';

@ObservedV2
export class OrderList {
  @Trace list: OrderCardDto[] = OrderApi.ORDER_LIST;
}

/**
 * AppStorageV2应用全局缓存库
 */
export class AppStorageBank {
  static orderList: OrderList = AppStorageV2.connect(OrderList, () => new OrderList())!;

  static updateOrderList(list: OrderCardDto[]) {
    AppStorageBank.orderList.list = list;
  }
}