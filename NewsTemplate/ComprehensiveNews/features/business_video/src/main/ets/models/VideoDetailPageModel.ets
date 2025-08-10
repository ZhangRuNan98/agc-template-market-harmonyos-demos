import { RouterMap, RouterUtils } from 'lib_common';
import { MineServiceApi } from 'lib_news_api';
import { AVPlayerManager, AVPlayerSession, SwipePlayerController } from 'module_swipeplayer';
import { VideoService } from '../services/VideoService';
import { VideoSwipePageVM } from '../viewmodels/VideoSwipePageVM';

@ObservedV2
export class VideoDetailPageModel extends VideoSwipePageVM {
  // 滑动播放控制器
  swipePlayerController: SwipePlayerController = new SwipePlayerController();
  avPlayerManager: AVPlayerManager = new AVPlayerManager();
  // 点击列表页的视频卡片对应的播放会话
  videoItemPlayerSession: AVPlayerSession  | undefined
  // 用户
  userId: string = ''
  // 视频列表总数
  totalCount: number = 0;
  // 是否需要无限滚动
  isInfiniteScroll: boolean = false;
  // 页面上手势滑动距离
  @Trace offsetX: number = 0;

  initAVPlayerMgr(param: Record<string, string | number | AVPlayerSession | undefined>) {
    let playerSession = param.playerSession as AVPlayerSession
    if (playerSession) {
      this.videoItemPlayerSession = playerSession
    }
    this.swipePlayerController.setAVPlayerMgr(this.avPlayerManager)
  }

  initVideoListDataSource(param: Record<string, string | number | AVPlayerSession | undefined>) {
    const videoId = param.id as string;
    this.userId = param.authorId as string;
    this.isInfiniteScroll = !this.userId
    let type = param.type as number
    let videoList = VideoService.queryVideoList(this.userId || '', type);
    if (videoId) {
      videoList = videoList.filter((item) => item.id !== videoId)
      const videoDetailInfo = VideoService.queryVideoDataById(videoId)
      if (videoDetailInfo) {
        videoList.unshift(videoDetailInfo)
      }
    }
    // 模拟无限上滑
    this.totalCount = this.isInfiniteScroll ? Number.POSITIVE_INFINITY : videoList.length;
    this.videoDataSources.setData(videoList);
  }

  // 处理swiper动画开始事件
  handleSwiperAnimationStart(index: number, targetIndex: number) {
    let totalNum = this.videoDataSources.totalCount();
    // 加载更多，无限上滑
    if (this.isInfiniteScroll || totalNum < this.totalCount) {
      if (totalNum - targetIndex <= 5) {
        let videoList = VideoService.queryVideoList(this.userId);
        this.videoDataSources.pushDataArray(...videoList);
        this.totalCount = this.videoDataSources.totalCount();
      }
    }
  }

  // 处理从右向左滑的手势事件
  handleSwiperRightAction() {
    if (this.offsetX < 0) {
      const idx = this.swipePlayerController.curentIndex;
      const data = this.videoDataSources.getData(idx)
      const userId = data?.author?.authorId
      if (userId) {
        RouterUtils.pushPathByName(RouterMap.PROFILE_HOME, userId)
      }
    }
  }

  // 监听播放状态
  onPlayerStateListen(state: string, id: string) {
    // 如果是播放状态，则添加到历史记录
    if (state === 'playing') {
      // 添加到浏览历史
      this.addHistoryList(id)
    }
  }

  addHistoryList(id: string) {
    MineServiceApi.addToHistory(id)
  }
}