import { common } from '@kit.AbilityKit';
import { paymentService } from '@kit.PaymentKit';
import { OrderList, OrderCardDto } from '@scene/order';
import { OrderSkuDto, PreOrderInfoDto, PreOrderRequest, SimpleDialog } from 'lib_foundation';
import { routerStack } from 'lib_foundation';
import { client } from 'lib_network';
import { AppStorageV2, promptAction, UIContext } from '@kit.ArkUI';
import { formatFullDate } from '../Utils';

@ObservedV2
export class MockCart {
  @Trace data: string = '';
}

@ObservedV2
export class OrderSubmitPageLogic {
  @Trace
  public uiContext: UIContext;
  @Trace
  public isLoading: boolean = true;
  @Trace
  public skuList: OrderSkuDto[] = [];
  @Trace
  public totalPrice: number = 0;
  @Trace
  public addressDesc: string = '请填写收件人地址';
  @Trace
  public nickname: string = '请填写收件人信息';
  @Trace
  public phone: string = '';
  @Trace
  public remark: string = '';
  @Trace
  public remarkCache: string = '';
  @Trace
  public isShowRemarkEditor: boolean = false;
  @Trace
  positionX: number = 0
  @Trace
  toggleName: string = '快递发货'
  @Trace
  shopAddress: string = '高新万达金街32-3-1'
  @Trace
  shopPhone: string = '16253476542'
  @Trace
  tempShopPhone: string = ''
  @Trace
  preOrderRequest: PreOrderRequest | null = null;
  @Trace orderList: OrderList = AppStorageV2.connect(OrderList, () => new OrderList())!;
  public readonly init = (preOrderRequest: PreOrderRequest | null) => {
    if (!preOrderRequest) {
      return;
    }
    this.preOrderRequest = preOrderRequest
    client.order
      .getProOrderInfo(preOrderRequest)
      .then((info: PreOrderInfoDto) => {
        this.skuList = info.skuList;
        this.totalPrice = info.totalPrice;
        this.isLoading = false;
      });
  };
  public readonly onSubmit = () => {
    if (this.toggleName === '快递发货') {
      if (!this.nickname || !this.phone || !this.addressDesc) {
        promptAction.showToast({ message: '请选择地址', alignment: Alignment.Center })
        return
      }
    }
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

        if (this.preOrderRequest && this.preOrderRequest.removeFromCart) {
          const codes: string[] = []
          this.preOrderRequest.items.forEach((item) => {
            codes.push(item.skuCode)
          })
          client.cart.deleteSkuFromCart(codes)
        }

        const data: OrderCardDto = {
          type: 2,
          time: formatFullDate(new Date()),
          orderCode: 'mock_order_code_' + (Math.floor((Math.random() * (9999 - 1000))) + 1000).toString(),
          statusDesc: '待收货',
          remark: this.remark,
          skuList: this.skuList,
          logisticsInfo: [],
          totalPrice: this.totalPrice,
          address: {
            name: this.nickname,
            cellphone: this.phone,
            address: this.addressDesc,
          },
        }
        if (this.toggleName === '到店自提') {
          data.type = 3
          data.receivingMethod = '到店自提'
          data.address.cellphone = this.shopPhone
          data.address.address = this.shopAddress
        }
        this.orderList.list.push(data)
        routerStack.replacePathByName('OrderListPage', 0);
      });
  };

  public closeRemarkEditor = (): void => {
    if (this.remarkCache !== this.remark) {
      const dialog: SimpleDialog = new SimpleDialog(this.uiContext)
        .setMessage('保存您的修改')
        .setConfirmButtonText('保存')
        .setCancelButtonText('不保存')
        .onConfirm(() => {
          this.remark = this.remarkCache;
          this.isShowRemarkEditor = false;
        })
        .onCancel(() => this.isShowRemarkEditor = false)
        .onWillDismiss(() => true);
      dialog.open();
    } else {
      this.isShowRemarkEditor = false;
    }
  }

  constructor(ctx: UIContext) {
    this.uiContext = ctx;
  }
}
