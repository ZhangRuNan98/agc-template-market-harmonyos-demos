import { Card } from 'card';
import { Course } from 'course';
import { CardInfo, CourseDetailModel, MockService, SportType } from 'external_interactions';
import { TitleBar } from 'uicomponents';
import { JSON } from '@kit.ArkTS';

@Component
export struct SportDetail {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @Prop pathStack: NavPathStack;
  @Prop sportType: SportType
  courseList: CourseDetailModel[] = []
  cardList: CardInfo[] = []

  @Builder
  sportsAdvBuilder() {
    Swiper() {
      ForEach(this.sportType.advImage, (item: string) => {
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
    .margin({ bottom: 15 })
    .curve(Curve.Smooth)
  }

  @Builder
  cardListBuilder() {
    Column() {
      Row() {
        Text('本店卡项')
          .fontWeight(FontWeight.Medium)
          .fontSize(14)
      }
      .padding({ top: 10, bottom: 15 })
      .width('90%')

      Grid() {
        ForEach(this.cardList, (item: CardInfo) => {
          GridItem() {
            Card({ pathStack: this.pathStack, cardInfo: item })
          }
        }, (item: string) => JSON.stringify(item))
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
      }
      .padding({ top: 10, bottom: 15 })
      .width('90%')

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

  build() {
    NavDestination() {
      TitleBar({ title: this.sportType.name, pathStack: this.pathStack })
        .margin({ left: 16, right: 16 })
      Stack() {
        Scroll() {
          Column() {
            this.sportsAdvBuilder()
            this.cardListBuilder()
            this.courseListBuilder()
          }
        }
        .scrollBar(BarState.Off)
        .margin({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      this.sportType = ctx?.pathInfo?.param as SportType;
      this.courseList = MockService.getCourseListBySportType(this.sportType.typeEnum)
      this.cardList = MockService.getCardListBySportType(this.sportType.typeEnum)
    })
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight), bottom: px2vp(this.bottomRectHeight) })
  }
}