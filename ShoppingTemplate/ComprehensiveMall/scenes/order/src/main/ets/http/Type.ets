import { Address } from 'lib_foundation';

export interface LogisticsItemDto {
  icon: string;
  status: string;
  desc: string;
  time: string;
}

export interface OrderSkuDto {
  skuCode: string;
  skuDesc: string;
  count: number;
  banner: ResourceStr;
  title: string;
  serviceDesc: string;
  price: number;
  oldPrices?: number;
}

@ObservedV2
export class AddressModel implements Address {
  @Trace
  name: string = '';
  @Trace
  cellphone: string = '';
  @Trace
  address: string = '';
}

export interface OrderCardDto {
  type: number; // 0: 完成(已完成、已取消、已退款), 1: 待付款, 2: 待发货, 3: 待收货, 4: 退款/售后
  orderCode: string;
  statusDesc: string;
  skuList: OrderSkuDto[];
  logisticsInfo: LogisticsItemDto[];
  totalPrice: number;
  address: AddressModel;
  time: string;
  remark: string;
  remainingTime?: string;
  refundTime?: string;
  receivingMethod?: string;
}

export interface OrderInfo {
  type: number;
  productId: string;
  skuCode: string;
  skuDesc: string;
  banner: string;
  title: string;
  serviceDesc: string;
  price: number;
}

@ObservedV2
export class OrderCardVM {
  @Trace
  public type: number = -1;
  @Trace
  public orderCode: string = '';
  @Trace
  public statusDesc: string = '';
  @Trace
  public skuList: OrderSkuDto[] = [];
  @Trace
  public logisticsInfo: LogisticsItemDto[] = [];
  @Trace
  public totalPrice: number = 0;
  @Trace
  public time: string = '';
  @Trace
  remainingTime: string = '';
  @Trace
  refundTime: string = '';
  @Trace
  address: AddressModel = {
    name: '',
    cellphone: '',
    address: '',
  };
  @Trace
  receivingMethod: string = '';
  @Trace
  public remark: string = '';
  @Trace
  public discount?: number = 0;
}
