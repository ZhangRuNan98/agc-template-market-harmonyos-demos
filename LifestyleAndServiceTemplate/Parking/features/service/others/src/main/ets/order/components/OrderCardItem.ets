import { CONTAINER_STYLE, FormatUtil, IOrder, RouterMap, RouterModule } from 'common';

@ComponentV2
export struct OrderCardItem {
  @Require @Param order: IOrder;
  @Event delete?: () => void;

  build() {
    RelativeContainer() {
      Column({ space: 12 }) {
        Text(this.order.spot)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))

        Text(this.order.license)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_secondary'))

        Text(FormatUtil.dateTimeDisplay(new Date(this.order.start), false, true))
          .fontSize($r('sys.float.Caption_L'))
          .fontColor($r('sys.color.font_secondary'))
      }
      .alignItems(HorizontalAlign.Start)
      .alignRules({
        'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
        'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start },
      })

      Column({ space: 14 }) {
        Text('已支付')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_secondary'))

        Text('¥ ' + this.order.cost?.toFixed(2))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_primary'))
      }
      .alignItems(HorizontalAlign.End)
      .alignRules({
        'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
        'right': { 'anchor': '__container__', 'align': HorizontalAlign.End },
      })

      Image($r('app.media.ic_order_delete'))
        .width(24)
        .alignRules({
          'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
          'right': { 'anchor': '__container__', 'align': HorizontalAlign.End },
        })
        .onClick(() => {
          this.delete?.();
        })
    }
    .onClick(() => {
      RouterModule.push({ url: RouterMap.ORDER_DETAIL, param: this.order });
    })
    .attributeModifier(CONTAINER_STYLE)
    .height(140)
  }
}