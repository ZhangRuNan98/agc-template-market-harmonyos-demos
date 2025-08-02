import { jumpDetailPage } from '@agctemplate/detail'
import { getMedia, getString } from '@agctemplate/resources'
import { LiveCard, LiveCardModel } from '../models/LiveModel'
import { CommonCard } from './LiveCards'

@ComponentV2
export struct SearchResultPanel {

  @Param @Require resultList: Array<LiveCardModel>
  @Event loadNextPage: Function
  @Event onLiveClick: Function

  build() {
    Row() {
      Column() {
        Row() {
          Text(getString('app.string.drama_search_result_title'))
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
            .margin({
              top: 12, bottom: 12
            })
        }
        .width('100%')

        if (this.resultList.length > 0) {
          Row() {
            Grid() {
              ForEach(this.resultList, (card: LiveCard) => {
                GridItem() {
                  CommonCard({ liveData: card })
                }
                .onClick(() => {
                  jumpDetailPage('')
                })
              })
            }
            .edgeEffect(EdgeEffect.Spring)
            .height(366)
            .columnsTemplate('1fr 1fr')
            .rowsGap(8)
            .columnsGap(8)
            .scrollBar(BarState.Off)
          }
        } else {
          this.nullBuilder()
        }
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
  }

  @Builder
  nullBuilder() {
    Column() {

      Image(getMedia('app.media.search_no_result'))
        .width(120)
        .aspectRatio(1)
        .margin({ top: 20 })
      Text(getString('app.string.search_null'))
        .fontSize($r('sys.float.Caption_M'))
        .fontColor($r('sys.color.font_tertiary'))
        .margin({ top: 4, bottom: 10 })
    }
    .padding(12)
    .borderRadius(16)
    .backgroundColor(Color.White)
    .width('100%')
  }
}