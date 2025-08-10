import { uiObserver, window } from '@kit.ArkUI';
import { AVPlayerSession, VideoCard, VideoNetworkModel, VideoNetworkSetting } from 'module_swipeplayer';
import { CommonConstants, Logger, RouterMap, RouterUtils, TimeUtils } from 'lib_common';
import { VideoNewsData } from '../models/VideoModel';
import { RecommendPageVM } from '../viewmodels/RecommendPageVM';
import { TabPageType } from '../types/Index';

const TAG = '[RecommendPage]'

@ComponentV2
export struct RecommendPage {
  // tab页面的index
  @Param index: number = 2
  // 视频页里面的头部tabIndex
  @Param currentTabIndex: number = 2;

  @Local vm: RecommendPageVM = new RecommendPageVM()

  // WindowStage生命周期变化的监听回调函数
  private windowStageEventCallback = (type: window.WindowStageEventType) => {
    const allPathStack = RouterUtils.getStack().getAllPathName()
    const lastPathName = allPathStack[allPathStack.length - 1];
    if (this.currentTabIndex === this.index && this.vm.tabModel.selectedIndex === 1 &&
      lastPathName === RouterMap.INDEX_PAGE
    ) {
      let eventType = window.WindowStageEventType;
      if (type === eventType.RESUMED || type === eventType.SHOWN) {
        this.vm.avPlayerManager.play(this.vm.currentIndex);
      } else if (type === eventType.PAUSED || type === eventType.HIDDEN) {
        this.vm.avPlayerManager.pause(this.vm.currentIndex);
      }
    }
  }

  // 切换视频头部tab
  @Monitor('currentTabIndex')
  onChangeTabIndex() {
    if (this.currentTabIndex === this.index) {
      this.vm.avPlayerManager.play(this.vm.currentIndex);
    } else {
      this.vm.avPlayerManager.pause(this.vm.currentIndex);
    }
    this.vm.tabModel.showTabBar = true;
  }

  // 切换底部tab
  @Monitor('vm.tabModel.selectedIndex')
  onChangeSelectedIndex() {
    if (this.currentTabIndex === this.index) {
      let swiperPlayerIdx = [TabPageType.FOLLOW, TabPageType.FEATURED, TabPageType.RECOMMEND];
      if (this.vm.tabModel.selectedIndex === 1 && swiperPlayerIdx.includes(this.currentTabIndex)) {
        this.vm.avPlayerManager.play(this.vm.currentIndex);
      } else {
        this.vm.avPlayerManager.pause(this.vm.currentIndex);
      }
    }
  }

  aboutToAppear(): void {
    // 获取数据
    this.vm.initVideoListDataSource();
    // 监听 windowStageEvent
    this.vm.windowStageModel.windowStageEventListeners.delete('recommendPage');
    this.vm.windowStageModel.windowStageEventListeners.set('recommendPage', (type) => {
      this.windowStageEventCallback(type)
    })
    // 监听路由变化的回调
    this.vm.navRouteModel.navDestinationUpdateListeners.delete('leaveVideoListListener')
    this.vm.navRouteModel.navDestinationUpdateListeners.set('leaveVideoListListener', (info) => {
      if (this.vm.navRouteModel.videoPauseByRoutePage.includes(info.name) &&
        info.state === uiObserver.NavDestinationState.ON_WILL_SHOW
      ) {
        this.vm.avPlayerManager.pause(this.vm.currentIndex);
        return;
      }
      if (info.name === 'IndexPage' && this.vm.tabModel.selectedIndex === 1 &&
        info.state === uiObserver.NavDestinationState.ON_WILL_SHOW &&
        this.index === this.currentTabIndex
      ) {
        this.vm.avPlayerManager.play(this.vm.currentIndex);
      }
    })
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.vm.isRefreshing, builder: this.customRefreshComponent }) {
        List({ scroller: this.vm.listScroller, space: 8 }) {
          LazyForEach(this.vm.videoListDataSource, (item: VideoNewsData, index: number) => {
            ListItem() {
              VideoCard({
                currentIndex: this.vm.currentIndex,
                index: index,
                videoData: item,
                isShown: this.currentTabIndex === this.index && this.vm.tabModel.selectedIndex === 1,
                videoNetwork: this.vm.networkModel as VideoNetworkModel,
                videoNetworkSetting: this.vm.settingInfo.network as VideoNetworkSetting,
                playerStateCallback: (state: string, id: string) => {
                  this.vm.onPlayerStateListen(state, id)
                },
                setUseMobileData: () => {
                  this.vm.networkModel.canUseMobileData = true
                },
                videoInfoViewBuilder: () => {
                  this.videoCardInfoView(item)
                },
                onClickEvent: (playerSession: AVPlayerSession | undefined, callback: Function) => {
                  let param: Record<string, string | AVPlayerSession | undefined> = {
                    'id': item.getVideoId(),
                    'playerSession': playerSession,
                  }
                  playerSession!.avPlayer?.pause();
                  // 监听页面跳转
                  this.vm.navRouteModel.navDestinationUpdateListeners.delete('clickVideoCardListener');
                  this.vm.navRouteModel.navDestinationUpdateListeners.set('clickVideoCardListener', (info) => {
                    // 离开推荐列表时，处理视频是否播放
                    if (info.name === 'IndexPage' && this.currentTabIndex === TabPageType.RECOMMEND &&
                      info.state === uiObserver.NavDestinationState.ON_WILL_SHOW &&
                      this.vm.tabModel.selectedIndex === 1
                    ) {
                      this.vm.tabModel.showTabBar = true
                      callback()
                    }
                  })
                  // 跳转到详情页
                  RouterUtils.pushPathByName(RouterMap.VIDEO_DETAIL_PAGE, param);
                },
                onPlayItem: (playIndex: number) => {
                  Logger.info(TAG, 'onPlayItem play video index is ' + playIndex)
                  this.vm.handleListScrollByUserClick(playIndex)
                }
              })
            }
          }, (item: VideoNewsData, index: number) => JSON.stringify(item) + index)
          // 加载更多
          this.loadingBuilder()
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .cachedCount(1)
        .scrollBar(BarState.Off)
        .friction(0.6)
        .edgeEffect(EdgeEffect.None)
        .onWillScroll((scrollOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
          this.vm.yOffset += scrollOffset
        })
        .onScrollIndex((start: number, end: number, center: number) => {
          this.vm.handleScrollIndex(start, end, center)
        })
        .onScrollStop(() => {
          this.vm.handleScrollStop()
        })
        .onReachStart(() => {
          this.vm.isScrollStart = true;
        })
        .onReachEnd(() => {
          this.vm.loadMore()
        })
      }
      .layoutWeight(1)
      .onRefreshing(() => {
        this.vm.refreshList()
      })
      .pullToRefresh(true)
      .pullDownRatio(this.vm.ratio)
      .refreshOffset(64)
      .onStateChange((state: RefreshStatus) => {
        this.vm.refreshStatus = state;
      })
      .onOffsetChange((offset: number) => {
        this.vm.offsetChanged(offset)
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      top: this.vm.windowModel.windowTopPadding + 56,
      bottom: this.vm.tabModel.tabHeight
    })
  }

  @Builder
  customRefreshComponent() {
    Stack() {
      if (this.vm.refreshStatus === RefreshStatus.Refresh) {
        LoadingProgress()
          .height(32)
      } else if (this.vm.refreshStatus === RefreshStatus.OverDrag) {
        Text('释放可刷新页面')
          .fontColor($r('sys.color.font_primary'))
          .fontSize(14)
      } else if (this.vm.refreshStatus === RefreshStatus.Drag) {
        Text('下拉刷新')
          .fontColor($r('sys.color.font_primary'))
          .fontSize(14)
      }
    }
    .align(Alignment.Bottom)
    .padding({top: 16, bottom: 16})
    .clip(true)
    .constraintSize({ minHeight: 32 })
    .width('100%')
  }

  @Builder
  loadingBuilder() {
    Row() {
      LoadingProgress()
        .width(24)
        .height(24)
        .color($r('sys.color.font_primary'))
      Text('正在获取更多内容')
        .fontColor($r('sys.color.font_primary'))
        .fontSize(12)
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding({top: CommonConstants.PADDING_XL, bottom: CommonConstants.PADDING_XL})
    .justifyContent(FlexAlign.Center)
    .visibility(this.vm.isLoadingMore ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  videoCardInfoView(item: VideoNewsData) {
    Column({space: 2}) {
      Text(item.title)
        .fontSize(16)
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(500)
        .lineHeight(21)
        .maxLines(2)

      Row({space: 12}) {
        Text(item.author.authorNickName)
          .fontSize(12)
          .fontColor($r('sys.color.font_primary'))
          .lineHeight(16)
        Text(TimeUtils.formatDate(item.createTime))
          .fontSize(12)
          .fontColor($r('sys.color.font_primary'))
          .lineHeight(16)
      }
    }
    .width(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: CommonConstants.PADDING_L,
      top: CommonConstants.PADDING_S,
      right: CommonConstants.PADDING_L,
      bottom: CommonConstants.PADDING_S,
    })
  }
}
