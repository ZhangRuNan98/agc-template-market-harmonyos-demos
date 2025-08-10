import { CommonConstants, RouterMap, RouterUtils, SettingModel, UserInfoModel } from 'lib_common';
import { LayoutParams, NewsResponse } from 'lib_news_api';
import { Highlight } from 'module_highlight';
import { AVPlayerSession } from 'module_swipeplayer';
import { AuthorCard } from '../builder/AuthorBuilder';
import { PersistenceV2, UIUtils } from '@kit.ArkUI';
import { CardViewModel } from '../viewModel/CardViewModel';

@Builder
export function TopTextBottomVideoCard(cardData: LayoutParams) {
  TopTextBottomVideo({
    cardData: cardData,
  })
}

@ComponentV2
export struct TopTextBottomVideo {
  @Param @Require cardData: LayoutParams
  @Local currentIndex: number = 0
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!
  @Local cardViewModel: CardViewModel = new CardViewModel()
  @Local coverImgHeight: Length = 200
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;

  aboutToAppear(): void {
    this.cardViewModel.setAuthorId(this.cardData.nativeCardData.author.authorId)
    this.cardData.nativeCardData = UIUtils.makeObserved(this.cardData.nativeCardData)
  }

  @Computed
  get getWatch() {
    return this.userInfoModel.isLogin &&
    this.userInfoModel.watchers.includes(this.cardData.nativeCardData.author.authorId)
  }

  @Computed
  get isFeedSelf() {
    return this.userInfoModel.authorId === this.cardData.nativeCardData.author.authorId
  }

  @Builder
  watchBuilder() {
    Row() {
      Text() {
        Span(this.getWatch ? '已关注' : '关注')
      }
      .fontSize(14 * this.settingInfo.fontSizeRatio)
      .fontColor(this.getWatch ? $r('app.color.app_theme') : $r('sys.color.background_primary'))
      .onClick(() => {
        this.cardViewModel.watchOperation()
      })
    }
    .padding({
      left: 12,
      right: 12,
      top: 6,
      bottom: 6,
    })
    .backgroundColor(this.getWatch ? $r('sys.color.comp_background_tertiary') : $r('app.color.app_theme'))
    .borderRadius(14)
    .justifyContent(FlexAlign.Center)
    .visibility(this.cardData.extraInfo?.isFollow && this.isFeedSelf ? Visibility.None : Visibility.Visible)
  }

  build() {
    Column({ space: CommonConstants.SPACE_M }) {
      AuthorCard({
        cardData: this.cardData,
        isNeedAuthor: true,
        watchBuilder: () => {
          this.watchBuilder()
        },
      })
      Column({ space: CommonConstants.SPACE_L }) {
        Column({ space: CommonConstants.SPACE_XS }) {
          if (this.cardData?.extraInfo?.searchKey) {
            Highlight({
              keywords: [this.cardData.extraInfo.searchKey as string],
              sourceString: this.cardData.nativeCardData?.title,
              highLightColor: $r('app.color.app_theme'),
              textColor: $r('sys.color.font_primary'),
            })
          } else {
            Text(this.cardData.nativeCardData?.title)
              .maxLines(2)
              .fontSize(16 * this.settingInfo.fontSizeRatio)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          }
        }
        .width('65%')
        .alignItems(HorizontalAlign.Start)

        Column() {
          if (this.cardData.nativeCardData?.postImgList?.length) {
            Stack({ alignContent: Alignment.Center }) {
              Image(this.cardData.nativeCardData?.postImgList[0].surfaceUrl)
                .width(CommonConstants.FULL_PERCENT)
              Image($r('app.media.ic_paused'))
                .width(44)
                .height(44)
            }
            .width(CommonConstants.FULL_PERCENT)
            .height(this.coverImgHeight)
          }
        }
        .borderRadius(8)
        .clip(true)
      }
      .onClick(() => {
        this.cardViewModel.pushToNewsDetails(this.cardData)
      })
      .alignItems(HorizontalAlign.Start)
    }
  }
}