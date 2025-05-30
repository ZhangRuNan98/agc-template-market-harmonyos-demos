import { BookingInfo, BookState, DateUtil } from 'external_interactions';
import { TitleBar } from 'uicomponents/src/main/ets/components/TitleBar';

@Component
export struct BookingDetail {
  @Prop bookingInfo: BookingInfo;
  @Prop pathStack: NavPathStack;
  bookingDate: Date = new Date()
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @State bookingState: BookState = BookState.TO_BE_USE
  @StorageLink('clearPath') clearPath: boolean = false

  @Builder
  rowBuilder(key: string, value: string): void {
    Row() {
      Text(key)
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.Start)
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.End)
        .opacity(0.6)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    NavDestination() {
      Stack() {
        Scroll() {
          Column({ space: 16 }) {
            // 此处预约成功后再点击返回直接返回预约首页
            TitleBar({ title: '预约详情', pathStack: this.pathStack })
            // 预约二维码
            Row() {
              Column() {
                Row() {
                  Image($r('app.media.star'))
                    .height(13)
                    .width(13)
                  Text('恭喜，预约成功')
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                }
                .justifyContent(FlexAlign.Center)
                .width('100%')

                Image($r('app.media.qrCode'))
                  .width(143)
                  .height(143)
                  .margin({ top: 16 })
              }.justifyContent(FlexAlign.SpaceEvenly)
              .width('50%')
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .padding(16)
            .borderRadius(16)
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .visibility(this.bookingInfo.bookState === BookState.TO_BE_USE ? Visibility.Visible : Visibility.None)

            // 预约信息
            Column({ space: 16 }) {
              Text('预约信息')
                .textAlign(TextAlign.Start)
                .fontSize(14)
                .width('100%')
                .fontWeight(FontWeight.Bold)

              this.rowBuilder('预约课程', this.bookingInfo.courseDetail.courseName)
              this.rowBuilder('预约时间', DateUtil.formatDate(this.bookingDate, '.', 'short') +
                ' ' + this.bookingInfo.courseBookingInfo.timeStart + '~' + this.bookingInfo.courseBookingInfo.timeEnd)
              this.rowBuilder('预约人', this.bookingInfo.name)
              this.rowBuilder('预约人数', this.bookingInfo.personNum.toString())
              this.rowBuilder('手机号码', this.bookingInfo.phone)
              this.rowBuilder('备注',
                (this.bookingInfo.remark === undefined || this.bookingInfo.remark.length === 0) ? '无' :
                this.bookingInfo.remark)
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .padding(16)
            .borderRadius(16)
            .backgroundColor($r('sys.color.comp_background_list_card'))


            Text('预约课程时间已自动加入日历')
              .textAlign(TextAlign.Center)
              .opacity(0.4)
              .fontSize(10)
              .width('100%')
              .fontWeight(FontWeight.Regular)
          }
        }.margin({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      this.bookingInfo = ctx?.pathInfo?.param as BookingInfo;
      this.bookingDate = DateUtil.parseDateString(this.bookingInfo.courseBookingInfo.date)
    })
    .padding({ top: px2vp(this.topRectHeight) })
    .backgroundColor($r('app.color.main_background_color'))
    .onBackPressed(() => {
      if (this.clearPath) {
        this.pathStack.clear()
        this.clearPath = false
      } else {
        this.pathStack.pop()
      }
      return true;
    })
  }
}
