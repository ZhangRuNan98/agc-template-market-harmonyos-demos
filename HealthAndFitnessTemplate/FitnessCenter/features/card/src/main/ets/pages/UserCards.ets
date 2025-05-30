import { CardInfo, ConsumeType, DateUtil, MockService, UserCard } from 'external_interactions';
import { TitleBar } from 'uicomponents';

@Component
export struct UserCards {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  pathStack: NavPathStack = new NavPathStack()
  userCardList: UserCard[] = []

  @Builder
  cardItemBuilder(userCard: UserCard, cardDetail: CardInfo) {
    Row() {
      Image($r(cardDetail.advImage))
        .width(80)
        .height(80)
        .borderRadius(8)
      Column() {
        Text(cardDetail.name)
          .textAlign(TextAlign.Start)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Row() {
          Text(cardDetail.consumeType === ConsumeType.TIMES ? cardDetail.quota + '次' :
            MockService.getQuotaDurationDesc(cardDetail.quota) + '卡')
            .fontSize(14)
          Text() {
            if (cardDetail.consumeType === ConsumeType.TIMES) {
              Span('剩余次数:')
              Span(userCard.restQuota.toString())
                .fontColor('#FF9019')
            } else {
              Span('到期时间:')
              Span(DateUtil.formatDate(MockService.getCardExpireDate(userCard)))
                .fontColor('#FF9019')
            }
          }
          .fontSize(14)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 16 })
      .height(80)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding(16)
    .onClick(() => {
      this.pathStack.pushPath({ name: 'card/cardDetail', param: cardDetail })
    })
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: '我的卡项', pathStack: this.pathStack })
        List({ space: 16 }) {
          ForEach(this.userCardList, (item: UserCard) => {
            ListItem() {
              this.cardItemBuilder(item, MockService.getCardById(item.cardId))
            }
          }, (item: UserCard) => JSON.stringify(item))
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
      }.margin({ left: 16, right: 16 })
    }
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
      MockService.userCardList.forEach((item: UserCard) => {
        if (MockService.userCardCanUse(item)) {
          this.userCardList.push(item)
        }
      })
    })
    .hideTitleBar(true)
    .padding({ top: px2vp(this.topRectHeight) })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.main_background_color'))
  }
}