import {
  BookingInfo,
  BookingRecordInfo,
  BookState,
  CardInfo,
  ConsumeType,
  CourseBookingInfo,
  CourseDetailModel,
  DateUtil,
  MockService,
  UserCard
} from 'external_interactions';
import { TitleBar } from 'uicomponents';

@Component
export struct BookingRecord {
  stateList: BookState[] =
    [BookState.ALL, BookState.TO_BE_USE, BookState.COMPLETED, BookState.EXPIRED, BookState.CANCELED]
  @Prop pathStack: NavPathStack;
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @State currentTabIndex: number = 0;

  @Builder
  tabBarBuilder(bookState: BookState, index: number) {
    Text(MockService.getBookStateString(bookState))
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
      TitleBar({ title: '预约记录', pathStack: this.pathStack })
        .margin({ left: 16, right: 16 })
      Tabs() {
        ForEach(this.stateList, (item: BookState, index: number) => {
          TabContent() {
            RecordContent({
              bookState: item,
              pathStack: this.pathStack,
              currentTabIndex: this.currentTabIndex,
              index: index
            })
          }
          .tabBar(this.tabBarBuilder(item, index))
        }, (item: BookState) => JSON.stringify(item))
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
struct RecordContent {
  @Prop bookState: BookState
  @State bookRecordList: BookingRecordInfo[] = []
  pathStack: NavPathStack = new NavPathStack();
  @Prop @Watch('tabIndexChange') currentTabIndex: number
  @Prop index: number
  @StorageLink('accountUpdate') @Watch('tabIndexChange') accountUpdate: boolean = false;

  aboutToAppear(): void {
    this.bookRecordList = MockService.getBookingListByState(this.bookState)
  }

  build() {
    Column() {
      Column() {
        Image($r('app.media.no_result'))
          .width(144)
          .height(144)
          .margin({ bottom: 12 })
        Text('未查询到预约记录')
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
          .fontColor('#999999')
      }
      .height('50%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .visibility(this.bookRecordList.length > 0 ? Visibility.None : Visibility.Visible)

      List({ space: 20 }) {
        ForEach(this.bookRecordList, (item: BookingRecordInfo) => {
          ListItem() {
            RecordItem({ bookingRecordInfo: item, pathStack: this.pathStack })
          }
        }, (item: BookState) => JSON.stringify(item))
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
      this.bookRecordList = MockService.getBookingListByState(this.bookState)
    }
  }
}

@Component
struct RecordItem {
  @Prop bookingRecordInfo: BookingRecordInfo;
  @State courseBookingInfo?: CourseBookingInfo = undefined;
  @State courseDetailInfo?: CourseDetailModel = undefined;
  pathStack: NavPathStack = new NavPathStack();
  @StorageLink('bookingRestQuotaUpdate') bookingRestQuotaUpdate: boolean = false
  @StorageLink('accountUpdate') accountUpdate: boolean = false

  aboutToAppear(): void {
    this.courseBookingInfo = MockService.getCourseBookingById(this.bookingRecordInfo.courseBookingId)
    this.courseDetailInfo = MockService.getCourseById(this.courseBookingInfo.courseId)
  }

  build() {
    Column() {
      Row() {
        Text('预约时间: ' + DateUtil.formatDate(DateUtil.parseDateString(this.bookingRecordInfo.bookingDate), '.') + ' ' + this.courseBookingInfo?.timeStart + '-' +
          this.courseBookingInfo?.timeEnd)
          .fontSize(14)
        Row() {
          Image($r(this.getBookingStateImage()))
            .width(18)
            .height(18)
          Text(MockService.getBookStateString(this.bookingRecordInfo.bookState))
            .fontSize(14)
        }
      }.justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(18)

      Divider()
        .margin({ top: 16, bottom: 16 })

      Row() {
        Image($r(this.courseDetailInfo?.advImage))
          .width(80)
          .height(80)
          .borderRadius(8)
        Column() {
          Row() {
            Text(this.courseDetailInfo?.courseName)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
            Text('¥' + this.courseDetailInfo?.price)
              .fontSize(14)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Text(this.getBookingInstruction())
              .fontSize(14)
              .width('70%')
            Text('x' + this.bookingRecordInfo.personNum)
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

      Column() {
        Divider()
          .margin({ top: 16, bottom: 16 })
        Button('取消预约')
          .fontSize($r('sys.float.Body_M'))
          .width(100)
          .fontColor($r('sys.color.comp_background_list_card'))
          .borderRadius($r('sys.float.corner_radius_level4'))
          .type(ButtonType.Normal)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#FF9019')
          .onClick(() => {
            this.bookingRecordInfo.bookState = BookState.CANCELED;
            this.bookingRestQuotaUpdate = !this.bookingRestQuotaUpdate
            this.updateMockData()
          })
      }.alignItems(HorizontalAlign.End)
      .height(70)
      .width('100%')
      .visibility(this.bookingRecordInfo.bookState === BookState.TO_BE_USE ? Visibility.Visible : Visibility.None)

    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
    .onClick(() => {
      this.pathStack.pushPath({ name: 'course/BookingDetail', param: this.buildBookingInfo() })
    })
  }

  getBookingInstruction(): string {
    switch (this.bookingRecordInfo.bookState) {
      case BookState.TO_BE_USE:
        return '请您按时接受服务，行程有变请提前取消预约'
      case BookState.COMPLETED:
        return '已完成预约课程'
      case BookState.EXPIRED:
        return '您的课程未完成，如有需要请再次预约'
      case BookState.CANCELED:
        return '您的课程未完成，如有需要请再次预约'
      default:
        return ''
    }
  }

  getBookingStateImage(): string {
    switch (this.bookingRecordInfo.bookState) {
      case BookState.TO_BE_USE:
        return 'app.media.booking_state_to_be_used'
      case BookState.COMPLETED:
        return 'app.media.booking_state_completed'
      case BookState.EXPIRED:
        return 'app.media.booking_state_expired'
      case BookState.CANCELED:
        return 'app.media.booking_state_canceled'
      default:
        return ''
    }
  }

  buildBookingInfo(): BookingInfo {
    let bookingInfo: BookingInfo = {
      courseBookingInfo: this.courseBookingInfo!,
      courseDetail: this.courseDetailInfo!,
      phone: this.bookingRecordInfo.phone,
      name: this.bookingRecordInfo.name,
      personNum: this.bookingRecordInfo.personNum,
      remark: this.bookingRecordInfo.remark,
      bookState: this.bookingRecordInfo.bookState
    }
    return bookingInfo
  }

  updateMockData() {
    MockService.getCourseBookingById(this.courseBookingInfo!.id).restQuota += this.bookingRecordInfo.personNum;
    MockService.dataPreferences.putSync('courseBooking', JSON.stringify(MockService.courseBookingList))
    MockService.getBookingRecordById(this.bookingRecordInfo.id).bookState = BookState.CANCELED
    MockService.dataPreferences.putSync('booking', JSON.stringify(MockService.bookingList))
    if (this.bookingRecordInfo.userCardId) {
      let userCard: UserCard = MockService.getUserCardById(this.bookingRecordInfo.userCardId)
      let cardInfo: CardInfo = MockService.getCardById(userCard.cardId)
      if (cardInfo.consumeType === ConsumeType.TIMES) {
        MockService.getUserCardById(this.bookingRecordInfo.userCardId).restQuota += this.bookingRecordInfo.personNum;
        MockService.dataPreferences.putSync('userCard', JSON.stringify(MockService.userCardList))
      }
    } else {
      MockService.account.balance += this.courseDetailInfo!.price * this.bookingRecordInfo.personNum;
      MockService.dataPreferences.putSync('account', JSON.stringify(MockService.account))
    }
    this.accountUpdate = !this.accountUpdate

    MockService.dataPreferences.flush()
  }
}
