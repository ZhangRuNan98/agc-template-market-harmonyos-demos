import { RouterPageEnum } from 'common'
import { CycleRecordCard } from '../components/CycleRecordCard'
import { CycleRecordData, CycleRecordDatas } from '../mockData/CycleRecordData'
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct CycleRecordPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Local cycleRecordDatas: CycleRecordDatas =
    AppStorageV2.connect(CycleRecordDatas, 'cycleRecordDatas', () => new CycleRecordDatas())!

  build() {
    NavDestination() {
      if (this.cycleRecordDatas.data.length === 0) {
        Column({ space: 16 }) {
          Image($r('app.media.no_record'))
            .width(120)
            .height(120)
            .fillColor('#CCCCCC')
          Text('暂无骑行记录')
            .fontSize(16)
            .fontColor($r('sys.color.font_secondary'))
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .height('90%')
      } else {
        List({ space: 12 }) {
          ForEach(this.cycleRecordDatas.data, (item: CycleRecordData, index: number) => {
            ListItem() {
              Column() {
                CycleRecordCard({ record: item, hasLocation: false })
                  .onClick(() => {
                    this.pageInfos.pushPathByName(RouterPageEnum.TRIP_DETAIL_ROUTER, item.id)
                  })
              }
              .padding({
                left: 12,
                right: 12,
                top: 13,
                bottom: 12
              })
              .height(87)
              .borderRadius(16)
              .backgroundColor($r('app.color.pure_white'))
              .width('100%')
            }
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8 })
        .edgeEffect(EdgeEffect.Spring)
      }
    }
    .backgroundColor($r('app.color.common_background'))
    .title('骑行记录')
  }
}