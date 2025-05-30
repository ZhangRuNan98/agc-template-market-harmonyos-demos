import { CardInfo, ConsumeType, CourseDetailModel, DateUtil, MockService, UserCard } from 'external_interactions';
import { Consulting } from 'uicomponents';
import { TitleBar } from 'uicomponents/src/main/ets/components/TitleBar';

@Component
export struct CourseDetail {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @Prop pathStack: NavPathStack;
  @Prop courseDetail: CourseDetailModel;
  listScroller: ListScroller = new ListScroller()
  cardList: CardInfo[] = []
  userCardList: UserCard[] = []
  @State hasBuyCard: boolean = false

  @Builder
  courseBasicBuilder() {
    Column() {
      Image($r(this.courseDetail.advImage))
        .width('100%')
        .height(132)
        .borderRadius(8)
        .margin({ bottom: 16 })
      Text(this.courseDetail.courseName)
        .textAlign(TextAlign.Start)
        .fontSize(14)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .margin({ bottom: 16 })
      Text('¥' + this.courseDetail.price.toString())
        .textAlign(TextAlign.Start)
        .fontSize(14)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .width('100%')
    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
  }

  @Builder
  cardShowBuilder() {
    Column() {
      // 已购卡项或推荐卡项，根据是否已买卡展示不同内容
      if (this.hasBuyCard) {
        Text('已购卡项')
          .textAlign(TextAlign.Start)
          .fontSize(14)
          .width('100%')
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })
        ForEach(this.userCardList, (userCard: UserCard, index: number) => {
          this.hasBuyCardBuilder(userCard, MockService.getCardById(userCard.cardId), index)
          Divider()
            .margin({ bottom: 10 })
            .visibility((index !== this.cardList.length - 1) ? Visibility.Visible :
            Visibility.None)
        }, (item: CardInfo) => JSON.stringify(item))
      } else {
        Text('推荐卡项')
          .textAlign(TextAlign.Start)
          .fontSize(14)
          .width('100%')
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })
        Row() {
          Image($r('app.media.chevron_left'))
            .width(13)
            .height(13)
            .onClick(() => {
              this.listScroller.scrollPage({ next: false })
            })
          List({ scroller: this.listScroller }) {
            ForEach(this.cardList, (card: CardInfo) => {
              ListItem() {
                Column() {
                  Column() {
                    Text(card.name)
                      .fontSize(10)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Bold)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(1)
                    Text() {
                      Span('¥' + card.price + '/')
                        .fontSize(14)
                        .fontColor(Color.White)
                        .fontWeight(FontWeight.Bold)
                      Span(card.consumeType === ConsumeType.TIMES ? card.quota + '次' : '不限次')
                        .fontSize(10)
                        .fontColor(Color.White)
                        .fontWeight(FontWeight.Medium)
                    }

                    Text('预计可省¥' + card.saveMoney)
                      .fontSize(8)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                  }
                  .backgroundImage($r(card.advImage))
                  .backgroundImageSize({ width: '100%', height: '100%' })
                  .width('100%')
                  .height(82)
                  .alignItems(HorizontalAlign.Start)
                  .justifyContent(FlexAlign.SpaceEvenly)
                  .padding({ left: 5, top: 5 })
                  .borderRadius({ topLeft: 8, topRight: 8 })

                  Column() {
                    Text(card.shortName)
                      .fontSize(10)
                      .fontWeight(FontWeight.Medium)
                      .margin({ left: 5 })
                  }
                  .borderRadius({ bottomLeft: 8, bottomRight: 8 })
                  .alignItems(HorizontalAlign.Start)
                  .justifyContent(FlexAlign.Center)
                  .shadow({
                    radius: 2,
                    color: '#ECECEC',
                    offsetY: 5,
                  })
                  .width('100%')
                  .height(30)
                }
                .height(112)
                .padding(10)
                .width('50%')
                .onClick(() => {
                  this.jumpToCard(card)
                })
              }
            }, (item: CardInfo) => JSON.stringify(item))
          }
          .scrollBar(BarState.Off)
          .width('90%')
          .height(112)
          .listDirection(Axis.Horizontal)

          Image($r('app.media.chevron_right'))
            .width(13)
            .height(13)
            .onClick(() => {
              this.listScroller.scrollPage({ next: true })
            })
        }.justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(112)
      }
    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
  }

  @Builder
  hasBuyCardBuilder(userCard: UserCard, card: CardInfo, index: number) {
    Row() {
      Image($r(card.advImage))
        .width(80)
        .height(80)
        .borderRadius(8)
      Column() {
        Text(card.name)
          .textAlign(TextAlign.Start)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Row() {
          Text(card.consumeType === ConsumeType.TIMES ? card.quota + '次' :
            MockService.getQuotaDurationDesc(card.quota) + '卡')
            .textAlign(TextAlign.Start)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
          Text(card.consumeType === ConsumeType.TIMES ? '剩余' + userCard.restQuota + '次' :
            '到期时间:' + DateUtil.formatDate(MockService.getCardExpireDate(userCard)))
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.End)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 16 })
      .height('100%')
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height(80)
    .margin({ bottom: (index !== this.cardList.length - 1) ? 10 : 0 })
    .onClick(() => {
      this.jumpToCard(card)
    })
  }

  @Builder
  serviceDetailBuilder() {
    Column() {
      Text('服务详情')
        .textAlign(TextAlign.Start)
        .fontSize(14)
        .width('100%')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 8 })
      Text(this.courseDetail.serviceDetail)
        .textAlign(TextAlign.Start)
        .align(Alignment.Top)
        .fontSize(12)
        .width('100%')
        .fontColor(Color.Black)
        .opacity(0.6)
        .fontWeight(FontWeight.Regular)
    }
    .width('100%')
    .borderRadius(16)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
    .margin({ bottom: 10 })
  }

  build() {
    NavDestination() {
      TitleBar({ title: '课程详情', pathStack: this.pathStack })
        .margin({ left: 16, right: 16 })
      Stack() {
        Scroll() {
          Column({ space: 16 }) {
            // 课程图片轮播，价格展示
            this.courseBasicBuilder()
            // 展示卡项
            this.cardShowBuilder()
            // 服务详情
            this.serviceDetailBuilder()
          }.width('100%')
          .justifyContent(FlexAlign.Start)
          .margin({ top: 0 })
        }
        .scrollBar(BarState.Off)
        .margin({ left: 16, right: 16 })
      }
      .layoutWeight(1)
      .alignContent(Alignment.Top)

      // 下方咨询和跳转预约
      Row() {
        Row() {
          Consulting()
        }.justifyContent(FlexAlign.Center)
        .width('20%')
        .height('60%')

        Text('立即预约')
          .textAlign(TextAlign.Center)
          .width('70%')
          .height('60%')
          .fontColor($r('sys.color.comp_background_list_card'))
          .fontWeight(FontWeight.Medium)
          .fontSize(14)
          .backgroundColor('#FF9019')
          .borderRadius(8)
          .onClick(() => {
            this.pathStack.clear(false)
            AppStorage.setOrCreate('bookJumpSearch', this.courseDetail.courseName)
          })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .height(75)
      .width('100%')
      .padding({ bottom: 10 })
      .backgroundColor(Color.White)

    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      this.courseDetail = ctx?.pathInfo?.param as CourseDetailModel;
      this.getCardList()
    })
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight) })
  }

  getCardList() {
    // 用户已购卡项包含课程卡项，显示已购卡项
    MockService.userCardList.forEach((item: UserCard) => {
      if (this.courseDetail.avaiCard.includes(item.cardId) && MockService.userCardCanUse(item)) {
        this.hasBuyCard = true
        this.userCardList.push(item)
      }
    })
    // 没有可用已购卡项，显示推荐卡项
    if (!this.hasBuyCard) {
      this.courseDetail.avaiCard.forEach((item: string) => {
        this.cardList.push(MockService.getCardById(item))
      })
    }
  }

  jumpToCard(card: CardInfo) {
    let cardIndex = this.pathStack.getIndexByName('card/cardDetail')
    // 防止课程和卡项互相跳转导致路由路径过长，查找是否路由已存在，存在删除之前的页面
    if (cardIndex.length > 0) {
      this.pathStack.removeByName('card/cardDetail')
      this.pathStack.pushPath({ name: 'card/cardDetail', param: card })
    } else {
      this.pathStack.pushPath({ name: 'card/cardDetail', param: card })
    }
  }
}


