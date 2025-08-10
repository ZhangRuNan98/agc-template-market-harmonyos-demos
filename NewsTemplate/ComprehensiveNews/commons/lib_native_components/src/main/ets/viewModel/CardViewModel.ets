import { LoginSheetUtils } from 'lib_account';
import { BaseViewModel, CommonConfirmDialog, NewsEnum, RouterMap, RouterToNews, RouterUtils } from 'lib_common';
import { CommentServiceApi, LayoutParams, MineServiceApi, NewsResponse } from 'lib_news_api';
import { AVPlayerSession } from 'module_swipeplayer';

export class CardViewModel extends BaseViewModel {
  private authorId: string = ''

  setAuthorId(authorId: string) {
    this.authorId = authorId
  }

  public isWatch() {
    return this.userInfoModel.isLogin && this.userInfoModel.watchers.includes(this.authorId)
  }

  public watchOperation() {
    if (!this.userInfoModel.isLogin) {
      LoginSheetUtils.open()
      return
    }
    if (!this.isWatch()) {
      this.addWatch()
      return
    }
    this.cancelWatch()
  }

  public addWatch() {
    this.userInfoModel.watchers.push(this.authorId)
    MineServiceApi.addWatch(this.authorId)
  }

  public likeOperation(cardInfo: NewsResponse) {
    if (!this.userInfoModel.isLogin) {
      LoginSheetUtils.open()
      return
    }
    cardInfo.isLiked = !cardInfo.isLiked
    if (cardInfo.isLiked) {
      cardInfo.likeCount += 1
      CommentServiceApi.addPosterLike(cardInfo.id)
      MineServiceApi.addLike(cardInfo.id)
      return
    }
    cardInfo.likeCount -= 1
    CommentServiceApi.cancelPosterLike(cardInfo.id)
    MineServiceApi.cancelLike(cardInfo.id)
  }

  public cancelWatch() {
    CommonConfirmDialog.show({
      content: '确定不再关注TA？',
      confirm: () => {
        MineServiceApi.cancelWatch(this.authorId);
        let watchIndex = this.userInfoModel.watchers.findIndex(v => v === this.authorId)
        this.userInfoModel.watchers.splice(watchIndex, 1)
        MineServiceApi.cancelWatch(this.authorId)
      },
    })
  }

  public pushToNewsDetails(cardData: LayoutParams, type?: string) {
    if (cardData.nativeCardData.type === NewsEnum.Video || cardData.nativeCardData.postImgList?.[0]?.surfaceUrl) {
      let param: Record<string, string | number> = {
        'id': cardData.nativeCardData.id,
        'type': cardData.nativeCardData.type as number
      }
      if(cardData.extraInfo.authorId) {
        param.authorId = cardData.nativeCardData.author.authorId
      }
      RouterUtils.pushPathByName(RouterMap.VIDEO_DETAIL_PAGE, param)
      return
    }
    RouterToNews.routerToNewsByDetails(cardData.nativeCardData, type)
  }
}