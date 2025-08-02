import { Constant, SecondHouseInfo } from 'foundation';

@Extend(Text)
function valueText(opa: number) {
  .fontSize(12).opacity(opa);
}

@Builder
export function ValueBuilder(detail: SecondHouseInfo) {
  Row({ space: 12 }) {
    Column({ space: 8 }) {
      Text('超高').valueText(0.9).fontWeight(FontWeight.Bold).fontColor($r('sys.color.black'));
      Text('保值率').valueText(0.4).fontSize(12).fontColor($r('sys.color.black'));
    }.width(40).alignItems(HorizontalAlign.Center);

    Text(detail.house.value)
      .valueText(0.9)
      .maxLines(3)
      .fontColor($r('sys.color.black'))
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .width('calc(100% - 52vp)');
  }.width(Constant.FULL_PERCENT)
}