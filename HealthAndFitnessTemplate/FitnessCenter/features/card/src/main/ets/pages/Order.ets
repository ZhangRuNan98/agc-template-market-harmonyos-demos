import {
  BookingRecordInfo,
  CardInfo,
  ConsumeType,
  CourseBookingInfo,
  CourseDetailModel,
  DateUtil,
  MockService,
  OrderInfo,
  OrderState,
  OrderType
} from 'external_interactions';
import { TitleBar } from 'uicomponents';
import { promptAction } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';

@Component
export struct Order {
  stateList: OrderState[] =
    [OrderState.ALL, OrderState.COMPLETED, OrderState.TO_BE_PAY]
  @Prop pathStack: NavPathStack;
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @State currentTabIndex: number = 0;

  @Builder
  tabBarBuilder(orderState: OrderState, index: number) {
    Text(MockService.getOrderStateString(orderState))
      .height('100%')
      .fontSize(14)
      .fontWeight(this.currentTabIndex === index ? FontWeight.Bold : FontWeight.Regular)
      .border({
        width: { bottom: this.currentTabIndex === index ? 2 : 0 },
        color: '#000000'
      })
  }

  build() {
    NavDestination() {
      TitleBar({ title: '我的订单', pathStack: this.pathStack })
        .margin({ left: 16, right: 16 })
      Tabs() {
        ForEach(this.stateList, (item: OrderState, index: number) => {
          TabContent() {
            OrderContent({
              orderState: item,
              pathStack: this.pathStack,
              currentTabIndex: this.currentTabIndex,
              index: index
            })
          }
          .tabBar(this.tabBarBuilder(item, index))
        }, (item: OrderState) => JSON.stringify(item))
      }
      .divider({ strokeWidth: 1 })
      .barHeight(50)
      .barMode(BarMode.Fixed)
      .layoutWeight(1)
      .backgroundColor($r('app.color.main_background_color'))
      .onChange((index: number) => {
        this.currentTabIndex = index
      })
    }.hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
    })
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight) })
  }
}

@Component
struct OrderContent {
  @Prop orderState: OrderState
  @State orderList: OrderInfo[] = []
  pathStack: NavPathStack = new NavPathStack();
  @Prop @Watch('tabIndexChange') currentTabIndex: number
  @Prop index: number
  @StorageLink('accountUpdate') @Watch('tabIndexChange') accountUpdate: boolean = false;

  aboutToAppear(): void {
    this.orderList = MockService.getOrderListByState(this.orderState)
  }

  build() {
    Column() {
      Column() {
        Image($r('app.media.no_result'))
          .width(144)
          .height(144)
          .margin({ bottom: 12 })
        Text('未查询到订单信息')
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
          .fontColor('#999999')
      }
      .height('50%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .visibility(this.orderList.length > 0 ? Visibility.None : Visibility.Visible)

      List({ space: 20 }) {
        ForEach(this.orderList, (item: OrderInfo) => {
          ListItem() {
            RecordItem({ orderInfo: item, pathStack: this.pathStack })
          }
        }, (item: OrderInfo) => JSON.stringify(item))
      }
      .margin({ left: 16, right: 16 })
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .backgroundColor($r('app.color.main_background_color'))
    .margin({ top: 16, bottom: 16 })
  }

  tabIndexChange() {
    if (this.index === this.currentTabIndex) {
      this.orderList = MockService.getOrderListByState(this.orderState)
    }
  }
}

@Component
struct RecordItem {
  @Prop orderInfo: OrderInfo;
  @State bookingRecord?: BookingRecordInfo = undefined;
  @State courseBookingInfo?: CourseBookingInfo = undefined;
  @State courseDetailInfo?: CourseDetailModel = undefined;
  @State cardDetailInfo?: CardInfo = undefined;
  pathStack: NavPathStack = new NavPathStack();
  @StorageLink('accountUpdate') accountUpdate: boolean = false;

  aboutToAppear(): void {
    if (this.orderInfo.orderType === OrderType.CARD) {
      this.cardDetailInfo = MockService.getCardById(this.orderInfo.cardId!)
    } else {
      this.bookingRecord = MockService.getBookingRecordById(this.orderInfo.bookingId!)
      this.courseBookingInfo = MockService.getCourseBookingById(this.bookingRecord.courseBookingId!)
      this.courseDetailInfo = MockService.getCourseById(this.courseBookingInfo.courseId)
    }
  }

  build() {
    Column() {
      Row() {
        Text('订单时间: ' +
        DateUtil.formatDate(DateUtil.parseDateString(this.orderInfo.createTime), '.', undefined, 'medium'))
          .fontSize(14)

        Text(MockService.getOrderStateString(this.orderInfo.orderState))
          .fontSize(14)
          .fontColor(this.orderInfo.orderState === OrderState.TO_BE_PAY ? '#FF9019' : '#000000')
      }.justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(18)

      Divider()
        .margin({ top: 16, bottom: 16 })

      if (this.orderInfo.orderType === OrderType.CARD) {
        Row() {
          Image($r(this.cardDetailInfo?.advImage))
            .width(80)
            .height(80)
            .borderRadius(8)
          Column() {
            Row() {
              Text(this.cardDetailInfo?.shortName)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
              Text('¥' + this.cardDetailInfo?.price)
                .fontSize(14)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Row() {
              Text(this.cardDetailInfo?.consumeType === ConsumeType.TIMES ? this.cardDetailInfo.quota + '次' :
                MockService.getQuotaDurationDesc(this.cardDetailInfo?.quota) + '卡')
                .fontSize(14)
              Text('x' + this.orderInfo.number)
                .fontSize(14)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .justifyContent(FlexAlign.SpaceAround)
          .alignItems(HorizontalAlign.Start)
          .height('100%')
          .layoutWeight(1)
          .margin({ left: 16 })
        }.width('100%')
        .height(80)
      } else {
        Row() {
          Image($r(this.courseDetailInfo?.advImage))
            .width(80)
            .height(80)
            .borderRadius(8)
          Column() {
            Text(this.courseDetailInfo?.courseName)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)

            Row() {
              Text('¥' + this.courseDetailInfo?.price)
                .fontSize(14)
              Text('x' + this.orderInfo.number)
                .fontSize(14)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .justifyContent(FlexAlign.SpaceAround)
          .alignItems(HorizontalAlign.Start)
          .height('100%')
          .layoutWeight(1)
          .margin({ left: 16 })
        }.width('100%')
        .height(80)
      }

      Text('订单号：' + this.orderInfo.id)
        .fontSize(10)
        .margin({ top: 8 })

      Divider()
        .margin({ top: 16, bottom: 16 })
      Row() {
        Text('订单金额：¥' + this.orderInfo.price * this.orderInfo.number)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Button('去支付')
          .fontSize($r('sys.float.Body_M'))
          .width(100)
          .fontColor($r('sys.color.comp_background_list_card'))
          .borderRadius($r('sys.float.corner_radius_level4'))
          .type(ButtonType.Normal)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#FF9019')
          .margin({ left: 16 })
          .onClick(() => {
            if (MockService.account.balance >= this.orderInfo.price) {
              MockService.account.balance -= this.orderInfo.price
              MockService.dataPreferences.putSync('account', JSON.stringify(MockService.account))
              MockService.dataPreferences.flush()
              this.orderInfo.orderState = OrderState.COMPLETED
              this.orderInfo.payTime = DateUtil.formatDate(new Date(), '-', undefined, 'medium')
              let mockOrder = MockService.getOrderById(this.orderInfo.id)
              mockOrder.orderState = OrderState.COMPLETED
              mockOrder.payTime = this.orderInfo.payTime
              MockService.dataPreferences.putSync('order',  JSON.stringify(MockService.orderList))
              MockService.dataPreferences.flush()
              if (this.orderInfo.orderType === OrderType.CARD) {
                MockService.addUserCard(this.cardDetailInfo!.id, this.cardDetailInfo!.quota)
              }
              this.accountUpdate = !this.accountUpdate
            } else {
              promptAction.showToast({ message: '余额不足' })
              this.pathStack.pushPath({ name: 'vip/VipRecharge' })
            }
          })
          .visibility(this.orderInfo.orderState === OrderState.TO_BE_PAY ? Visibility.Visible : Visibility.None)
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
    .onClick(() => {
      this.pathStack.pushPath({ name: 'card/orderDetail', param: this.orderInfo })
    })
  }
}
