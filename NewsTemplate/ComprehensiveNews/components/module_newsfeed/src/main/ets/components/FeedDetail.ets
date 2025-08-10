import { display, PersistenceV2 } from '@kit.ArkUI';
import { ArticleTextEllipsis } from './ArticleTextEllipsis';
import { FeedSingleImageSize } from './FeedSingleImageSize';
import { PostImgList, FeedCardInfoModel } from '../model/RecommendModel';
import { calculateDimensions, getDateDiff, twoImagesSize } from '../utils/Index';
import { UserInfoModel } from 'lib_common';


/*
 * 动态中心内容
 * */

const TAG = '[FeedDetail]';

@ComponentV2
export struct FeedDetail {
  @Require @Param componentId: string = ''
  @Require @Param curFeedCardInfo: FeedCardInfoModel
  @Require @Param isDynamicsSingleDetail: boolean
  @Param isAll: boolean = false
  @Param fontSizeRatio: number = 1
  @Param searchKey: string = ''
  @Param showUserBar: boolean = true;
  @Param showTimeBottom: boolean = false;
  @Param isWatch: boolean = false
  @Param isFeedSelf: boolean = false
  @BuilderParam followBuilderParam: () => void = this.followBuilder;
  @BuilderParam publishCustomTimeBuilder: () => void = this.publishTimeBuilder;
  @Event onGoUserInfo: (authorId: string) => void = () => {}
  @Event onAddWatch: () => void = () => {}
  @Event onAddLike: () => void = () => {}
  @Event onAddComment: () => void = () => {}
  @Event onVideo: () => void = () => {}
  @Local currentTextCount: number | undefined = undefined
  @Local imageList: ResourceStr [] = []
  @Local imageWidth: number = 0
  @Local imageHeight: number = 0
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;

  @Computed
  get getAuthorIcon() {
    return this.isFeedSelf ? this.userInfoModel.authorIcon : this.curFeedCardInfo.author.authorIcon
  }

  @Computed
  get getAuthorName() {
    return this.isFeedSelf ? this.userInfoModel.authorNickName : this.curFeedCardInfo.author.authorNickName
  }

  aboutToAppear(): void {
    // 收集图片信息
    this.imageList = this.curFeedCardInfo.postImgList?.map((item: PostImgList) => {
      if (!item.surfaceUrl) {
        return item.picVideoUrl
      }
      return ''
    }) as []
  }

  @Builder
  followBuilder() {
  };

  @Builder
  publishTimeBuilder() {
    if (this.isDynamicsSingleDetail) {
      Column() {
        Text(getDateDiff(this.curFeedCardInfo?.createTime))
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.font_tertiary'))
      }.width('100%').alignItems(HorizontalAlign.Start)
    }

  };

  getImageList(value: PostImgList[]): ResourceStr[] {
    if (!Array.isArray(value)) {
      return [];
    }

    return value.map((item: PostImgList) => {
      if (!item.surfaceUrl) {
        return item.picVideoUrl;
      }
      return item.surfaceUrl
    });
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row({ space: 8 }) {
          Stack({ alignContent: Alignment.BottomEnd }) {
            Image(this.getAuthorIcon || $r('app.media.icon_default'))
              .alt($r('app.media.icon_default'))
              .width(40)
              .height(40)
              .borderRadius('50%')
              .clip(true)
              .onClick(() => {
                this.onGoUserInfo(this.curFeedCardInfo.author.authorId)
              })
          }

          Column({ space: 8 }) {
            Text(this.getAuthorName)
              .fontColor($r('sys.color.font_primary'))
              .fontSize(14 * this.fontSizeRatio)
              .fontWeight(FontWeight.Medium)
            this.publishCustomTimeBuilder()
          }.alignItems(HorizontalAlign.Start)
        }
        .flexGrow(1)

        this.followBuilderParam()
      }
      .margin({
        bottom: 12,
      })
      .visibility(this.showUserBar ? Visibility.Visible : Visibility.None)

      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          ArticleTextEllipsis({
            text: this.curFeedCardInfo.title,
            fontSizeRatio: this.fontSizeRatio,
            isAll: this.isAll,
            searchKey: this.searchKey,
          })
        }.width('100%')

      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      Column() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap }) {
          ForEach(this.curFeedCardInfo.postImgList,
            (item: PostImgList, index: number) => {
              FeedSingleImageSize({
                fontSizeRatio: this.fontSizeRatio,
                componentId: this.componentId,
                isWatch: this.isWatch,
                isFeedSelf: this.isFeedSelf,
                imageWidth: this.imageWidth,
                imageHeight: this.imageHeight,
                curFeedCardInfo: this.curFeedCardInfo,
                postImgListItem: item,
                imageList: this.getImageList(this.curFeedCardInfo.postImgList ?? []),
                index: index,
                onAddWatch: () => {
                  this.onAddWatch()
                },
                onAddLike: () => {
                  this.onAddLike()
                },
                onAddComment: () => {
                  this.onAddComment()
                },
                onVideo: () => {
                  this.onVideo()
                },
              })
            }, (item: PostImgList) => item.id)
        }
        .width('100%')
      }
      .onAreaChange(() => {
        if (this.imageList.length === 1) {
          this.imageWidth = calculateDimensions(this.curFeedCardInfo.postImgList?.[0].surfaceUrl ?
          this.curFeedCardInfo.postImgList?.[0].surfaceUrl :
          this.curFeedCardInfo.postImgList?.[0].picVideoUrl).width
          this.imageHeight = calculateDimensions(this.curFeedCardInfo.postImgList?.[0].surfaceUrl ?
          this.curFeedCardInfo.postImgList?.[0].surfaceUrl :
          this.curFeedCardInfo.postImgList?.[0].picVideoUrl).height
        } else {
          this.imageWidth =
            twoImagesSize(this.curFeedCardInfo.postImgList?.length ?? 0, this.getUIContext(), this.componentId)
          this.imageHeight =
            twoImagesSize(this.curFeedCardInfo.postImgList?.length ?? 0, this.getUIContext(), this.componentId)
        }
      })

      if (this.showTimeBottom) {
        Column() {
          Text(getDateDiff(this.curFeedCardInfo?.createTime))
            .fontSize(12 * this.fontSizeRatio)
            .fontColor($r('sys.color.font_tertiary'))
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 8 })
      }
    }
  }
}