import { FormatCount, NewsEnum, RouterToNews, SettingModel, UserInfoModel } from 'lib_common'
import { CommentServiceApi, NewsResponse } from 'lib_news_api'
import { FeedCard } from 'module_newsfeed'
import { PersistenceV2 } from '@kit.ArkUI'
import { Share } from 'module_share'
import { TimeUtils } from 'lib_common'
import { InteractionViewModel } from '../viewmodels/InteractionViewModel'
import { LoginSheetUtils } from 'lib_account'

@ComponentV2
export struct InteractionFeedCard {
  @Require @Param cardInfo: NewsResponse
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Local interactionViewModel: InteractionViewModel = new InteractionViewModel()

  aboutToAppear(): void {
    this.interactionViewModel.setAuthorId(this.cardInfo.author.authorId)
  }

  @Builder
  shareCommentBuilder() {
    Row({ space: 5 }) {
      Image($r('app.media.op_forward'))
        .width(16 * this.settingInfo.fontSizeRatio)
        .height(16 * this.settingInfo.fontSizeRatio)
        .draggable(false)
        .fillColor($r('sys.color.font_primary'))
      Text(FormatCount.formatToK(this.cardInfo.shareCount))
        .fontSize(12 * this.settingInfo.fontSizeRatio)
        .fontColor($r('sys.color.font_secondary'))
    }
  }

  @Builder
  shareBuilder() {
    Share({
      qrCodeInfo: {
        id: this.cardInfo.id,
        type: this.cardInfo.type,
        title: this.cardInfo.title,
        articleFrom: this.cardInfo.articleFrom,
        createTime: TimeUtils.formatDate(this.cardInfo.createTime, 'YYYY-MM-DD HH:MM'),
        coverUrl: this.cardInfo.postImgList?.[0]?.picVideoUrl,
        isVideo: !!this.cardInfo.postImgList?.[0]?.surfaceUrl,
      },
      shareRenderBuilder: () => {
        this.shareCommentBuilder()
      },
    })
  }

  build() {
    FeedCard({
      componentId: 'interaction_news',
      feedCardInfo: this.cardInfo,
      isAll: true,
      isDark: this.settingInfo.darkSwitch,
      showUserBar: true,
      showTimeBottom: false,
      fontSizeRatio: this.settingInfo.fontSizeRatio,
      onArticle: (type?: string) => {
        if (type || !this.cardInfo.postImgList?.[0]?.surfaceUrl) {
          RouterToNews.routerToNewsByDetails(this.cardInfo, type)
          return
        }
       this.interactionViewModel.actionToNewsDetails(this.cardInfo)
      },
      onVideo: () => {
        this.interactionViewModel.actionToNewsDetails(this.cardInfo)
      },
      shareBuilder: () => {
        this.shareBuilder()
      },
      onWatch: () => {
        this.interactionViewModel.watchOperation()
      },
      onLike: () => {
        if (!this.userInfoModel.isLogin) {
          LoginSheetUtils.open()
          return
        }
        this.cardInfo.isLiked = !this.cardInfo.isLiked
        if (this.cardInfo.isLiked) {
          CommentServiceApi.addPosterLike(this.cardInfo.id)
          this.cardInfo.likeCount += 1
          return
        }
        CommentServiceApi.cancelPosterLike(this.cardInfo.id)
        this.cardInfo.likeCount -= 1
      },
    })
  }
}