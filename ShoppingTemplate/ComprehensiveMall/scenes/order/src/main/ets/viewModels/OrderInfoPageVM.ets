import { routerStack } from 'lib_foundation';
import { Address, OrderCardVM } from '../http/Type';
import { common } from '@kit.AbilityKit';
import { paymentService } from '@kit.PaymentKit';
import { OrderApi } from '../http/Api';
import { formatTime } from '../utils';

@ObservedV2
export class OrderInfoPageVM {
  private static _instance: OrderInfoPageVM;
  @Trace orderInfo: OrderCardVM | undefined;
  @Trace address: Address = new Address();
  @Trace time: string = '00:30:00';
  @Trace timer: number = 0;
  @Trace oldPrice: number = 0
  @Trace tempShopPhone: string = ''

  init() {
    const params: OrderCardVM[] = routerStack.getParamByName(
      'OrderInfoPage',
    ) as OrderCardVM[];
    if (params.length && params[params.length - 1]) {
      this.orderInfo = params[params.length - 1] as OrderCardVM;
      this.address.name = this.orderInfo.address.name;
      this.address.cellphone = this.orderInfo.address.cellphone;
      this.address.address = this.orderInfo.address.address;
      this.time = this.orderInfo.remainingTime
      this.orderInfo.skuList.forEach((item) => {
        if (item.oldPrices) {
          this.oldPrice += item.oldPrices
        }
      })
      this.setTime();
    }
  }

  clear() {
    clearInterval(this.timer);
    this.timer = 0;
  }

  async getOrderInfo() {
    const res = await OrderApi.getOrderInfo(this.orderInfo!.orderCode);
    this.orderInfo = res as OrderCardVM;
  }

  // 待支付订单设置定时器
  setTime() {
    this.timer = setInterval(() => {
      this.time = formatTime(this.time);
    }, 1000);
  }

  public prepay() {
    const context: common.UIAbilityContext = getContext(
      this,
    ) as common.UIAbilityContext;
    paymentService
      .requestPayment(context, '')
      .then(() => {
      })
      .catch(() => {
      });
  }

  public static get instance() {
    if (!OrderInfoPageVM._instance) {
      OrderInfoPageVM._instance = new OrderInfoPageVM();
    }
    return OrderInfoPageVM._instance;
  }
}
