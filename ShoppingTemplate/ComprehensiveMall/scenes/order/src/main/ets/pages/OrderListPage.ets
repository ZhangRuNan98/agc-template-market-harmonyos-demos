import { OrderListPageVM } from '../viewModels/OrderListPageVM';
import { OrderApi } from '../http/Api';
import { OrderCardVM, OrderSkuDto } from '../http/Type'
import { CustomContentDialog, LengthMetrics, promptAction, TipsDialog } from '@kit.ArkUI';
import { CommonButton } from '../components/CommonButton';
import { emitter } from '@kit.BasicServicesKit';
import {
  buildProductGhostSearchBar,
  CallButton,
  PreOrderItem,
  PreOrderRequest,
  routerStack,
  Style,
  TitleBar
} from 'lib_foundation';
import { client } from 'lib_network';
import { AddressManage } from 'module_address_manage';
import { buildSkuCard, OrderType } from '../common';

@ComponentV2
struct OrderListPage {
  vm: OrderListPageVM = OrderListPageVM.instance
  private tabsController: TabsController = new TabsController();
  dialogControllerDelete: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      content: '是否删除当前订单?',
      primaryButton: {
        value: '取消',
        action: () => {
          console.info('Callback when the first button is clicked')
        },
      },
      secondaryButton: {
        value: '删除',
        role: ButtonRole.ERROR,
        action: () => {
          this.vm.showLoading = true;
          OrderApi.deleteOrder(this.vm.curOrderCode)
            .then(() => this.vm.refresh(false))
          this.dialogControllerDelete.close()
        }
      },
    }),
  })
  dialogControllerCancel: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      content: '是否取消当前订单?',
      primaryButton: {
        value: '取消',
        action: () => {
          console.info('Callback when the first button is clicked')
        },
      },
      secondaryButton: {
        value: '确认',
        role: ButtonRole.ERROR,
        action: () => {
          this.vm.showLoading = true;
          OrderApi.cancelOrderByCode(this.vm.curOrderCode)
            .then(() => this.vm.refresh(false))
          this.dialogControllerCancel.close()
        }
      },
    }),
  })
  dialogControllerRefund: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      content: '是否退款?',
      primaryButton: {
        value: '取消',
        action: () => {
          console.info('Callback when the first button is clicked')
        },
      },
      secondaryButton: {
        value: '确认',
        role: ButtonRole.ERROR,
        action: () => {
          this.vm.showLoading = true;
          OrderApi.refundOrderByCode(this.vm.curOrderCode)
            .then(() => this.vm.refresh(false))
          this.dialogControllerRefund.close()
        }
      },
    }),
  })

  aboutToAppear(): void {
    this.vm.init()
    this.vm.refresh()
    emitter.on('updateOrder', (data) => {
      if (data.data) {
        this.vm.refresh()
      }
    })
  }

  aboutToDisappear(): void {
    this.vm.clear()
    emitter.off('updateOrder')
  }

  build(): void {
    NavDestination() {
      Column() {
        TitleBar({
          barPadding: { right: Style.MENU_BAR_MARGIN_RIGHT },
          barColor: Color.White
        }) {
          buildProductGhostSearchBar('搜索我的订单', () => routerStack.pushPathByName('OrderSearchPage', null, false))
        }

        Tabs({ controller: this.tabsController }) {
          ForEach(this.vm.titleArr, (item: string, index: number) => {
            TabContent().tabBar(this.tabBuilder(index, item))
          }, (item: string, index: number) => index + '__' + item)
        }
        .onTabBarClick((index: number) => {
          this.vm.curIndex = index;
          this.vm.type = index
          this.vm.refresh()
        })
        .barMode(BarMode.Scrollable)
        .height(44)
        .width('100%')

        Column() {
          this.buildContent()
        }
        .layoutWeight(1)
      }
    }
    .hideTitleBar(true)
    .onShown(() => {
      this.tabsController.changeIndex(this.vm.curIndex);
    })
  }

  @Builder
  tabBuilder(index: number, title: string) {
    Column() {
      Row() {
        Text(title)
          .fontColor(this.vm.curIndex === index ? '#E64566' :
          $r('sys.color.font_primary'))
          .fontSize(14)
          .fontWeight(this.vm.curIndex === index ? FontWeight.Medium : FontWeight.Regular)
          .margin({ top: 4 })
      }
      .padding({ bottom: 9 })
      .borderWidth(this.vm.curIndex === index ? { bottom: 3 } : {})
      .borderColor(this.vm.curIndex === index ? '#E64566' : '')
    }
    .height(44)
    .justifyContent(FlexAlign.End)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  buildContent() {
    if (this.vm.isLoading) {
      Column() {
        LoadingProgress()
          .width(37)
          .height(37)
          .offset({ y: -50 })
      }
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM])
      .justifyContent(FlexAlign.Center)
    } else {
      Stack() {
        Scroll() {
          if (this.vm.orderCards.length === 0) {
            Column() {
              Column() {
                Image($r('app.media.empty_status_logo'))
                  .width(160)
                  .height(160)
                  .draggable(false)
                  .objectFit(ImageFit.Cover)
                  .margin({ bottom: 15 })
                Text('您还没有相关订单')
                  .fontSize(13)
                  .fontColor($r('sys.color.mask_secondary'))
                  .margin({ bottom: 15 })
              }
              .width('100%')
              .height('45%')
              .borderRadius(12)
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
            }
            .height('100%')
            .justifyContent(FlexAlign.Start)
            .padding(12)
          } else {
            Column() {
              ForEach(this.vm.orderCards, (card: OrderCardVM, index: number) => {
                this.buildOrderCard(card, index)
              }, (item: OrderCardVM[]) => JSON.stringify(item))
            }
            .width('100%')
            .constraintSize({ minHeight: '100%' })
            .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM])
            .padding({ left: 12, right: 12 })
          }
        }
        .height('100%')
        .scrollBar(BarState.Off)
        .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM])

        if (this.vm.showLoading) {
          Column() {
            LoadingProgress()
              .width(37)
              .height(37)
              .offset({ y: -50 })
          }
          .width('100%')
          .height('100%')
          .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM])
          .justifyContent(FlexAlign.Center)
        }
      }
      .backgroundColor('#F1F3F5')
    }
  }

  @Builder
  buildOrderCard(card: OrderCardVM, index: number) {
    Column() {
      Row() {
        Text(card.time)
          .fontSize(12)
          .fontColor($r('sys.color.mask_tertiary'))
        Text(this.vm.getState(card, this.vm.type))
          .fontSize(13)
          .fontColor('#FFE64566')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        ForEach(card.skuList, (sku: OrderSkuDto) => {
          buildSkuCard(sku)
        }, (item: OrderSkuDto[]) => JSON.stringify(item))
      }
      .onClick(() => {
        routerStack.pushPathByName('OrderInfoPage', card)
      })

      Row() {
        Text('总价¥' + card.totalPrice)
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
          .margin({ right: 8 })
        Text('实付')
          .fontColor($r('sys.color.mask_tertiary'))
          .fontSize(12)
        Text('¥' + card.totalPrice)
          .fontColor('#E6000000')
          .fontSize(14)
          .fontWeight(600)
      }
      .width('100%')
      .margin({ top: 13 })
      .justifyContent(FlexAlign.End)

      Row() {
        if (card.type === OrderType.PENDING_PAY) {
          this.buildCancelButton(card)
          this.buildAddressButton(card)
          this.buildPaymentButton(card)
        } else if (card.type === OrderType.PENDING_SEND) {
          this.buildRefundButton(card)
          this.buildAddCartButton(card)
          this.buildSendButton(card)
        } else if (card.type === OrderType.PENDING_GET) {
          this.buildRefundButton(card)
          this.buildAddCartButton(card)
          this.buildAgreeButton(card)
        } else if (card.type === OrderType.SUCCESS) {
          this.buildDeleteButton(card)
          this.buildAddCartButton(card)
          this.buildPayAgainButton(card)
        } else if (card.type === OrderType.CANCEL) {
          this.buildDeleteButton(card)
          this.buildPayAgainButton(card)
        } else if (card.type === OrderType.REFUND) {
          this.buildDeleteButton(card)
        }
      }
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(12)
    .borderRadius(13)
    .backgroundColor(Color.White)
    .margin(this.vm.orderCards.length - 1 !== index ? { top: 12 } : { top: 12, bottom: 12 })
    .alignItems(HorizontalAlign.End)
  }

  @Builder
  buildDeleteButton(card: OrderCardVM) {
    Button() {
      Text('删除订单')
        .fontSize(12)
        .fontColor($r('sys.color.mask_secondary'))
    }
    .width(64)
    .height(28)
    .type(ButtonType.Normal)
    .backgroundColor(Color.White)
    .borderWidth(1)
    .borderColor($r('sys.color.mask_secondary'))
    .borderRadius(23)
    .margin({ left: 8 })
    .onClick(() => {
      this.vm.curOrderCode = card.orderCode
      this.dialogControllerDelete.open()
    })
  }

  @Builder
  buildCancelButton(card: OrderCardVM) {
    Button() {
      Text('取消订单')
        .fontSize(12)
        .fontColor($r('sys.color.mask_secondary'))
    }
    .width(64)
    .height(28)
    .type(ButtonType.Normal)
    .backgroundColor(Color.White)
    .borderWidth(1)
    .borderColor($r('sys.color.mask_secondary'))
    .borderRadius(23)
    .margin({ left: 8 })
    .onClick(() => {
      this.vm.curOrderCode = card.orderCode
      this.dialogControllerCancel.open()
    })
  }

  @Builder
  buildPaymentButton(card: OrderCardVM) {
    Button() {
      Text('去支付')
        .fontSize(12)
        .fontColor(Color.White)
    }
    .width(64)
    .height(28)
    .type(ButtonType.Normal)
    .backgroundColor('#FFE64566')
    .borderRadius(23)
    .margin({ left: 8 })
    .onClick(() => {
      this.vm.curOrderCode = card.orderCode
      this.vm.curPrice = card.totalPrice
      this.vm.prepay(card.orderCode)
    })
  }

  @Builder
  buildRefundButton(card: OrderCardVM) {
    Button() {
      Text('退款')
        .fontSize(12)
        .fontColor($r('sys.color.mask_secondary'))
    }
    .width(64)
    .height(28)
    .type(ButtonType.Normal)
    .backgroundColor(Color.White)
    .borderWidth(1)
    .borderColor($r('sys.color.mask_secondary'))
    .borderRadius(23)
    .margin({ left: 8 })
    .onClick(() => {
      this.vm.curOrderCode = card.orderCode
      this.dialogControllerRefund.open()
    })
  }

  @Builder
  buildAgreeButton(card: OrderCardVM) {
    Button() {
      Text('确认收货')
        .fontSize(12)
        .fontColor(Color.White)
    }
    .width(64)
    .height(28)
    .type(ButtonType.Normal)
    .backgroundColor('#FFE64566')
    .borderRadius(23)
    .margin({ left: 8 })
    .onClick(() => {
      this.vm.showLoading = true;
      OrderApi.agreeOrderByCode(card.orderCode)
        .then(() => this.vm.refresh(false))
    })
  }

  @Builder
  buildAddressButton(card: OrderCardVM) {
    AddressManage({
      navPathStack: routerStack,
      isSelectMode: true,
      onSelect: (data) => {
        card.address.name = data.name
        card.address.cellphone = data.phone
        card.address.address = data.province + data.city + data.district + data.street + data.detail
        OrderApi.updateOrderAddressByCode(card.orderCode, card.address)
      }
    }) {
      Button() {
        Text('修改地址')
          .fontSize(12)
          .fontColor('#E64566')
      }
      .width(64)
      .height(28)
      .type(ButtonType.Normal)
      .backgroundColor(Color.White)
      .borderRadius(23)
      .borderWidth(1)
      .borderColor('#E64566')
      .margin({ left: 8 })
    }
  }

  @Builder
  buildAddCartButton(card: OrderCardVM) {
    Button() {
      Text('加入购物车')
        .fontSize(12)
        .fontColor('#E64566')
    }
    .width(76)
    .height(28)
    .type(ButtonType.Normal)
    .backgroundColor(Color.White)
    .borderRadius(23)
    .borderWidth(1)
    .borderColor('#E64566')
    .margin({ left: 8 })
    .onClick(() => {
      card.skuList.forEach((item) => {
        client.cart.addSkuToCart(item.skuCode, item.count)
      })
      promptAction.showToast({ message: '成功加入购物车', alignment: Alignment.Center });
    })
  }

  @Builder
  buildSendButton(card: OrderCardVM) {
    Button() {
      Text('催发货')
        .fontSize(12)
        .fontColor(Color.White)
    }
    .width(64)
    .height(28)
    .type(ButtonType.Normal)
    .backgroundColor('#FFE64566')
    .borderRadius(23)
    .margin({ left: 8 })
    .onClick(() => {
      promptAction.showToast({ message: '已提醒商家发货', alignment: Alignment.Center })
    })
  }

  @Builder
  buildPayAgainButton(card: OrderCardVM) {
    Button() {
      Text('再买一单')
        .fontSize(12)
        .fontColor(Color.White)
    }
    .width(64)
    .height(28)
    .type(ButtonType.Normal)
    .backgroundColor('#FFE64566')
    .borderRadius(23)
    .margin({ left: 8 })
    .onClick(() => {
      const items: PreOrderItem[] = [];
      for (let sku of card.skuList) {
        const preOrderItem: PreOrderItem = {
          skuCode: sku.skuCode,
          quantity: sku.count
        };
        items.push(preOrderItem);
      }
      const preOrderRequest: PreOrderRequest = {
        items: items,
        removeFromCart: true
      };
      routerStack.pushPathByName('OrderSubmitPage', preOrderRequest);
    })
  }

  @Builder
  buildCallButton() {
    CallButton() {
      Button() {
        Text('联系商家')
          .fontSize(13)
          .fontColor(Color.White)
      }
      .width(80)
      .height(30)
      .type(ButtonType.Normal)
      .backgroundColor('#FFE64566')
      .borderRadius(18)
      .margin({ left: 8 })
    }
  }

  @Builder
  tabBarBuilder(index: number, title: string) {
    Column() {
      Row() {
        Text(title)
          .fontColor(this.vm.curIndex === index ? '#E64566' :
          $r('sys.color.font_primary'))
          .fontSize(14)
          .fontWeight(this.vm.curIndex === index ? FontWeight.Medium : FontWeight.Regular)
          .margin({ top: 4 })
      }
      .padding({ bottom: 9 })
      .borderWidth(this.vm.curIndex === index ? { bottom: 3 } : {})
      .borderColor(this.vm.curIndex === index ? '#E64566' : '')
    }
    .width('100%')
    .height(44)
    .justifyContent(FlexAlign.End)
  }
}

@Builder
export function buildOrderListPage() {
  OrderListPage()
}
