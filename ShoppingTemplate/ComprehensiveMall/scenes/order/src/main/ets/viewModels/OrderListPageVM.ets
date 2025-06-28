import { OrderCardDto, OrderCardVM } from '../http/Type';
import { OrderApi } from '../http/Api';
import { common } from '@kit.AbilityKit';
import { paymentService } from '@kit.PaymentKit';
import { formatTime } from '../utils';
import { routerStack } from 'lib_foundation';

@ObservedV2
export class OrderListPageVM {
  private static _instance: OrderListPageVM;
  public titleArr: string[] = [
    '全部',
    '待付款',
    '待发货',
    '待收货',
    '已完成',
    '已取消',
    '退款/售后',
  ];
  @Trace public isLoading: boolean = true;
  @Trace public orderCards: OrderCardVM[] = [];
  @Trace public type: number = 0;
  @Trace public showLoading: boolean = false;
  @Trace public curIndex: number = 0;
  @Trace public curOrderCode: string = '';
  @Trace public curPrice: number = 0;
  @Trace timer: number[] = [];

  init() {
    const params: number[] = routerStack.getParamByName(
      'OrderListPage',
    ) as number[];
    if (params.length && params[params.length - 1]) {
      this.curIndex = params[params.length - 1]
      this.type = params[params.length - 1]
    } else {
      this.curIndex = 0
      this.type = 0
    }
  }

  clear() {
    this.timer.forEach((item) => {
      clearInterval(item);
    });
    this.timer = [];
  }

  public readonly refresh = (needLoading: boolean = true): void => {
    this.isLoading = needLoading;
    OrderApi.getOrderList(this.type)
      .then((cards: OrderCardDto[]) => {
        const orderCards: OrderCardVM[] = [];
        for (let i: number = cards.length - 1; i >= 0; i--) {
          const card: OrderCardVM = new OrderCardVM();
          card.type = cards[i].type;
          card.time = cards[i].time;
          card.orderCode = cards[i].orderCode;
          card.statusDesc = cards[i].statusDesc;
          card.skuList = cards[i].skuList;
          card.logisticsInfo = cards[i].logisticsInfo;
          card.totalPrice = cards[i].totalPrice;
          card.remainingTime = cards[i].remainingTime ?? '';
          card.address = cards[i].address;
          card.remark = cards[i].remark;
          card.refundTime = cards[i].refundTime ?? '';
          card.receivingMethod = cards[i].receivingMethod ?? ''
          orderCards.push(card);
        }
        this.orderCards = orderCards;
        this.isLoading = false;
      })
      .finally(() => {
        this.showLoading = false;
        this.setTime();
      });
  };

  public prepay(code: string) {
    const context: common.UIAbilityContext = getContext(
      this,
    ) as common.UIAbilityContext;
    paymentService
      .requestPayment(context, '')
      .then(() => {
      })
      .catch(() => {
      })
      .finally(() => {
        OrderApi.payOrderByCode(code).then(() => {
          this.refresh()
        })
      })
  }

  // 待支付订单设置定时器
  setTime() {
    this.orderCards.forEach((item) => {
      if (item && item.remainingTime) {
        const time = setInterval(() => {
          item.remainingTime = formatTime(item.remainingTime);
        }, 1000);
        this.timer.push(time);
      }
    });
  }

  public getState(card: OrderCardVM, type: number): string {
    if (type === 0) {
      switch (card.type) {
        case 1:
          return '待付款'
        case 2:
          return '已付款'
        case 3:
          return '已发货'
        case 4:
          return '已完成'
        case 5:
          return '已取消'
        case 6:
          return '已退款'
      }
    }
    if (type === 1 && card.remainingTime) {
      return card.remainingTime + '后取消'
    } else {
      switch (card.type) {
        case 1:
          return '待付款'
        case 2:
          return '已付款'
        case 3:
          return '已发货'
        case 4:
          return '已完成'
        case 5:
          return '已取消'
        case 6:
          return '已退款'
      }
    }
    return ''
  }

  public static get instance() {
    if (!OrderListPageVM._instance) {
      OrderListPageVM._instance = new OrderListPageVM();
    }
    return OrderListPageVM._instance;
  }
}
