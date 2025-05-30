import { Card } from 'card';
import { Course } from 'course';
import { CardInfo, CourseDetailModel, MockService, SportType } from 'external_interactions';
import { window } from '@kit.ArkUI';

@Component
export struct Home {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  scroller: Scroller = new Scroller()
  controller: VideoController = new VideoController()
  pathStack: NavPathStack = new NavPathStack()
  courseList: CourseDetailModel[] = MockService.getHomeCourseList()
  cardList: CardInfo[] = MockService.getHomeCardList()
  private swiperController: SwiperController = new SwiperController()

  @Builder
  homeAdvBuilder() {
    Swiper() {
      ForEach(MockService.homeSwiperImageList, (item: string) => {
        Image($r(item))
          .width('100%')
          .height('100%')
      }, (item: string) => item)
    }
    .loop(true)
    .autoPlay(true)
    .height(148)
    .width('100%')
    .borderRadius(16)
    .curve(Curve.Smooth)
  }

  @Builder
  sportTypesBuilder() {
    Row() {
      Image($r('app.media.back'))
        .width(13)
        .height(13)
        .onClick(() => {
          this.swiperController.showPrevious()
        })
      Swiper(this.swiperController) {
        ForEach(MockService.sportTypeList, (item: SportType) => {
          ListItem() {
            Column() {
              Image($r(item.icon))
                .width(24)
                .height(24)
                .margin({ bottom: 4 })
              Text(item.name)
                .fontSize(12)
                .fontWeight(FontWeight.Medium)
            }
            .onClick(() => {
              this.pathStack.pushPath({ name: 'sportDetail', param: item })
            })
          }.width('25%')
        }, (item: SportType) => JSON.stringify(item))
      }
      .width('70%')
      .autoPlay(false)
      .loop(false)
      .itemSpace(0)
      .displayCount(4)
      .effectMode(EdgeEffect.Spring)
      .indicator(false)
      .duration(200)
      .onChange((index: number) => {
        this.swiperController.changeIndex(index)
      })
      .curve(Curve.Smooth)

      Image($r('app.media.chevron_right'))
        .width(13)
        .height(13)
        .onClick(() => {
          this.swiperController.showNext()
        })
    }
    .width('100%')
    .height(72)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .margin({ top: 15, bottom: 15 })
    .borderRadius(16)
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  cardListBuilder() {
    Column() {
      Row() {
        Text('本店卡项')
          .fontWeight(FontWeight.Medium)
          .fontSize(14)
        Row() {
          Text('更多')
            .fontSize(10)
            .margin({ right: 3 })
            .fontColor($r('sys.color.black'))

          Image($r('app.media.chevron_right'))
            .width(8)
            .height(8)
            .fillColor($r('sys.color.black'))
        }
        .opacity(0.4)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          this.pathStack.pushPath({ name: 'card/showAllCards' })
        })
      }
      .padding({ top: 10, bottom: 15 })
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)

      Grid() {
        ForEach(this.cardList, (item: CardInfo) => {
          GridItem() {
            Card({ pathStack: this.pathStack, cardInfo: item })
          }
        }, (item: CardInfo) => JSON.stringify(item))
      }
      .width('90%')
      .columnsTemplate('1fr 1fr')
      .columnsGap(15)
      .rowsGap(15)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ bottom: 15 })
  }

  @Builder
  courseListBuilder() {
    Column() {
      Row() {
        Text('课程列表')
          .fontWeight(FontWeight.Medium)
          .fontSize(14)
        Row() {
          Text('更多')
            .fontSize(10)
            .margin({ right: 3 })
          Image($r('app.media.chevron_right'))
            .width(8)
            .height(8)
        }
        .opacity(0.4)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          this.pathStack.pushPath({ name: 'course/ShowAllCourse' })
        })
      }
      .padding({ top: 10, bottom: 15 })
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)

      Grid() {
        ForEach(this.courseList, (item: CourseDetailModel) => {
          GridItem() {
            Course({ pathStack: this.pathStack, courseDetail: item })
          }
        }, (item: CourseDetailModel) => JSON.stringify(item))
      }
      .width('90%')
      .columnsTemplate('1fr 1fr')
      .columnsGap(15)
      .rowsGap(15)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ bottom: 15 })
    .padding({ bottom: 10 })
  }

  @Builder
  clubEnvironmentBuilder() {
    Column() {
      Row() {
        Text('俱乐部环境')
          .fontWeight(FontWeight.Medium)
          .fontSize(14)
        Row() {
          Text('更多')
            .fontSize(10)
            .margin({ right: 3 })
          Image($r('app.media.chevron_right'))
            .width('3%')
        }
        .opacity(0.4)
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          this.pathStack.pushPath({ name: 'clubEnvironmentDetail' })
        })
      }
      .padding({ top: 10, bottom: 15 })
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)

      Video({
        src: $r('app.media.club'),
        previewUri: $r('app.media.material9'),
        controller: this.controller,
        currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X
      })
        .width('90%')
        .height('25%')
        .borderRadius(8)
        .onFullscreenChange((event) => {
          // 改变设备横竖屏状态
          window.getLastWindow(getContext(this)).then((lastWindow) => {
            lastWindow.setPreferredOrientation(event.fullscreen ? window.Orientation.LANDSCAPE :
            window.Orientation.PORTRAIT)
          });
        })
      Text('了解俱乐部的详情')
        .width('90%')
        .padding({ top: 10, bottom: 10 })
        .fontSize(12)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ bottom: 15 })
  }

  build() {
    Column() {
      Row() {
        Text('首页')
          .fontSize(20)
          .width('100%')
          .fontWeight(FontWeight.Medium)
      }
      .justifyContent(FlexAlign.Start)
      .height(40)
      .margin({
        top: 8,
        bottom: 8,
        left: 16,
        right: 16
      })

      Scroll(this.scroller) {
        Column() {
          // 轮播图
          this.homeAdvBuilder()

          // 运动类别
          this.sportTypesBuilder()

          // 卡项
          this.cardListBuilder()

          // 课程
          this.courseListBuilder()

          // 健身房环境
          this.clubEnvironmentBuilder()
        }
        .margin({ left: 16, right: 16 })
      }
      .padding({ bottom: 56 })
      .scrollBar(BarState.Off)
    }
    .padding({ top: px2vp(this.topRectHeight) })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.main_background_color'))
  }
}