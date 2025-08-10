import { CommonConstants, SettingModel } from 'lib_common'
import { LayoutParams, PostImgList } from 'lib_news_api'
import { PersistenceV2, UIUtils } from '@kit.ArkUI'
import { AuthorCard } from '../builder/AuthorBuilder'
import { ArticleSourceBuilder } from '../builder/ArticleSourceBuilder'
import { CardViewModel } from '../viewModel/CardViewModel'

@Builder
export function TopTextBottomBigImageCard(cardData: LayoutParams) {
  NativeComponent({
    cardData: cardData,
  })
}

@ComponentV2
struct NativeComponent {
  @Param @Require cardData: LayoutParams
  @Local currentIndex: number = 0
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!
  @Local cardViewModel: CardViewModel = new CardViewModel()
  aboutToAppear(): void {
    this.cardData.nativeCardData = UIUtils.makeObserved(this.cardData.nativeCardData)
  }

  build() {
    Column({ space: CommonConstants.SPACE_S }) {
      AuthorCard({
        cardData: this.cardData,
        isNeedAuthor: !!this.cardData.extraInfo.isNeedAuthor,
      })
      Text(this.cardData.nativeCardData?.title)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
        .fontSize(16 * this.settingInfo.fontSizeRatio)
      List({ space: CommonConstants.SPACE_M }) {
        ForEach(this.cardData.nativeCardData?.postImgList, (item: PostImgList) => {
          ListItem() {
            Column() {
              Stack() {
                Image(item.surfaceUrl).width(CommonConstants.FULL_PERCENT).borderRadius(8).clip(true)
                Image($r('app.media.play')).width(43).height(43)
              }.visibility(item.surfaceUrl ? Visibility.Visible : Visibility.None)

              Image(item.picVideoUrl).width(CommonConstants.FULL_PERCENT).borderRadius(8).clip(true)
                .visibility(item.surfaceUrl ? Visibility.None : Visibility.Visible)
            }
          }
        })
      }
      .listDirection(Axis.Horizontal)

     ArticleSourceBuilder({
       cardData: this.cardData,
     })
    }
    .width(CommonConstants.FULL_PERCENT)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.cardViewModel.pushToNewsDetails(this.cardData)
    })
  }
}