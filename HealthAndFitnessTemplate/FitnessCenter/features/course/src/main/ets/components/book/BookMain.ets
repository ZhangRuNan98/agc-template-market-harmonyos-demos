import {
  CoachCourseInfo,
  CourseBookingInfo,
  CourseDetailModel,
  DateUtil,
  MockService,
  SportType,
  TeachType
} from 'external_interactions';
import { promptAction, SymbolGlyphModifier } from '@kit.ArkUI';

@Component
export struct BookMain {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  teachTypeList: string[] = ['团课', '私教'];
  @State teachTypeIndex: number = 0;
  @State sportTypeList: SportType[] = [];
  @State sportTypeIndex: number = 0;
  private weekNameList: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  @State dateList: Date[] = [];
  @State dateSelectIndex: number = 0;
  private listScroller: ListScroller = new ListScroller();
  @State courseBookingInfoList: CourseBookingInfo[] = [];
  @State coachCourseInfoList: CoachCourseInfo[] = [];
  pathStack: NavPathStack = new NavPathStack();
  @State searchWord: string = ''
  @StorageLink('bookingRestQuotaUpdate') @Watch('getCourseList') bookingRestQuotaUpdate: boolean = false
  @Prop @Watch('searchCourseBooking') mainTabIndex: number;

  aboutToAppear(): void {
    this.dateList = this.buildDateList();
    this.getSportsType();
    this.getCourseList();
  }

  private buildDateList(): Date[] {
    let dateSelectList: Date[] = [];
    let newDate: Date = new Date();
    for (let index = 0; index < 7; index++) {
      dateSelectList.push(new Date(newDate));
      newDate.setTime(newDate.getTime() + 24 * 60 * 60 * 1000);
    }
    return dateSelectList;
  }

  getCourseList() {
    if (this.teachTypeIndex === 0) {
      this.courseBookingInfoList =
        MockService.getCourseBookingInfoListBySearch(this.searchWord, this.sportTypeList[this.sportTypeIndex],
          this.dateList[this.dateSelectIndex])
    } else {
      this.coachCourseInfoList =
        MockService.getCoachCourseInfoListBySearch(this.searchWord, this.sportTypeList[this.sportTypeIndex],
          this.dateList[this.dateSelectIndex])
    }
  }

  getSportsType() {
    let typeList: SportType[] = [{
      name: '全部',
      typeEnum: 0,
      icon: '',
      advImage: []
    }];
    this.sportTypeList = typeList.concat(MockService.sportTypeList)
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('预约')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .width('100%')
      }
      .justifyContent(FlexAlign.Start)
      .height(40)
      .margin({
        top: 8,
        bottom: 8,
        left: 16,
        right: 16
      })

      // 搜索框
      Search({ placeholder: '请输入预约课程名称', value: $$this.searchWord })
        .borderRadius(20)
        .backgroundColor('#E5E7E8')
        .placeholderColor($r('sys.color.font_tertiary'))
        .placeholderFont({ size: $r('sys.float.Body_M'), weight: FontWeight.Regular })
        .cancelButton({
          style: CancelButtonStyle.CONSTANT,
          icon: new SymbolGlyphModifier($r('sys.symbol.xmark_circle')).fontColor([Color.Gray]).outlineColor(Color.Gray)
        })
        .margin({ bottom: 15, left: 16, right: 16 })
        .onChange(() => {
          this.getCourseList()
        })

      // 课程运动类型标签
      List({ space: 16 }) {
        ForEach(this.sportTypeList, (item: SportType, index: number) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(14)
                .fontColor(this.sportTypeIndex === index ? Color.White : Color.Black)
            }
            .justifyContent(FlexAlign.Center)
            .borderRadius(16)
            .backgroundColor(this.sportTypeIndex === index ? '#FF9019' : '#E5E7E8')
            .width(60)
            .height(40)
            .onClick(() => {
              this.sportTypeIndex = index;
              this.getCourseList()
            })
          }
        }, (item: SportType) => JSON.stringify(item))
      }
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .height(40)
      .margin({ bottom: 15, left: 16, right: 16 })

      Column() {
        // 授课类型
        Row({ space: 20 }) {
          ForEach(this.teachTypeList, (teachType: string, index: number) => {
            Text(teachType)
              .height('100%')
              .fontSize(14)
              .fontWeight(this.teachTypeIndex === index ? FontWeight.Bold : FontWeight.Regular)
              .border({
                width: { bottom: this.teachTypeIndex === index ? 3 : 0 },
                color: '#000000'
              })
              .onClick(() => {
                if (this.teachTypeIndex !== index) {
                  this.teachTypeIndex = index;
                  this.getCourseList();
                }
              })
          }, (item: string) => item)
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .height(40)
        .width('100%')
        .padding({ left: 16 })

        Divider()

        // 日期选择
        Row() {
          List({ space: 10, scroller: this.listScroller }) {
            ForEach(this.dateList, (item: Date, index: number) => {
              ListItem() {
                Column() {
                  Text(this.weekNameList[item.getDay()])
                    .fontSize(14)
                    .fontColor(index === this.dateSelectIndex ? '#FFFFFF' :
                      '#333333')
                  Text((item.getMonth() + 1 < 10 ? '0' + (item.getMonth() + 1) :
                    item.getMonth() + 1 + '') + '.' +
                    (item.getDate() < 10 ? '0' + item.getDate() : item.getDate() + ''))
                    .fontSize(12)
                    .fontColor(index === this.dateSelectIndex ? '#FFFFFF' :
                      '#333333')
                }
                .backgroundColor(index === this.dateSelectIndex ? '#FF9019' :
                  '#FFFFFF')
                .height(40)
                .width(40)
                .padding(2)
                .justifyContent(FlexAlign.SpaceAround)
                .borderRadius(8)
                .onClick(() => {
                  this.dateSelectIndex = index;
                  this.getCourseList()
                })
              }
            }, (item: Date) => DateUtil.formatDate(item))
          }
          .listDirection(Axis.Horizontal)
          .alignListItem(ListItemAlign.Center)
          .scrollBar(BarState.Off)
          .width('100%')
          .height('100%')
        }.justifyContent(FlexAlign.SpaceBetween)
        .height(60)
        .margin({ left: 16, right: 16 })
      }
      .height(100)
      .width('100%')
      .backgroundColor($r('sys.color.comp_background_list_card'))


      // 课程列表
      List({ space: 16 }) {
        if (this.teachTypeIndex === 0) {
          if (this.courseBookingInfoList.length === 0) {
            NoCourse()
          } else {
            ForEach(this.courseBookingInfoList, (item: CourseBookingInfo) => {
              ListItem() {
                CourseInfoItem({ item: item, pathStack: this.pathStack })
              }
            }, (item: CourseBookingInfo) => JSON.stringify(item))
          }
        } else {
          if (this.coachCourseInfoList.length === 0) {
            NoCourse()
          } else {
            ForEach(this.coachCourseInfoList, (item: CoachCourseInfo) => {
              ListItem() {
                coachListCollapse({ coachCourseInfo: item, pathStack: this.pathStack })
              }
            }, (item: CoachCourseInfo) => JSON.stringify(item))
          }
        }
      }
      .scrollBar(BarState.Off)
      .height('60%')
      .margin({ top: 12, left: 16, right: 16 })
      .layoutWeight(1)
    }
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight) })
    .height('100%')
    .width('100%')
  }

  searchCourseBooking() {
    if (this.mainTabIndex === 1) {
      let jumpSearch: string | undefined = AppStorage.get('bookJumpSearch')
      if (jumpSearch) {
        this.searchWord = jumpSearch
        let courseBookingInfo = MockService.searchCourseBooking(jumpSearch)
        if (courseBookingInfo) {
          let courseDetail = MockService.getCourseById(courseBookingInfo.courseId)
          this.teachTypeIndex = courseDetail.teachType === TeachType.GROUP ? 0 : 1
          this.dateList.forEach((item: Date, index: number) => {
            if (DateUtil.formatDate(item, '-') === courseBookingInfo?.date) {
              this.dateSelectIndex = index;
            }
          })
          this.getCourseList()
        }
        AppStorage.setOrCreate('bookJumpSearch', '')
      }
    } else {
      // 切换tab页时清空搜索条件
      this.searchWord = ''
      this.sportTypeIndex = 0
      this.dateSelectIndex = 0
    }
  }
}

@Component
struct coachListCollapse {
  @State collapse: boolean = true; // 是否折叠列表
  @State rotateAngle: number = 90; // 折叠控制图标旋转度数
  @ObjectLink coachCourseInfo: CoachCourseInfo; // 教练课程信息
  pathStack: NavPathStack = new NavPathStack();

  build() {
    Column() {
      Row() {
        Image($r(this.coachCourseInfo.photo))
          .width(56)
          .height(56)
          .borderRadius(28)
        Column() {
          Text(this.coachCourseInfo.name)
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
          Text(this.coachCourseInfo.introduction)
            .fontSize(10)
            .fontWeight(FontWeight.Regular)
            .opacity(0.6)
        }
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(HorizontalAlign.Start)
        .height('100%')
        .margin({ left: 16 })
        .layoutWeight(1)

        Row() {
          Text('所授课程')
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FF9019')
          Image($r('app.media.chevron_right'))
            .width(16)
            .height(16)
            .colorBlend('#FF9019')
            .rotate({ angle: this.rotateAngle })
            .margin({ left: 10 })
        }
        .onClick(() => {
          // 折叠与展开态切换动画
          animateTo({
            duration: 300
          }, () => {
            this.collapse = !this.collapse;
            this.rotateAngle = (this.rotateAngle + 180) % 360;
          })
        })
      }
      .height(88)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .padding(16)

      Column() {
        Divider()
          .width('100%')
        ForEach(this.coachCourseInfo.courseInfos, (item: CourseBookingInfo) => {
          CourseInfoItem({ item: item, pathStack: this.pathStack })
        }, (item: CourseBookingInfo) => JSON.stringify(item))
      }
      .visibility(this.collapse ? Visibility.None : Visibility.Visible)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
  }
}

@Component
struct CourseInfoItem {
  @ObjectLink item: CourseBookingInfo;
  pathStack: NavPathStack = new NavPathStack();
  @State courseDetail: CourseDetailModel = MockService.getCourseById(this.item.courseId)
  @StorageLink('loginState') loginState: boolean = false;
  @StorageLink('jumpLogin') jumpLogin: boolean = false

  build() {
    Row() {
      Image($r(this.courseDetail.advImage))
        .width(56)
        .height(56)
        .borderRadius(8)
      Column() {
        Text(this.item.timeStart)
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
        Divider()
          .vertical(true)
          .strokeWidth(2)
          .color('#FF9019')
          .height('30%')
        Text(this.item.timeEnd)
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
      }.justifyContent(FlexAlign.SpaceBetween)
      .height('90%')
      .margin({ left: 16 })

      Column() {
        Text(this.courseDetail.courseName)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Text('¥' + this.courseDetail.price)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
      .height('90%')
      .margin({ left: 16 })
      .layoutWeight(1)

      Column() {
        if (this.item.totalQuota === 9999) {
          Text('无需预约')
            .fontColor('#FF9019')
            .fontSize(14)
        } else {
          Text() {
            Span('空')
              .fontSize(12)
              .fontWeight(FontWeight.Regular)
              .fontColor('#333333')
            Span(this.item.restQuota.toString())
              .fontSize(12)
              .fontWeight(FontWeight.Regular)
              .fontColor('#FF9019')
            Span('/' + this.item.totalQuota)
              .fontSize(12)
              .fontWeight(FontWeight.Regular)
              .fontColor('#333333')
          }.visibility(this.item.restQuota === 0 ? Visibility.None : Visibility.Visible)

          if (this.item.restQuota === 0) {
            Button('已满')
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_tertiary'))
              .width(60)
              .height(35)
              .borderRadius($r('sys.float.corner_radius_level4'))
              .type(ButtonType.Normal)
              .fontWeight(FontWeight.Medium)
              .backgroundColor('#E5E7E8')
              .enabled(false)
          } else {
            Button('预约')
              .fontSize($r('sys.float.Body_M'))
              .width(60)
              .height(35)
              .fontColor($r('sys.color.comp_background_list_card'))
              .borderRadius($r('sys.float.corner_radius_level4'))
              .type(ButtonType.Normal)
              .fontWeight(FontWeight.Medium)
              .backgroundColor('#FF9019')
              .enabled(true)
              .onClick(() => {
                if (this.loginState) {
                  this.pathStack.pushPath({ name: 'course/AddBooking', param: this.item })
                } else {
                  promptAction.showToast({ message: '请先关联账号' })
                  this.jumpLogin = !this.jumpLogin
                  this.pathStack.clear(false)
                }
              })
          }
        }
      }
      .justifyContent(FlexAlign.SpaceAround)
      .height('100%')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .width('100%')
    .borderRadius(16)
    .padding(16)
    .height(88)
  }
}

@Component
struct NoCourse {
  build() {
    Column() {
      Image($r('app.media.no_result'))
        .width(144)
        .height(144)
        .margin({ bottom: 12 })
      Text('该日程无排课')
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .fontColor('#999999')
      Text('请另选时间预约吧~')
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
        .fontColor('#999999')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('80%')
  }
}


