import { RouterMap, RouterUtils, SettingModel } from 'lib_common'
import { NewsFeedInfo } from '../model/Model'
import NewsFeedVM from '../viewModel/NewsFeedVM'

@ComponentV2
export struct RecommendArea {
  @Local newsFeedVM:NewsFeedVM = NewsFeedVM.instance
  @Require @Param settingInfo: SettingModel

  build() {
    Column() {
      Column() {
        Text('相关推荐')
          .fontSize(18 * this.settingInfo.fontSizeRatio)
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Bold)
      }
      .margin({ top: 16, bottom: 8 })
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      ForEach(this.newsFeedVM.articleDetails.recommends, (item: NewsFeedInfo) => {
        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          Column({ space: 5 }) {
            Text(item.title)
              .maxLines(2)
              .fontColor($r('sys.color.font_primary'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(FontWeight.Medium)
              .fontSize(16 * this.settingInfo.fontSizeRatio)
            Row() {
              Text(item?.articleFrom)
                .fontSize(12 * this.settingInfo.fontSizeRatio).fontColor($r('sys.color.font_tertiary'))
              Text(item?.publishTime)
                .fontSize(12 * this.settingInfo.fontSizeRatio)
                .fontColor($r('sys.color.font_tertiary'))
                .margin({ left: 8 })
            }
          }
          .width('65%')
          .alignItems(HorizontalAlign.Start)

          Column() {
            if (item.postImgList?.[0].surfaceUrl) {
              Stack() {
                Image(item.postImgList?.[0].surfaceUrl)
                  .size({ width: 96, height: 72 })
                  .borderRadius(8)
                  .clip(true)
                Image($r('app.media.play')).width(23).height(23)
              }
            } else {
              Image(item.postImgList?.[0].picVideoUrl)
                .size({ width: 96, height: 72 })
                .borderRadius(8)
                .clip(true)
            }
          }
        }
        .padding({ top: 12, bottom: 12 })
        .onClick(() => {
          let routerParams = {
            'id': item.id,
            'author': item.author.authorId,
          } as Record<string, string>
          RouterUtils.pushPathByName(RouterMap.ARTICLE_FEED_DETAILS, routerParams)
        })
      })
    }
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('sys.color.background_primary'))
    .margin({ top: 8 })
  }
}