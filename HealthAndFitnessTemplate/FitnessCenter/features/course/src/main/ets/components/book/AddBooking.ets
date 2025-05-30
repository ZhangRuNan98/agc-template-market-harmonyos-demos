import { promptAction } from '@kit.ArkUI';
import { BookingInfo, CourseBookingInfo, CourseDetailModel, DateUtil, MockService } from 'external_interactions';
import { TitleBar } from 'uicomponents/src/main/ets/components/TitleBar';

@Component
export struct AddBooking {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @Prop courseBookingInfo: CourseBookingInfo;
  courseDetail?: CourseDetailModel = undefined
  bookingDate: Date = new Date()
  @State phone: string = ''
  @State name: string = ''
  @State personNum: number = 1
  @State remark: string = ''
  @Prop pathStack: NavPathStack;
  remarkMaxCount: number = 50;
  @State remarkInputCount: number = 0;
  @State totalPrice: number = 0;

  @Builder
  courseInfoBuilder() {
    Row() {
      Row() {
        Image($r(this.courseDetail?.advImage))
          .width(56)
          .height(56)
          .borderRadius(4)
        Column() {
          Text(this.courseDetail?.courseName)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text('¥' + this.courseDetail?.price)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .height('100%')
        .margin({ left: 16 })

        Row() {
          Row() {
            Text('查看详情')
              .height('100%')
              .fontSize(10)
              .fontWeight(FontWeight.Regular)
              .opacity(0.6)
            Image($r('app.media.chevron_right'))
              .height('100%')
          }
          .height(20)
          .padding({ left: 5 })
          .borderRadius({ topLeft: 8, bottomLeft: 8 })
          .backgroundColor($r('app.color.main_background_color'))
          .onClick(() => {
            this.pathStack.pushPath({ name: 'course/CourseDetail', param: this.courseDetail })
          })
        }
        .height('100%')
        .alignItems(VerticalAlign.Top)
        .onClick(() => {
        })
      }.height(56)
    }
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .width('100%')
    .padding({ left: 16, top: 16, bottom: 16 })
  }

  @Builder
  bookingTimeBuilder() {
    Row() {
      Row() {
        Column() {
          Text('预约时间')
            .fontWeight(FontWeight.Bold)
            .fontSize(14)
        }
        .height('100%')

        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.End
        }) {
          Text(this.courseBookingInfo.timeStart + '-' + this.courseBookingInfo.timeEnd)
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
            .fontColor('#FF9019')
          Text(DateUtil.formatDate(this.bookingDate, '.', 'long'))
            .fontSize(12)
            .fontWeight(FontWeight.Regular)
            .fontColor('#666666')
        }
        .height('100%')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height(39)
    }
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .width('100%')
    .padding(16)
  }

  @Builder
  bookingPersonInfo() {
    Row() {
      Column() {
        Text('预约人信息')
          .textAlign(TextAlign.Start)
          .fontSize(14)
          .width('100%')
          .fontWeight(FontWeight.Bold)
        Row() {
          Text('手机号码')
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
            .width('20%')
            .textAlign(TextAlign.Start)
          TextInput({ placeholder: '请输入手机号码(必填)', text: this.phone })
            .type(InputType.Number)
            .placeholderFont({ size: $r('sys.float.Body_S'), weight: FontWeight.Regular })
            .placeholderColor($r('sys.color.font_tertiary'))
            .width('60%')
            .fontSize(12)
            .fontWeight(FontWeight.Regular)
            .borderRadius(0)
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .onChange((value) => {
              this.phone = value;
            })
          Text('一键获取')
            .fontSize(12)
            .fontColor('#FF9019')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 5 })
            .onClick(() => {
              this.getUserInfo()
            })
        }
        .width('100%')

        Divider()

        Row() {
          Text('姓名')
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
            .width('20%')
            .textAlign(TextAlign.Start)
          TextInput({ placeholder: '请输入联系人姓名(必填)', text: this.name })
            .placeholderFont({ size: $r('sys.float.Body_S'), weight: FontWeight.Regular })
            .placeholderColor($r('sys.color.font_tertiary'))
            .width('80%')
            .fontSize(12)
            .fontWeight(FontWeight.Regular)
            .borderRadius(0)
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .onChange((value) => {
              this.name = value;
            })
        }
        .width('100%')

        Divider()
        Row() {
          Text('预约人数')
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
            .width('20%')
            .textAlign(TextAlign.Start)
          Row() {
            Image($r('app.media.minus'))
              .borderRadius(800)
              .backgroundColor($r('app.color.main_background_color'))
              .height(32)
              .width(32)
              .padding(4)
              .onClick(() => {
                if (this.personNum > 1) {
                  this.personNum--;
                  this.totalPrice = this.personNum * this.courseDetail!.price;
                }
              })
            Text(this.personNum.toString())
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .width('40%')
              .height('100%')
              .backgroundColor($r('sys.color.comp_background_list_card'))
              .textAlign(TextAlign.Center)
            Image($r('app.media.plus'))
              .borderRadius(800)
              .height(32)
              .width(32)
              .padding(4)
              .backgroundColor($r('app.color.main_background_color'))
              .onClick(() => {
                if (this.personNum >= this.courseBookingInfo.restQuota) {
                  promptAction.showToast({ message: '课程空余数量不足' })
                } else {
                  this.personNum++;
                  this.totalPrice = this.personNum * this.courseDetail!.price;
                }
              })
          }
          .width('40%')
          .height('100%')
          .justifyContent(FlexAlign.SpaceEvenly)
        }
        .width('100%')
        .height(32)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .margin({ top: 10 })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(164)
    }
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .width('100%')
    .padding(16)
  }

  @Builder
  remarkBuilder() {
    Row() {
      Column() {
        Row() {
          Text('备注')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text(this.remarkInputCount + '/' + this.remarkMaxCount)
            .fontSize(10)
            .fontWeight(FontWeight.Regular)
            .opacity(0.9)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        TextArea({ text: this.remark, placeholder: '选填，请输入您的其他要求' })
          .fontSize(12)
          .padding(0)
          .placeholderFont({ size: 12 })
          .placeholderColor('#999999')
          .maxLength(this.remarkMaxCount)
          .width('100%')
          .height(80)
          .borderRadius(0)
          .backgroundColor($r('sys.color.comp_background_list_card'))
          .onChange((value) => {
            this.remark = value
            this.remarkInputCount = value.length
          })
          .margin({ top: 12 })
      }
      .width('100%')
      .height(74)
    }
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .width('100%')
    .padding(16)
  }

  build() {
    NavDestination() {
      TitleBar({ title: '新增预约', pathStack: this.pathStack })
        .margin({ left: 16, right: 16 })
      Stack() {
        Scroll() {
          Column({ space: 16 }) {
            // 课程
            this.courseInfoBuilder()

            // 预约时间
            this.bookingTimeBuilder()

            // 预约人信息
            this.bookingPersonInfo()

            // 备注
            this.remarkBuilder()

          }
          .width('100%')
        }
        .margin({ left: 16, right: 16 })
        .scrollBar(BarState.Off)
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)

      // 下方咨询和跳转预约
      Row() {
        Text('¥' + this.totalPrice)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .width('15%')
          .height('60%')
          .textAlign(TextAlign.Center)
        Text('提交预约')
          .textAlign(TextAlign.Center)
          .width('75%')
          .height('60%')
          .fontColor($r('sys.color.comp_background_list_card'))
          .fontWeight(FontWeight.Medium)
          .fontSize(14)
          .backgroundColor('#FF9019')
          .borderRadius(8)
          .onClick(() => {
            if (this.name === '' || this.name === undefined || this.phone === '' || this.phone === undefined) {
              promptAction.showToast({ message: '请完善预约人信息' })
              return;
            }
            let bookingInfo: BookingInfo = {
              courseBookingInfo: this.courseBookingInfo,
              courseDetail: this.courseDetail!,
              phone: this.phone,
              name: this.name,
              personNum: this.personNum,
              remark: this.remark,

            }
            this.pathStack.pushPath({ name: 'course/ConfirmBooking', param: bookingInfo })
          })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .height(75)
      .width('100%')
      .padding({ bottom: 10 })
      .backgroundColor(Color.White)
    }.hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack
      this.courseBookingInfo = ctx?.pathInfo?.param as CourseBookingInfo;
      this.courseDetail = MockService.getCourseById(this.courseBookingInfo.courseId)
      this.bookingDate = DateUtil.parseDateString(this.courseBookingInfo.date)
      this.totalPrice = this.courseDetail.price
    })
    .padding({ top: px2vp(this.topRectHeight) })
    .backgroundColor($r('app.color.main_background_color'))
  }

  getUserInfo() {
    this.phone = MockService.account.phone;
    this.name = MockService.account.nickname ? MockService.account.nickname : '华为用户'
  }
}
