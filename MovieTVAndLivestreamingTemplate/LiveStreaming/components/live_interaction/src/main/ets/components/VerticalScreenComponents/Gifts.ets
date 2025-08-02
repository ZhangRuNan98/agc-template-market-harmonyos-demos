import { GiftModel } from '../../models/GiftGroup';

@Preview
@ComponentV2
export struct Gifts {
  @Require @Param giftData:Array<GiftModel>
  @Local selectedId: number = 0;
  @Event onPay:Function=(item:GiftModel)=>{
  }
  @Builder
  giftItem(item: GiftModel) {
    if (this.selectedId !== item.id) {
      Column() {
        Image(item.icon)
          .width(48)
          .height(48)
          .margin({
            top: 12,
            left: 14,
            right: 14,
            bottom: 4
          })

        Text(item.name)
          .width(60)
          .height(15)
          .fontSize(12)
          .fontWeight(400)
          .fontColor('#e6000000')
          .textAlign(TextAlign.Center)
          .margin({ bottom: 2 })

        Text(`${item.price}虚拟币`)
          .width(60)
          .height(14)
          .fontSize(10)
          .fontColor('#e6000000')
          .textAlign(TextAlign.Center)
          .margin({ bottom: 12 })
      }
      .height(108)
      .width(76)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.selectedId = item.id
      })
    } else {
      Column() {
        Image(item.icon)
          .width(48)
          .height(48)
          .margin({
            top: 12,
            left: 14,
            right: 14,
            bottom: 4
          })

        Text(`${item.price}虚拟币`)
          .width(60)
          .height(14)
          .fontSize(10)
          .fontColor('#e6000000')
          .textAlign(TextAlign.Center)

        Button('赠送')
          .width(76)
          .height(28)
          .backgroundColor('#E84026')
          .fontColor('#fff')
          .fontSize(16)
          .fontWeight(700)
          .margin('6px 26px')
          .type(ButtonType.Normal)
          .borderRadius({
            topLeft: 0,
            topRight: 0,
            bottomLeft: 8,
            bottomRight: 8
          })
          .onClick(() => {
              this.onPay(item)
          })
      }
      .borderRadius(8)
      .height(108)
      .width(76)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#fff')
    }
  }

  build() {
    Grid() {
      ForEach(this.giftData, (item: GiftModel) => {
        GridItem() {
          this.giftItem(item)
        }
      }, (item: GiftModel) => item.id.toString())
    }
    .height('100%')
    .width('100%')
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsGap(8)
    .scrollBar(BarState.Off)
  }
}

