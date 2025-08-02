import { getMedia, getString } from '@agctemplate/resources'
import { RankList } from './RankList'

@ComponentV2
export struct RecommendPanel {

  @Event onLiveClick: () => void

  build() {
    Column() {
      Row() {
        Text(getString('app.string.hot_recommend'))
          .fontWeight(500)
          .fontSize(16)
      }
      .margin({
        top: 12, bottom: 12
      })

      Row() {
        Column() {
          RankList({ onLiveClick: this.onLiveClick })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}