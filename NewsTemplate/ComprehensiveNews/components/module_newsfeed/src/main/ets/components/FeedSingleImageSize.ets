import dayjs from 'dayjs';
import { ImagePreview, PreviewVerticalAlign } from 'module_imagepreview'
import { Share } from 'module_share';
import { PostImgList, FeedCardInfoModel } from '../model/RecommendModel';
import { formatToK, handlerCoverImage } from '../utils/Index';

/*
 * 单张图片的展示
 * */

const TAG = '[FeedSingleImageSize]';

@ComponentV2
export struct FeedSingleImageSize {
  @Require @Param postImgListItem: PostImgList
  @Require @Param curFeedCardInfo: FeedCardInfoModel
  @Require @Param imageList: ResourceStr[]
  @Require @Param index: number
  @Require @Param componentId: string = ''
  @Param isWatch: boolean = false
  @Param isFeedSelf: boolean = false
  @Param fontSizeRatio: number = 1
  @Param imageWidth: number = 0
  @Param imageHeight: number = 0
  @Event onAddWatch: () => void = () => {
  }
  @Event onAddLike: () => void = () => {
  }
  @Event onAddComment: () => void = () => {
  }
  @Event onVideo: () => void = () => {
  }
  @Local timer: number = 0
  @Local isExpand: boolean = false

  @Builder
  shareBuilder() {
    Share({
      qrCodeInfo: {
        id: this.curFeedCardInfo.id,
        type: this.curFeedCardInfo.type,
        title:this.curFeedCardInfo.title,
        createTime: dayjs(this.curFeedCardInfo.createTime).format('YYYY-MM-DD hh:mm'),
        coverUrl: handlerCoverImage(this.curFeedCardInfo),
        isVideo: !!this.curFeedCardInfo.postImgList?.[0]?.surfaceUrl,
      },
      shareRenderBuilder: () => {
        this.shareCommentBuilder()
      },
    })
  }

  @Builder
  shareCommentBuilder() {
    Column({ space: 5 }) {
      Image($r('app.media.image_forward'))
        .width(21)
        .height(21)
      Text(formatToK(this.curFeedCardInfo.shareCount))
        .fontSize(10 * this.fontSizeRatio)
        .fontColor($r('sys.color.font_on_primary'))
    }
  }

  @Builder
  authorBuilder() {
    Flex({ alignItems: ItemAlign.Center }) {
      Row({ space: 5 }) {
        Image(this.curFeedCardInfo.author.authorIcon)
          .width(24 * this.fontSizeRatio)
          .height(24 * this.fontSizeRatio)
          .borderRadius(12 * this.fontSizeRatio)
          .clip(true)
        Text(this.curFeedCardInfo.author.authorNickName).fontColor($r('sys.color.font_on_primary'))
          .fontSize(16 * this.fontSizeRatio)
      }

      Row() {
        Text() {
          Span(this.isWatch ? '已关注' : '关注')
        }
        .fontSize(14 * this.fontSizeRatio)
        .fontColor(this.isWatch ? $r('app.color.app_theme') : $r('sys.color.background_primary'))
        .onClick(() => {
          this.onAddWatch()
        })
      }
      .width(72)
      .height(28)
      .margin({ left: 16 })
      .backgroundColor(this.isWatch ? $r('sys.color.background_primary') : $r('app.color.app_theme'))
      .borderRadius(14)
      .justifyContent(FlexAlign.Center)
      .visibility(this.isFeedSelf ? Visibility.None : Visibility.Visible)
    }
    .visibility(this.isExpand ? Visibility.None : Visibility.Visible)
  }

  expandAnimation() {
    if (this.timer) {
      clearTimeout(this.timer)
    }
    animateTo({
      duration: 500,
      curve: Curve.EaseOut,
      playMode: PlayMode.Normal,
    }, () => {
      this.isExpand = true
      this.timer = setTimeout(() => {
        this.isExpand = false
      }, 2000)
    })
  }

  @Builder
  operationBuilder() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row({ space: 5 }) {
        Row() {
          Image(this.isExpand ? $r('app.media.down') : $r('app.media.up')).width(17).height(9)
        }
        .width(24)
        .height(24)
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('sys.color.comp_background_tertiary'))

        Text(this.isExpand ? '收起' : '展开').fontColor($r('sys.color.font_on_primary'))
          .fontSize(16 * this.fontSizeRatio)
      }
      .onClick(() => {
        animateTo({
          duration: 500,
          curve: Curve.EaseOut,
          playMode: PlayMode.Normal,
        }, () => {
          this.isExpand = !this.isExpand
        })
      })

      Row({ space: 25 }) {
        Column({ space: 5 }) {
          Image($r('app.media.image_comment')).width(20).height(20)
          Text(this.curFeedCardInfo.commentCount?.toString())
            .fontColor($r('sys.color.font_on_primary'))
            .fontSize(10 * this.fontSizeRatio)
        }
        .onClick(() => {
          ImagePreview.hide()
          this.onAddComment()
        })

        Column({ space: 5 }) {
          Image(this.curFeedCardInfo.isLiked ? $r('app.media.like_active') : $r('app.media.preview_like'))
            .width(23)
            .height(20)
          Text(this.curFeedCardInfo.likeCount?.toString())
            .fontColor($r('sys.color.font_on_primary'))
            .fontSize(10 * this.fontSizeRatio)
        }
        .onClick(() => {
          this.onAddLike()
        })

        this.shareBuilder()
      }
      .visibility(!this.isExpand ? Visibility.Visible : Visibility.None)
    }
  }

  build() {
    Column() {
      Row() {
        Image(this.postImgListItem.picVideoUrl)
          .width(this.imageWidth)
          .height(this.imageHeight)
          .objectFit(ImageFit.Cover)
          .visibility(this.postImgListItem.surfaceUrl ? Visibility.None : Visibility.Visible)
          .borderRadius(12)
          .clip(true)
          .onClick(() => {
            ImagePreview.show(this.imageList, {
              indexPosition: PreviewVerticalAlign.Top,
              startIndex: this.index,
              authorBuilder: () => {
                this.authorBuilder()
              },
              operationBuilder: () => {
                this.operationBuilder()
              },
              onCloseExpand: () => {
                this.expandAnimation()
              },
            })
          })
        Stack() {
          Image(this.postImgListItem.surfaceUrl).objectFit(ImageFit.Cover)
            .borderRadius(12)
            .clip(true)
          Image($r('app.media.playBtn')).width(36)
            .height(36)
        }
        .width(this.imageWidth)
        .height(this.imageHeight)
        .visibility(this.postImgListItem.surfaceUrl ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.onVideo()
        })
      }
    }
    .width(this.imageWidth)
    .height(this.imageHeight)
    .clipShape(new Rect({ width: '100%', height: '100%', radius: 12 }))
    .margin({ top: 8 })
  }
}