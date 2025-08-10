import { CommonConstants, RouterToNews, SettingModel } from 'lib_common'
import { LayoutParams, PostImgList } from 'lib_news_api'
import { PersistenceV2, UIUtils } from '@kit.ArkUI'
import { Highlight } from 'module_highlight'
import { AuthorCard } from '../builder/AuthorBuilder'
import { ArticleSourceBuilder } from '../builder/ArticleSourceBuilder'

@Builder
export function TopTextBottomImageCard(cardData: LayoutParams) {
  NativeComponent({
    cardData: cardData,
  })
}

@ComponentV2
struct NativeComponent {
  @Param @Require cardData: LayoutParams
  @Local currentIndex: number = 0
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!

  aboutToAppear(): void {
    this.cardData.nativeCardData = UIUtils.makeObserved(this.cardData.nativeCardData)
  }

  build() {
    Column({ space: CommonConstants.SPACE_S }) {
      AuthorCard({
        cardData: this.cardData,
        isNeedAuthor: !!this.cardData.extraInfo.isNeedAuthor,
      })
      if (this.cardData?.extraInfo?.searchKey) {
        Highlight({
          keywords: [this.cardData.extraInfo.searchKey as string],
          sourceString: this.cardData.nativeCardData?.title,
          highLightColor: '#E84026',
          textColor: $r('sys.color.font_primary'),
        })
      } else {
        Text(this.cardData.nativeCardData?.title)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .fontSize(16 * this.settingInfo.fontSizeRatio)
      }
      List({ space: CommonConstants.SPACE_M }) {
        ForEach(this.cardData.nativeCardData?.postImgList, (item: PostImgList) => {
          ListItem() {
            Image(item.picVideoUrl).width(104).height(78).borderRadius(8).clip(true)
          }
        })
      }
      .listDirection(Axis.Horizontal)

      ArticleSourceBuilder({
        cardData: this.cardData,
      })
    }
    .onClick(() => {
      RouterToNews.routerToNewsByDetails(this.cardData.nativeCardData)
    })
    .width(CommonConstants.FULL_PERCENT)
    .alignItems(HorizontalAlign.Start)
  }
}