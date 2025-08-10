import { uiObserver, window } from '@kit.ArkUI'
import { CommonConstants, RouterMap, RouterUtils, SystemBarOperation } from 'lib_common';
import {
  AVPlayerSession,
  CustomTransition,
  VideoNetworkModel,
  VideoNetworkSetting,
  VideoSwipePlayer,
} from 'module_swipeplayer';
import { VideoNewsData } from '../models/VideoModel';
import { VideoLayerViewBuilder } from '../components/VideoLayerView';
import { VideoDetailPageModel } from '../models/VideoDetailPageModel';
import { BaseParamType } from '../types/Index';

@ComponentV2
export struct VideoDetailPage {
  pathStack = new NavPathStack()
  // 数据源
  @Local videoList: VideoNewsData[] = [];
  private pageId: number = -1;

  vm: VideoDetailPageModel = new VideoDetailPageModel()

  // WindowStage生命周期变化的监听回调函数
  private windowStageEventCallback = (type: window.WindowStageEventType) => {
    const allPathStack = this.pathStack.getAllPathName()
    const lastPathName = allPathStack[allPathStack.length - 1];
    if (lastPathName === RouterMap.VIDEO_DETAIL_PAGE) {
      let eventType = window.WindowStageEventType
      if (type === eventType.RESUMED || type === eventType.SHOWN) {
        this.vm.swipePlayerController.play();
      } else if (type === eventType.PAUSED || type === eventType.HIDDEN) {
        this.vm.swipePlayerController.pause();
      }
    }
  }

  aboutToAppear(): void {
    // 监听 windowStageEvent
    this.vm.windowStageModel.windowStageEventListeners.delete('videoDetailPage');
    this.vm.windowStageModel.windowStageEventListeners.set('videoDetailPage', (type) => {
      this.windowStageEventCallback(type)
    })
    // 记录路由跳转之前视频的播放状态
    let avPlayerState = ''
    // 监听页面跳转
    this.vm.navRouteModel.navDestinationUpdateListeners.delete('leaveVideoDetailPageListener')
    this.vm.navRouteModel.navDestinationUpdateListeners.set('leaveVideoDetailPageListener', (info) => {
      if (this.vm.navRouteModel.videoPauseByRoutePage.includes(info.name) &&
        this.pathStack.getIndexByName(RouterMap.VIDEO_DETAIL_PAGE).length &&
        info.state === uiObserver.NavDestinationState.ON_WILL_SHOW
      ) {
        avPlayerState = this.vm.swipePlayerController.getAVPlayer()?.state as string
        this.vm.swipePlayerController.pause();
        return;
      }

      if (info.name === RouterMap.VIDEO_DETAIL_PAGE &&
        info.state === uiObserver.NavDestinationState.ON_WILL_SHOW
      ) {
        // 如果跳转之前是播放状态，则返回时继续播放，否则暂停
        if (avPlayerState === 'playing') {
          this.vm.swipePlayerController.play();
        }
      }
    });
  }

  // 注册自定义动画协议
  private registerCustomTransition(): void {
    CustomTransition.getInstance().registerNavParam(this.pageId,
      (isPush: boolean, isExit: boolean, transitionProxy: NavigationTransitionProxy) => {}, 500);
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        VideoSwipePlayer({
          datasource: this.vm.videoDataSources,
          swipePlayerController: this.vm.swipePlayerController,
          videoItemPlayerSession: this.vm.videoItemPlayerSession,
          videoLayerBuilder: wrapBuilder(VideoLayerViewBuilder),
          videoNetwork: this.vm.networkModel as VideoNetworkModel,
          videoNetworkSetting: this.vm.settingInfo.network as VideoNetworkSetting,
          pathStack: this.pathStack,
          playerStateCallback: (state: string, id: string) => {
            this.vm.onPlayerStateListen(state, id)
          },
          options: {
            autoPlay: true,
            totalCount: this.vm.totalCount,
            bottomTabHeight: this.vm.tabModel.tabHeight,
            swiperCallback: {
              onAnimationStart: (_index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
                this.vm.handleSwiperAnimationStart(_index, targetIndex)
                // 判断是否到底
                if (_index === targetIndex && this.vm.totalCount === targetIndex + 1) {
                  this.getUIContext().getPromptAction().showToast({
                    message: '暂无更多视频',
                    alignment: Alignment.Center,
                  });
                }
              },
            },
          }
        })

        Row() {
          Row() {
            Image($r('app.media.ic_left_arrow'))
              .width(9)
              .height(16)
              .fillColor(Color.White)
          }
          .width(40)
          .height(40)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            RouterUtils.pop()
          })
        }
        .width(CommonConstants.FULL_PERCENT)
        .padding({
          left: CommonConstants.PADDING_S,
          right: CommonConstants.PADDING_L,
          top: this.vm.windowModel.windowTopPadding
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .priorityGesture(
        PanGesture({ direction: PanDirection.Left })
          .onActionUpdate((event: GestureEvent) => {
            if (event) {
              this.vm.offsetX = event.offsetX;
            }
          })
          .onActionEnd(() => {
            this.vm.handleSwiperRightAction()
          })
      )
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      let param = context.pathInfo?.param as Record<string, AVPlayerSession | BaseParamType>
      // 初始化播放管理
      this.vm.initAVPlayerMgr(param)
      // 获取数据
      this.vm.initVideoListDataSource(param)
      // 自定义动画所需的pageId
      if (context.pathStack.getAllPathName()?.length) {
        this.pageId = context.pathStack.getAllPathName().length - 1;
      }
      this.registerCustomTransition();
    })
    .onDisAppear(() => {
      CustomTransition.getInstance().unRegisterNavParam(this.pageId);
    })
    .onShown(() => {
      SystemBarOperation.setWindowSystemBarProp({
        statusBarContentColor: '#ffffff',
      })
    })
    .onHidden(() => {
      SystemBarOperation.setWindowSystemBarProp({
        statusBarContentColor: '#ff090909',
      })
    })
  }
}


@Builder
export function VideoDetailBuilder() {
  VideoDetailPage()
}
