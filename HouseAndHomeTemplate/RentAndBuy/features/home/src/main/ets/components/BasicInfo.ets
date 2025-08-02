import { NewHouseInfo, SecondHouseInfo } from 'foundation';

@Builder
export function buildBasicText(title: string, content: string) {
  Column({ space: 8 }) {
    Text(title).fontSize(12).fontWeight(FontWeight.Bold).opacity(0.9).fontColor($r('sys.color.black'));
    Text(content).fontSize(12).opacity(0.9).fontColor($r('sys.color.black'));
  }.alignItems(HorizontalAlign.Start);
}

@Builder
export function BasicInfoBuilder(detail: NewHouseInfo | SecondHouseInfo) {
  Column({ space: 12 }) {
    Row() {
      Image($r('app.media.report')).size({ width: 12, height: 12 }).margin({ right: 8 });
      Text('楼盘价值分析报告').fontSize(12).opacity(0.6).fontWeight(500).fontColor($r('sys.color.black'));
    }

    buildBasicText('交通情况', detail.basic.transport);
    buildBasicText('小区规划', detail.basic.plan);
    buildBasicText('户型评分', detail.basic.rate);
  }.alignItems(HorizontalAlign.Start);
}
