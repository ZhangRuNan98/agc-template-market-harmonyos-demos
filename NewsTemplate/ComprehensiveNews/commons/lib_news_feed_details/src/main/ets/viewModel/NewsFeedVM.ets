import { UIUtils } from '@kit.ArkUI'
import { BaseViewModel, BundleInfo, CommonConfirmDialog } from 'lib_common'
import {
  BaseNewsServiceApi,
  CommentResponse,
  CommentServiceApi,
  MineServiceApi,
  PublishCommentRequest,
} from 'lib_news_api'
import { LoginSheetUtils } from 'lib_account'
import { CommentInfo, NewsFeedInfo } from '../model/Model'
import { MakeObCommentServed } from '../utils/Utils'

@ObservedV2
export class NewsFeedVM extends BaseViewModel {
  private static _instance: NewsFeedVM
  @Trace articleDetails: NewsFeedInfo = new NewsFeedInfo()
  @Trace commentInfoList: CommentInfo[] = []
  @Trace scroller: Scroller = new Scroller();
  @Trace bundleInfo: BundleInfo | undefined = undefined

  public static get instance() {
    if (!NewsFeedVM._instance) {
      NewsFeedVM._instance = new NewsFeedVM()
    }
    return NewsFeedVM._instance
  }

  public initArticle(articleId: string) {
    let articleRes = BaseNewsServiceApi.queryNews(articleId) as NewsFeedInfo
    this.articleDetails = UIUtils.makeObserved(articleRes);
  }

  public initComment(articleId: string) {
    let commentInfo = CommentServiceApi.queryCommentList(articleId) as CommentInfo[]
    this.commentInfoList = commentInfo?.map((value: CommentInfo) => {
      return new MakeObCommentServed(value)
    }) ?? [];
  }

  public newsLike() {
    if (!this.userInfoModel.isLogin) {
      LoginSheetUtils.open()
      return
    }
    this.articleDetails.isLiked = !this.articleDetails.isLiked
    if (this.articleDetails.isLiked) {
      CommentServiceApi.addPosterLike(this.articleDetails.id)
      MineServiceApi.addLike(this.articleDetails.id)
      this.articleDetails.likeCount++
      return
    }
    CommentServiceApi.cancelPosterLike(this.articleDetails.id)
    MineServiceApi.cancelLike(this.articleDetails.id)
    this.articleDetails.likeCount--
  }


  public isWatch() {
    let authorId = this.articleDetails.author.authorId
    return this.userInfoModel.isLogin && this.userInfoModel.watchers.includes(authorId)
  }

  public watchOperation(isLoginCb?: (isLogin: boolean) => void) {
    isLoginCb?.(this.userInfoModel.isLogin)
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
    let authorId = this.articleDetails.author.authorId
    this.userInfoModel.watchers.push(authorId)
    MineServiceApi.addWatch(authorId)
  }

  public cancelWatch() {
    CommonConfirmDialog.show({
      content: '确定不再关注TA？',
      confirm: () => {
        let watchIndex = this.userInfoModel.watchers.findIndex(v => v === this.articleDetails.author.authorId)
        this.userInfoModel.watchers.splice(watchIndex, 1)
        MineServiceApi.cancelWatch(this.articleDetails.author.authorId)
      },
    })
  }

  public addHistory() {
    MineServiceApi.addToHistory(this.articleDetails.id)
  }

  public addSingleComment(comment: CommentResponse, parentCommentId: string) {
    const params: PublishCommentRequest = {
      newsId: comment.newsId,
      content: comment.commentBody,
      parentCommentId: parentCommentId,
    };
    MineServiceApi.publishComment(params)
  }

  public deleteComment(commentId: string) {
    const index = this.commentInfoList.findIndex(v => v.commentId === commentId);
    if (index !== -1) {
      this.commentInfoList.splice(index, 1);
    }
    CommentServiceApi.deleteComment(commentId)
  }

  public setCommentInfo(commentInfoList: CommentInfo[], comment: CommentResponse, isLike: boolean) {
    if (commentInfoList.length) {
      commentInfoList.forEach(item => {
        if (item.commentId === comment.commentId) {
          item.isLiked = isLike
          item.commentLikeNum = isLike ? item.commentLikeNum + 1 : item.commentLikeNum - 1
        }
        this.setCommentInfo(item.replyComments, comment, isLike)
      })
    }
  }

  public addLike(comment: CommentResponse, isLike: boolean) {
    if (!this.userInfoModel.isLogin) {
      LoginSheetUtils.open()
      return
    }
    this.setCommentInfo(this.commentInfoList, comment, isLike)
    if (comment.isLiked) {
      CommentServiceApi.addCommentLike(comment.commentId)
      return
    }
    CommentServiceApi.cancelCommentLike(comment.commentId)
  }

  public addMark(isMark: boolean) {
    if (!this.userInfoModel.isLogin) {
      LoginSheetUtils.open()
      return
    }
    this.articleDetails.isMarked = isMark
    if (isMark) {
      BaseNewsServiceApi.addMark(this.articleDetails.id)
      MineServiceApi.addMark(this.articleDetails.id)
      this.articleDetails.markCount += 1
      return
    }
    BaseNewsServiceApi.cancelMark(this.articleDetails.id)
    MineServiceApi.cancelMark(this.articleDetails.id)
    this.articleDetails.markCount -= 1
  }

  public async addNewsComment(commentContent: string) {
    this.articleDetails.commentCount++
    const params: PublishCommentRequest = {
      newsId: this.articleDetails.id,
      content: commentContent,
      parentCommentId: '',
    };
    let addComment = await MineServiceApi.publishComment(params) as CommentInfo
    /*
     * 通知卡片刷新
     * */
    this.commentInfoList.unshift(new MakeObCommentServed(addComment))
  }

  public setCardData(cardData: NewsFeedInfo) {
    this.articleDetails = UIUtils.makeObserved(cardData);
  }

  getUserInfo() {
    return this.userInfoModel
  }

  setWebFontColor(isDark: boolean): string {
    if (isDark) {
      return 'white'
    }
    return 'black'
  }

  setRichToHtml(isDark: boolean) {
    return `
        <html>
        <body id="body" style="color: ${this.setWebFontColor(isDark)}">
          ${this.articleDetails.richContent}
          <script>
           function getSize() { return { width: document.getElementById('body').offsetWidth, height: document.getElementById('body').offsetHeight } }
           function callNativePreview(srcList, index) {
                native.preview(srcList, index);
            }
            let imageList = document.querySelectorAll(".image-preview")
            imageList.forEach((element,index) => {
                element.addEventListener('click', function () {
                    let scrList = [...imageList].map(value => {
                        return value.src
                    })
                    callNativePreview(scrList, index)
                })
            });
        </script>
      </body>
    </html>
   `
  }

  public scrollToComment() {
    this.scroller.scrollToIndex(3, true)
  }

}

export default NewsFeedVM