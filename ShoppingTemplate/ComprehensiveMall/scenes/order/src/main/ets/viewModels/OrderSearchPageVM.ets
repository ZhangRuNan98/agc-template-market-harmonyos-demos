import { OrderCardDto} from 'lib_foundation';
import { AddressModel, OrderCardVM } from '../http/Type';
import { OrderApi } from '../http/Api';

@ObservedV2
export class OrderSearchPageVM {
  private static _instance: OrderSearchPageVM;
  public controller: SearchController = new SearchController();
  @Trace public placeholder: string = '输入商品名称';
  @Trace public submit: string = '';
  @Trace public orderCards: OrderCardVM[] = [];
  @Trace public isLoading: boolean = true;
  @Trace public showLoading: boolean = false;

  onSubmit(value: string) {
    this.isLoading = true;
    OrderApi.getOrderListByName(value)
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
          card.address = cards[i].address as AddressModel;
          card.remark = cards[i].remark;
          card.refundTime = cards[i].refundTime ?? '';
          orderCards.push(card);
        }
        this.orderCards = orderCards;
        this.isLoading = false;
      })
      .finally(() => {
        this.showLoading = false;
      });
  }

  public static get instance() {
    if (!OrderSearchPageVM._instance) {
      OrderSearchPageVM._instance = new OrderSearchPageVM();
    }
    return OrderSearchPageVM._instance;
  }
}
