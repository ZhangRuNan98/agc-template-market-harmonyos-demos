import {
  Address,
  OrderCardDto,
  OrderSkuDto,
  PreOrderInfoDto,
  PreOrderRequest,
  RouterMap,
  routerStack,
} from 'lib_foundation';
import { client } from 'lib_network';
import { ShippingOption } from '../commons/Enums';
import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { formatFullDate } from '../Utils';
import { paymentService } from '@kit.PaymentKit';
import { common } from '@kit.AbilityKit';
import { OrderList } from '@scene/order';
import { getDefaultAddress } from 'module_address_manage';

@ObservedV2
export class OrderSubmitVM {
  @Trace
  isLoading: boolean = false;
  @Trace
  shippingIndex: ShippingOption = ShippingOption.EXPRESS;
  @Trace
  customerAddress: string = '请填写收件人地址';
  @Trace
  customerName: string = '请填写收件人信息';
  @Trace
  customerPhone: string = '';
  @Trace
  skuList: OrderSkuDto[] = [];
  @Trace
  totalPrice: number = 0;
  @Trace
  discountPrice: number = 0;
  @Trace
  discountId: string = '';
  @Trace
  remark: string = '';
  @Trace
  remarkCache: string = '';
  @Trace
  preOrderRequest: PreOrderRequest | undefined = undefined;
  @Trace
  orderList: OrderList = AppStorageV2.connect(OrderList, () => new OrderList())!;
  readonly SHOP_ADDRESS: string = '店铺地址';
  readonly SHOP_PHONE: string = '12345678';

  @Computed
  get ShippingLabel() {
    return this.shippingIndex === ShippingOption.EXPRESS ? '快递发货' : '到店自提';
  }

  @Computed
  get totalProductCount() {
    if (this.skuList.length) {
      return this.skuList.reduce((a, b) => a + b.count, 0);
    }
    return 0;
  }

  @Computed
  get totalDashPrice() {
    if (this.skuList.length) {
      return this.skuList.reduce((a, b) => a + b.dashPrice * b.count, 0);
    }
    return 0;
  }

  @Computed
  get finalPrice() {
    return this.totalPrice - this.discountPrice;
  }

  async initData(preOrderRequest: PreOrderRequest) {
    this.isLoading = true;
    this.preOrderRequest = preOrderRequest;
    getDefaultAddress().then((res) => {
      if (res) {
        this.customerName = res.name;
        this.customerPhone = res.phone;
        this.customerAddress = res.province + res.city + res.district + res.street + res.detail;
      }
    });
    client.order
      .getProOrderInfo(preOrderRequest)
      .then((info: PreOrderInfoDto) => {
        this.skuList = info.skuList;
        this.totalPrice = info.totalPrice;
        this.isLoading = false;
      });
  }

  onSubmit() {
    if (!this.preOrderRequest) {
      return;
    }
    if (this.shippingIndex === ShippingOption.EXPRESS &&
      (!this.customerName || !this.customerAddress)
    ) {
      promptAction.showToast({ message: '请选择地址' });
      return;
    }

    this.createOrder()
      .then((data) => {
        // todo: 此处需要根据云端返回的订单信息拉起华为支付
        paymentService
          .requestPayment(getContext() as common.UIAbilityContext, '')
          .then(() => {
          })
          .catch(() => {
          })
          .finally(() => {
            const codes: string[] = [];
            this.preOrderRequest!.items.forEach((item) => {
              codes.push(item.skuCode);
            });
            client.cart.deleteSkuFromCart(codes);
            routerStack.replacePathByName(RouterMap.ORDER_INFO, data);
          });
      });
  }

  // todo: 创建订单，此处为mock实现
  async createOrder() {
    const address: Address = this.shippingIndex === ShippingOption.EXPRESS ?
      {
        name: this.customerName,
        cellphone: this.customerPhone,
        address: this.customerAddress,
      } :
      {
        name: this.customerName,
        cellphone: this.SHOP_PHONE,
        address: this.SHOP_ADDRESS,
      };
    const data: OrderCardDto = {
      type: this.shippingIndex,
      time: formatFullDate(new Date()),
      orderCode: 'mock_order_code_' + new Date().getTime(),
      statusDesc: this.shippingIndex === ShippingOption.EXPRESS ? '待发货' : '待收货',
      remark: this.remark,
      skuList: this.skuList,
      logisticsInfo: [],
      totalPrice: this.finalPrice,
      receivingMethod: this.ShippingLabel,
      address,
      remainingTime: '00:30:00',
      discount: this.discountPrice,
    };
    this.orderList.list.push(data);
    return Promise.resolve(data);
  }
}