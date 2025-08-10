import { UserInfoModel } from 'lib_common'
import { AuthorInfo, CommentInfo, MakeObCommentServed } from '../model/Model'
import { CommentEventDispatcher } from '../utils/EventDispatcher'

@ObservedV2
export class FeedCommentVM {
  private static _instance: FeedCommentVM
  @Trace fontSizeRatio: number = 1
  @Trace isDark:boolean = false
  userInfo: UserInfoModel = new UserInfoModel()

  public static get instance() {
    if (!FeedCommentVM._instance) {
      FeedCommentVM._instance = new FeedCommentVM()
    }
    return FeedCommentVM._instance
  }

  public setUserInfo(userInfo: UserInfoModel) {
    this.userInfo = userInfo
  }

  public addComment(commentInfo: CommentInfo, replyContent: string) {
    /*
     * mock 随机入库操作
     * */
    let currentComment: CommentInfo = {
      commentId: `${commentInfo.commentId}_${Math.floor(Math.random() * 10)}`,
      newsId: commentInfo.newsId,
      author: new AuthorInfo(this.userInfo),
      commentBody: replyContent,
      commentLikeNum: 0,
      createTime: new Date().getTime(),
      likeCount: 0,
      isLiked: false,
      replyComments: [],
    }
    commentInfo.replyComments.unshift(new MakeObCommentServed(currentComment))
    CommentEventDispatcher.dispatchToAddComment(currentComment, commentInfo.commentId)
  }

  public deleteComment(commentId:string) {
    CommentEventDispatcher.dispatchToDeleteComment(commentId)
  }

  public setFontSizeRatio(fontSizeRatio: number) {
    this.fontSizeRatio = fontSizeRatio
  }

  public setIsDark(isDark: boolean) {
    this.isDark = isDark
  }

  public giveLike(commentInfo: CommentInfo,isLike:boolean) {
    CommentEventDispatcher.dispatchToGiveLike(commentInfo,isLike)
  }
}