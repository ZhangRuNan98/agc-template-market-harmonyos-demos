import { CommonRuleLine } from 'module_base'

@ComponentV2
export struct CommonCheckCard {
  @Param redemptionDate: string = ''
  @Param confirmationDate: string = ''

  build() {
    Column() {
      CommonRuleLine({
        isPurchase: true,
        confirmationDate: this.redemptionDate,
        redemptionDate: this.redemptionDate,
      })
      Row() {
        Row()
          .width(4)
          .height(4)
          .backgroundColor($r('sys.color.icon_tertiary'))
          .borderRadius('50%')
          .margin({ left: 8, right: 4 })
        Text(`17:00点前购买，${this.confirmationDate}可查看持仓并开始计算收益`)
          .fontSize(10)
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_secondary'))
      }
      .width('100%')
      .height(32)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .borderRadius(8)
    }
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 12,
    })
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .margin({ bottom: 12 })
  }
}