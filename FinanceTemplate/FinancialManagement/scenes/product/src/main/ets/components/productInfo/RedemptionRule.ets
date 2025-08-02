import { FormatUtil, RouterMap, CommonRow } from 'module_base'
import { ProductInfoVM } from '../../viewModels/ProductInfoVM'
import { CommonHeaderRule } from './CommonHeaderRule'

@ComponentV2
export struct RedemptionRule {
  vm: ProductInfoVM = ProductInfoVM.instance

  build() {
    Column() {
      CommonHeaderRule({
        text: '赎回规则', changeValue: () => {
          FormatUtil.jumpToNext(RouterMap.RULE, { id: this.vm.productInfo?.id, index: 1 })
        }
      })

      CommonRow({
        text: '最低持有份额', value: this.vm.productRedemptionRule?.minimumRedemptionAmount + '元起购，' +
          this.vm.productRedemptionRule?.minimumRedemptionAmount + '元递增'
      })

      CommonRow({ text: '赎回费率', value: this.vm.productBuyRule?.subscriptionRate + '%' })

      Row() {
        Row() {
          Text('购买时间')
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_primary'))
        }
        .width('25%')

        Row() {
          Text(this.vm.productRedemptionRule?.date)
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_secondary'))
            .maxLines(3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .justifyContent(FlexAlign.End)
        .width('75%')
      }
      .alignItems(VerticalAlign.Top)
      .margin({ bottom: 12 })
    }
    .backgroundColor(Color.White)
    .padding({
      left: 12,
      right: 12,
      top: 16,
      bottom: 12
    })
    .alignItems(HorizontalAlign.Start)
    .margin({ bottom: 12 })
    .borderRadius(16)
  }
}