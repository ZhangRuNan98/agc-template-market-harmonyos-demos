import { CardInfo, ConsumeType } from 'external_interactions'

@Component
export struct Card {
  pathStack: NavPathStack = new NavPathStack();
  @ObjectLink cardInfo: CardInfo

  build() {
    Column() {
      Column() {
        Text(this.cardInfo.name)
          .fontSize(10)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Text() {
          Span('¥' + this.cardInfo.price + '/')
            .fontSize(14)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
          Span(this.cardInfo.consumeType === ConsumeType.TIMES ? this.cardInfo.quota + '次' : '不限次')
            .fontSize(10)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
        }

        Text('预计可省¥' + this.cardInfo.saveMoney)
          .fontSize(8)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
      }
      .backgroundImage($r(this.cardInfo.advImage))
      .backgroundImageSize({ width: '100%', height: '100%' })
      .width('100%')
      .height(82)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ left: 5, top: 5 })
      .borderRadius({ topLeft: 8, topRight: 8 })

      Column() {
        Text(this.cardInfo.shortName)
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
    .onClick(() => {
      this.pathStack.pushPath({ name: 'card/cardDetail', param: this.cardInfo })
    })
    .width('100%')
    .height(112)
  }
}
