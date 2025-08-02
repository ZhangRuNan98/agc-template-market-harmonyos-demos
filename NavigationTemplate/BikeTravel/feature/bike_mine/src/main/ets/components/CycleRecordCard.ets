import { DayFormat } from 'common'
import { CycleRecordData } from '../mockData/CycleRecordData'

@ComponentV2
export struct CycleRecordCard {
  @Require @Param record: CycleRecordData
  @Require @Param hasLocation: boolean

  build() {
    Column({ space: 11.5 }) {
      Row() {
        Text() {
          Span('车辆编号：')
          Span(this.record.bike)
        }
        .height(19)
        .fontColor($r('app.color.font_gray'))
        .fontWeight(FontWeight.Regular)

        Text(`${new DayFormat(new Date).format('YYYY-MM-DD HH:MM')}`)
          .fontSize(14)
          .height(19)
          .fontWeight(FontWeight.Regular)
          .fontColor($r('app.color.font_gray'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.hasLocation) {
        Text() {
          Span('起点：')
          Span(this.record.start)
          Span(' - 终点：')
          Span(this.record.end)
        }
        .fontColor($r('app.color.font_gray'))
        .fontWeight(FontWeight.Regular)
      }

      Divider()
        .width('100%')
        .color($r('app.color.divider_gray'))
        .strokeWidth(1)

      Row() {
        Row({ space: 5 }) {
          Image($r('app.media.ic_duration'))
            .height(15)
            .width(13)

          Text() {
            Span('骑行时长')
            Span(this.record.duration)
          }
          .height(19)
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
        }

        Text() {
          Span('花费：')
          Span(this.record.cost.toString())
          Span('元')
        }
        .height(19)
        .fontSize(14)
        .fontWeight(FontWeight.Regular)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .backgroundColor($r('app.color.pure_white'))
    .alignItems(HorizontalAlign.Start)
  }
}