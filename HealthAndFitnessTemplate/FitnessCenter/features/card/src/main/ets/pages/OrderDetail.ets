import {
  BookingRecordInfo,
  CardInfo,
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

@Component
export struct OrderDetail {
  @Prop pathStack: NavPathStack;
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @StorageLink('accountUpdate') accountUpdate: boolean = false;
  @Prop orderInfo: OrderInfo;
  @State bookingRecord?: BookingRecordInfo = undefined;
  @State courseBookingInfo?: CourseBookingInfo = undefined;
  @State courseDetailInfo?: CourseDetailModel = undefined;
  @State cardDetailInfo?: CardInfo = undefined;

  build() {
    NavDestination() {
      TitleBar({ title: '订单详情', pathStack: this.pathStack })
        .margin({ left: 16, right: 16 })
      Stack() {
        Scroll() {
          Column() {
            Column() {
              Image($r(this.orderInfo.orderState === OrderState.COMPLETED ? 'app.media.order_complete' :
                'app.media.order_to_pay'))
                .width(80)
                .height(80)
                .margin({ bottom: 8 })
              Text(this.orderInfo.orderState === OrderState.COMPLETED ? '订单已完成！' : '请尽快支付')
                .fontSize(14)
                .opacity(0.4)
                .margin({ bottom: 16 })
              // 消费信息
              Column({ space: 16 }) {
                Text('消费信息')
                  .fontWeight(FontWeight.Bold)
                  .fontSize(14)

                Row() {
                  Image($r(this.orderInfo.orderType === OrderType.CARD ? this.cardDetailInfo?.advImage :
                    this.courseDetailInfo?.advImage))
                    .width(80)
                    .height(80)
                    .borderRadius(8)
                  Text(this.orderInfo.orderType === OrderType.CARD ? this.cardDetailInfo?.shortName :
                    this.courseDetailInfo?.courseName)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .margin({ left: 16, top: 5 })
                }
                .alignItems(VerticalAlign.Top)


                Row() {
                  Text('数量')
                    .fontSize(14)
                  Text(this.orderInfo.number.toString())
                    .fontSize(14)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)

                Row() {
                  Text('合计')
                    .fontSize(14)
                  Text('¥' + this.orderInfo.price * this.orderInfo.number)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)

                Row() {
                  Text('实际支付')
                    .fontSize(14)
                  Text('¥' + this.orderInfo.price * this.orderInfo.number)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .visibility(this.orderInfo.orderState === OrderState.COMPLETED ? Visibility.Visible : Visibility.None)
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')
              .borderRadius(16)
              .backgroundColor($r('sys.color.comp_background_list_card'))
              .padding(16)
              .margin({ bottom: 16 })

              // 订单信息
              Column({ space: 16 }) {
                Text('订单信息')
                  .fontWeight(FontWeight.Bold)
                  .fontSize(14)

                Row() {
                  Text('订单编号')
                    .fontSize(14)
                  Text(this.orderInfo.id)
                    .fontSize(14)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)

                Row() {
                  Text('创建时间')
                    .fontSize(14)
                  Text(DateUtil.formatDate(DateUtil.parseDateString(this.orderInfo.createTime), '.', 'short', 'medium'))
                    .fontSize(14)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)

                if (this.orderInfo.payTime) {
                  Row() {
                    Text('支付时间')
                      .fontSize(14)
                    Text(DateUtil.formatDate(DateUtil.parseDateString(this.orderInfo.payTime!), '.', 'short', 'medium'))
                      .fontSize(14)
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                }
              }
              .alignItems(HorizontalAlign.Start)
              .width('100%')
              .borderRadius(16)
              .backgroundColor($r('sys.color.comp_background_list_card'))
              .padding(16)
              .margin({ bottom: 16 })
            }
            .layoutWeight(1)

            Row() {
              Text('立即支付')
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontColor($r('sys.color.comp_background_list_card'))
                .fontWeight(FontWeight.Medium)
                .fontSize(16)
            }
            .height(40)
            .margin({ left: 12, right: 12 })
            .backgroundColor('#FF9019')
            .borderRadius(20)
            .visibility(this.orderInfo.orderState === OrderState.COMPLETED ? Visibility.None : Visibility.Visible)
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
                MockService.dataPreferences.putSync('order', JSON.stringify(MockService.orderList))
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
          }
        }
        .margin({ left: 16, right: 16 })
        .scrollBar(BarState.Off)
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      this.orderInfo = ctx?.pathInfo?.param as OrderInfo;
      if (this.orderInfo.orderType === OrderType.CARD) {
        this.cardDetailInfo = MockService.getCardById(this.orderInfo.cardId!)
      } else {
        this.bookingRecord = MockService.getBookingRecordById(this.orderInfo.bookingId!)
        this.courseBookingInfo = MockService.getCourseBookingById(this.bookingRecord.courseBookingId!)
        this.courseDetailInfo = MockService.getCourseById(this.courseBookingInfo.courseId)
      }
    })
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight), bottom: px2vp(this.bottomRectHeight) })

  }
}
