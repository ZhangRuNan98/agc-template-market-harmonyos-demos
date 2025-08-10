import { emitter } from '@kit.BasicServicesKit';
import { UIUtils } from '@kit.ArkUI';
import { RouterMap, RouterUtils, TimeUtils } from 'lib_common';
import { NewsResponse } from 'lib_news_api';
import { LoginSheetUtils } from 'lib_account';
import { PlayerLayoutSize } from 'module_swipeplayer';
import { Share } from 'module_share';
import { CommentController } from '../controller/CommentController';
import { CommentView } from './CommentView';
import { SideBarVM } from '../viewmodels/SideBarVM';

@ComponentV2
export struct Sidebar {
  // 视频信息
  @Param @Require videoInfo: NewsResponse
  // 评论组件控制器
  @Param commentController: CommentController = new CommentController();
  // 评论页面出现时，改变播放页面的尺寸
  @Param @Require playerLayoutSize: PlayerLayoutSize
  @Local isShowComment: boolean = false;
  @Local isShowKeyboard: boolean = false;

  vm: SideBarVM = new SideBarVM()

  @Monitor('isShowComment')
  onChangeShowComment(monitor: IMonitor) {
    if (!(monitor.value()?.now as boolean)) {
      this.isShowKeyboard = false
    }
  }

  aboutToAppear(): void {
    this.vm.videoInfo = UIUtils.makeObserved(this.videoInfo);
    this.commentController.open = (): void => this.open();
  }

  open() {
    this.isShowComment = true;
    this.isShowKeyboard = true;
  }

  build() {
    Column({space: 12}) {
      // 头像
      Column() {
        Image(this.videoInfo.author.authorIcon)
          .width(40)
          .height(40)
          .borderRadius(40)
          .onClick(() => {
            RouterUtils.pushPathByName(RouterMap.PROFILE_HOME, this.videoInfo.author.authorId)
          })

        Image(this.vm.isFollow() ? $r('app.media.ic_follow') : $r('app.media.ic_unfollow'))
          .width(14)
          .height(14)
          .borderRadius(14)
          .offset({bottom: 8})
          .backgroundColor(Color.White)
          .onClick(() => {
            this.vm.followOperation()
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)

      // 点赞
      Column({space: 4}) {
        Image(this.vm.videoInfo.isLiked ? $r('app.media.ic_like') : $r('app.media.ic_unlike'))
          .width(22)
          .height(22)

        Text(this.vm.getLikeCount())
          .fontSize(10).fontColor(Color.White)
      }
      .onClick(() => {
        this.vm.likeAction()
      })

      // 评论
      Column({space: 4}) {
        Image($r('app.media.ic_comment'))
          .width(22)
          .height(22)

        Text(this.vm.videoInfo.commentCount ? String(this.vm.videoInfo.commentCount) : '评论')
          .fontSize(10).fontColor(Color.White)
      }
      .onClick(() => {
        if (this.vm.videoInfo.commentCount) {
          this.isShowComment = !this.isShowComment
          return
        }
        if (!this.vm.userInfoModel.isLogin) {
          LoginSheetUtils.open();
        }
      })
      .bindSheet($$this.isShowComment, this.commentViewBuilder(), {
        height: '70%',
        blurStyle: BlurStyle.Thick,
        showClose: true,
        mode: SheetMode.EMBEDDED,
        maskColor: Color.Transparent,
        backgroundColor: $r('sys.color.background_secondary'),
        onHeightDidChange: (height: number) => {
          let sheetHeight = this.getUIContext().px2vp(height)
          let windowTop = this.vm.windowModel.windowTopPadding
          let tabHeight = this.vm.tabModel.tabHeight as number
          let total = sheetHeight - tabHeight
          const windowHeight = this.getUIContext().px2vp(this.vm.windowModel.windowHeight)
          this.playerLayoutSize.updatePlayerHeight(`${windowHeight - total - windowTop}vp`)
        },
        onWillDisappear: () => {
          this.commentController.showComment = false
          this.playerLayoutSize.updateLayoutSizeChangeFlag(false);
          this.playerLayoutSize.updatePlayerHeight('100%')
          let eventData: emitter.EventData = {
            data: {
              showTabHeader: true
            }
          };
          emitter.emit('showTabHeader', eventData)
        },
        onWillAppear: () => {
          this.commentController.showComment = true;
          this.playerLayoutSize.updateLayoutSizeChangeFlag(true);
          let eventData: emitter.EventData = {
            data: {
              showTabHeader: false
            }
          };
          emitter.emit('showTabHeader', eventData)
        }
      })

      // 收藏
      Column({space: 4}) {
        Image(this.vm.videoInfo.isMarked ? $r('app.media.ic_favorite') : $r('app.media.ic_unfavorite'))
          .width(22)
          .height(22)

        Text(this.vm.getMarkCount())
          .fontSize(10).fontColor(Color.White)
      }
      .onClick(() => {
        this.vm.saveAction()
      })
      // 分享
      Share({
        qrCodeInfo: {
          id: this.videoInfo.id,
          type: this.videoInfo.type,
          title: this.videoInfo.title,
          articleFrom: this.videoInfo.articleFrom,
          createTime: TimeUtils.formatDate(this.videoInfo.createTime),
          coverUrl: this.vm.handlerCoverImage(this.videoInfo),
          isVideo: true
        },
        shareRenderBuilder: () => {
          this.shareCommentBuilder()
        },
      })
    }
  }

  @Builder
  commentViewBuilder() {
    CommentView({
      videoInfo: this.vm.videoInfo,
      isShowKeyboard: this.isShowKeyboard,
    })
  }

  @Builder
  shareCommentBuilder() {
    Column({space: 4}) {
      Image($r('app.media.ic_share'))
        .width(22)
        .height(22)
      Text('分享').fontSize(10).fontColor(Color.White)
    }
  }
}