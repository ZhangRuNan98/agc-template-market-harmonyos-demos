import { CardInfo, ConsumeType, MockService, OrderInfo, OrderState, OrderType } from 'external_interactions';
import { TitleBar } from 'uicomponents';

@Component
export struct BuyCard {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @Prop pathStack: NavPathStack;
  @Prop cardInfo: CardInfo;
  @State balance: number = MockService.account.balance;
  @State showFailed: boolean = false
  @StorageLink('accountUpdate') accountUpdate: boolean = false;

  @Builder
  cardShowBuilder() {
    Column() {
      Row() {
        Image($r(this.cardInfo.advImage))
          .width(80)
          .height(80)
          .borderRadius(8)
        Column() {
          Row() {
            Text(this.cardInfo.shortName)
              .textAlign(TextAlign.Start)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
            Text('¥' + this.cardInfo.price)
              .fontSize(14)
              .opacity(0.4)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Text(this.cardInfo.consumeType === ConsumeType.TIMES ? this.cardInfo.quota + '次' :
              MockService.getQuotaDurationDesc(this.cardInfo.quota) + '卡')
              .textAlign(TextAlign.Start)
              .fontSize(14)
            Text('x1')
              .fontSize(14)
              .opacity(0.4)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceEvenly)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 16 })
        .height('100%')
      }.height(80)

      Divider()
        .margin({ top: 16, bottom: 16 })

      Row() {
        Text('合计：¥' + this.cardInfo.price)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
  }

  @Builder
  orderMoneyBuilder() {
    Column() {
      Text('订单金额')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
      Row() {
        Text('会员卡（剩余¥' + this.balance + '）')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
        Text('-' + this.cardInfo.price)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .opacity(0.6)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
  }

  @Builder
  moneyNotEnoughMessage() {
    Column() {
      Image($r('app.media.money_not_enough'))
        .width(144)
        .height(144)
        .margin({ bottom: 12 })
      Text('会员卡余额不足，请前往会员卡充值界面充值！')
        .width(120)
        .fontSize(14)
        .textAlign(TextAlign.Center)
        .opacity(0.4)
    }.width(144)
    .visibility(this.showFailed ? Visibility.Visible : Visibility.None)
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: '提交订单', pathStack: this.pathStack })
          .margin({ left: 16, right: 16 })
        Scroll() {
          Column({ space: 16 }) {
            // 展示卡项
            this.cardShowBuilder()
            // 订单金额
            this.orderMoneyBuilder()
            // 金额不足提示
            this.moneyNotEnoughMessage()

          }.margin({ left: 16, right: 16 })
          .justifyContent(FlexAlign.Start)
        }
        .scrollBar(BarState.Off)
        .width('100%')

        Row() {
          Row() {
            Text(this.showFailed ? '支付失败' : '需支付：' + this.cardInfo.price + '元')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
          }.justifyContent(FlexAlign.Center)
          .width('40%')
          .height('60%')

          Text(this.showFailed ? '前往充值' : '提交订单')
            .textAlign(TextAlign.Center)
            .width('50%')
            .height('60%')
            .fontColor($r('sys.color.comp_background_list_card'))
            .fontWeight(FontWeight.Medium)
            .fontSize(14)
            .backgroundColor('#FF9019')
            .borderRadius(8)
            .onClick(() => {
              if (this.showFailed) {
                // 跳转充值页
                this.pathStack.clear(false)
                this.pathStack.pushPath({ name: 'card/order' }, false)
                this.pathStack.pushPath({ name: 'vip/VipRecharge' }, false)
                AppStorage.setOrCreate('stackAnimated', false)
              } else {
                if (this.balance >= this.cardInfo.price) {
                  // 会员卡余额充足，生成已完成订单，跳转订单详情页
                  let orderInfo: OrderInfo =
                    MockService.createOrder(OrderType.CARD, OrderState.COMPLETED, 1, this.cardInfo.price,
                      this.cardInfo.id)
                  MockService.account.balance -= this.cardInfo.price;
                  MockService.dataPreferences.putSync('account', JSON.stringify(MockService.account))
                  MockService.dataPreferences.flush()
                  this.pathStack.clear(false)
                  MockService.addUserCard(this.cardInfo.id, this.cardInfo.quota)
                  this.pathStack.pushPath({ name: 'card/orderDetail', param: orderInfo }, false)
                  this.accountUpdate = !this.accountUpdate
                } else {
                  // 会员卡余额不足，提示充值，生成未完成订单
                  this.showFailed = true
                  MockService.createOrder(OrderType.CARD, OrderState.TO_BE_PAY, 1, this.cardInfo.price,
                    this.cardInfo.id)
                }
              }
            })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .height(75)
        .width('100%')
        .padding({ bottom: 10 })
        .backgroundColor(Color.White)
        .position({ bottom: 0 })
      }
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      this.cardInfo = ctx?.pathInfo?.param as CardInfo;
    })
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight) })

  }
}
