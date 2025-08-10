import { BaseViewModel, CommonDataSource } from 'lib_common';
import { MineServiceApi } from 'lib_news_api';
import { AVPlayerManager } from 'module_swipeplayer';
import { VideoNewsData } from '../models/VideoModel';
import { VideoService } from '../services/VideoService';

@ObservedV2
export class RecommendPageVM extends BaseViewModel {
  // List显示区域内第一个子组件索引值
  @Trace startIndex: number = 0;
  // List显示区域内中间子组件索引值
  @Trace centerIndex: number = 0;
  // List显示区域内最后子组件索引值
  @Trace endIndex: number = 0;
  // 当前播放的index
  @Trace currentIndex: number = 0;
  // 下拉刷新
  @Trace isRefreshing: boolean = false;
  // 跟手滑动系数
  @Trace ratio: number = 1
  // 下拉最到高度
  @Trace maxRefreshingHeight: number = 160.0
  // 下拉刷新组件的状态
  @Trace refreshStatus: RefreshStatus = RefreshStatus.Inactive;
  // 上拉加载
  @Trace isLoadingMore: boolean = false;
  // 滑动的距离
  @Trace yOffset: number = 0
  // 是否滑动到起始位置
  @Trace isScrollStart: boolean = true;
  // 是否滑动到底部
  @Trace isScrollEnd: boolean = false;
  // 是否是手动点击item播放滚动
  @Trace isListScrollByUserClick: boolean = false;
  // 手动点击播放的index
  @Trace playIndex: number = 0
  // 懒加载数据
  videoListDataSource = new CommonDataSource<VideoNewsData>();
  // 视频播放控制
  listScroller: ListScroller = new ListScroller();
  // 播放管理
  avPlayerManager: AVPlayerManager = AVPlayerManager.getInstance()

  initVideoListDataSource() {
    let videoList = VideoService.queryVideoList();
    this.videoListDataSource.setData(videoList);
  }

  refreshList() {
    this.avPlayerManager.clear()
    // 模拟下拉刷新
    setTimeout(() => {
      this.initVideoListDataSource();
      //  重置
      this.currentIndex = 0;
      this.isRefreshing = false;
    }, 1000);
  }

  offsetChanged(offset: number) {
    // 越接近最大距离，下拉跟手系数越小
    this.ratio = 1 - Math.pow(offset / this.maxRefreshingHeight, 3);
  }

  loadMore() {
    this.isScrollEnd = true
    this.isLoadingMore = true;
    setTimeout(() => {
      let videoList = VideoService.queryVideoList();
      this.videoListDataSource.pushDataArray(...videoList)
      this.isLoadingMore = false;
    }, 1000);
  }

  // 处理滚动事件
  handleScrollIndex(start: number, end: number, center: number) {
    this.startIndex = start;
    this.endIndex = end;
    this.centerIndex = center
    if (start > 0 && end < this.videoListDataSource.totalCount()) {
      this.isScrollStart = false;
      this.isScrollEnd = false
    }
  }

  // 处理滚动停止
  handleScrollStop() {
    if (this.isRefreshing) {
      return
    }
    if (this.isListScrollByUserClick) {
      this.currentIndex = this.playIndex
    } else {
      // 推荐视频自动播放开关
      if (this.settingInfo.network.autoPlayTabRecommend) {
        if (this.isScrollStart) {
          this.currentIndex = this.yOffset > 120 ? this.centerIndex : 0
        } else if (this.isScrollEnd) {
          this.currentIndex = this.endIndex - 1;
        } else {
          this.currentIndex = this.centerIndex;
        }
      }
    }

    this.yOffset = 0;
    this.isListScrollByUserClick = false;
    this.isScrollStart = false;
    this.isScrollEnd = false;
  }

  // 点击视频item触发的滚动
  handleListScrollByUserClick(index: number) {
    this.isListScrollByUserClick = true;
    this.playIndex = index;
    this.listScroller.scrollToIndex(index, true);
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