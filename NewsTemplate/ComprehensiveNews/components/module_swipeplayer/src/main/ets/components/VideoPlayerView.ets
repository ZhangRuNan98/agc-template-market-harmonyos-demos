import { media } from '@kit.MediaKit';
import { emitter } from '@kit.BasicServicesKit';
import { uiObserver, window } from '@kit.ArkUI';
import { AVPlayerState, VideoPlayerData } from '../type/Index';
import { AVPlayerSession } from '../controller/AVPlayerManager';
import { SwipePlayerController } from '../controller/SwipePlayerController';
import { PlayerLayoutSize } from '../controller/PlayerLayoutSize';
import { VideoProgressBar } from './VideoProgressBar';
import { Constants } from '../constants/Constants';
import { SwipePlayerModel } from '../viewmodel/SwipePlayerModel';
import { PlayerSpeedRateView } from './PlayerSpeedRateView';
import { VideoNetworkModel, VideoNetworkSetting } from '../models/VideoNetworkModel';
import { handleSandboxVideoUrl, setOrientation, toast } from '../utils/Util';
import { ComponentAttrUtils, RectInfoInPx } from '../customtransition/ComponentAttrUtils';

@ComponentV2
export struct VideoPlayerView {
  // 视频数据
  @Param @Require videoData: VideoPlayerData;
  // 本视频索引
  @Param index: number = 0;
  // swiper中当前的播放索引
  @Param currentIndex: number = 0;
  // 总数
  @Param totalCount: number = 0;
  // 滑动组件控制器
  @Param @Require swipePlayerController: SwipePlayerController;
  // 视频播放的外层交互组件
  @Param videoLayerBuilder:
  WrappedBuilder<[ESObject, AVPlayerSession, SwipePlayerController, PlayerLayoutSize]> | undefined = undefined;
  // 全屏按钮
  @BuilderParam fullBtnBuilder: () => CustomBuilder
  // 是否自动播放
  @Param autoPlay: boolean = true;
  // 点击列表页的视频卡片对应的视频
  @Param videoItemPlayerSession: AVPlayerSession | undefined = undefined
  // 网络
  @Param videoNetwork: VideoNetworkModel | undefined = undefined
  @Param videoNetworkSetting: VideoNetworkSetting | undefined = undefined
  // 底部tab高度
  @Consumer() bottomTabHeight: Length | undefined;
  // 路由变化的监听事件
  @Consumer() navDestinationUpdateListeners: Map<string, (info: uiObserver.NavDestinationInfo) => void> = new Map();
  // 路由栈
  @Param @Require pathStack: NavPathStack

  private xComponentController = new XComponentController();

  vm: SwipePlayerModel = new SwipePlayerModel(this.getUIContext(), this.index)

  // 准备状态监听事件
  private preparedListener = () => {
    if (this.index === this.currentIndex && this.autoPlay) {
      this.vm.playerSession.play()
    }
  }
  // 资源初始化状态
  private initializedListener = (avPlayer: media.AVPlayer) => {
    let timer = setInterval(() => {
      if (this.index !== this.currentIndex) {
        if (this.vm.avPlayerManager.getAVPlayer(this.currentIndex)?.state === 'playing') {
          avPlayer!.prepare();
          clearInterval(timer);
        }
      } else {
        avPlayer!.prepare();
      }
    }, 100);
  }
  // 播放时监听
  private playingListeners = () => {
    emitter.emit('swipeVideoPlayerState', {
      data: {
        state: AVPlayerState.PLAYING,
        id: this.videoData.getVideoId(),
      }
    } as emitter.EventData)
  }
  // 播放完成状态监听事件
  private completedListeners = () => {
    // 横屏时，播放完成后，重头开始播放
    if (this.vm.isLandscape) {
      this.vm.playerSession.play();
      return
    }
    // 设置自动播放下一个
    if (this.videoNetworkSetting?.autoPlayNext) {
      if (!this.totalCount || this.currentIndex + 1 < this.totalCount) {
        this.vm.isPause = true;
        this.vm.playerSession.avPlayer!.seek(0, media.SeekMode.SEEK_CLOSEST);
        this.swipePlayerController.changeIndex(this.currentIndex + 1);
        return
      }
    }
    // 其他情况，重头开始播放
    this.vm.playerSession.play()
  }
  // 视频播放错误事件监听
  private errorListener = () => {
    if (this.videoNetwork && !this.videoNetwork.hasNet && this.vm.isBuffering) {
      toast(this.vm.uiContext!, {
        message: '网络连接不可用',
        alignment: Alignment.Center,
        textColor: Color.Red
      })
      this.vm.isBuffering = false;
      this.vm.isPause = true;
    }
  }
  // 缓存事件监听
  private buffingUpdateListener = (infoType: media.BufferingInfoType) => {
    if (this.currentIndex === this.index) {
      if (infoType === media.BufferingInfoType.BUFFERING_START) {
        this.vm.isPause = false;
        this.vm.isBuffering = true;
      }
      if (infoType === media.BufferingInfoType.BUFFERING_END) {
        this.vm.isBuffering = false
      }
    }
  }

  @Monitor('currentIndex')
  onIndexChanged() {
    this.onChangeSwiperIndex();
  }
  
  @Monitor('videoNetwork.hasNet')
  onListenNetwork(monitor: IMonitor) {
    let hasNet = monitor.value()?.now as boolean
    let playerState = this.vm.playerSession?.avPlayer?.state
    if (this.index === this.currentIndex && playerState === 'idle' && hasNet) {
      if (this.videoData.getVideoUrl().startsWith('http')) {
        this.vm.playerSession.avPlayer!.url = this.videoData.getVideoUrl()
      } else {
        this.vm.playerSession.avPlayer!.url = handleSandboxVideoUrl(this.videoData.getVideoUrl())
      }
    }
  }

  aboutToAppear(): void {
    // 初始化
    this.vm.avPlayerManager = this.swipePlayerController.getAVPlayerMgr()!
    this.vm.initPlayerManager(this.videoData, this.videoItemPlayerSession)
    this.vm.initXComponentId()
    // 准备状态监听事件
    this.vm.onPreparedListener(this.preparedListener);
    // 资源初始化状态
    this.vm.onInitializedListener(this.initializedListener);
    // 播放状态
    this.vm.onPlayingListener(this.playingListeners)
    // 完成状态监听事件
    this.vm.onCompletionListener(this.completedListeners)
    // 播放错误状态监听事件
    this.vm.onErrorListener(this.errorListener)
    // 缓存事件监听
    this.vm.onBuffingUpdateListener(this.buffingUpdateListener)
    // 监听首帧事件
    this.vm.onStartRenderFrameListener(() => {
      if (this.index === this.currentIndex) {
        this.vm.isPause = false
        this.vm.showCover = false;
      }
    })
    // 视频尺寸变化监听
    this.vm.onVideoSizeChangedListener(() => {
      this.vm.adaptiveVideoSize()
    })
  }

  aboutToDisappear(): void {
    // 从列表页跳转过来的，不需要销毁播放对象
    if (!this.vm.isFromList) {
      this.vm.handlerDisappear()
    }
  }

  onChangeSwiperIndex() {
    this.swipePlayerController!.curentIndex = this.currentIndex;
    if (this.index !== this.currentIndex) {
      this.vm.isPause = true;
      this.vm.playerSession.pause();
      return;
    }
    this.vm.isPause = false;
    if (this.vm.playerSession.avPlayer?.state! === 'idle') {
      if (this.videoData.getVideoUrl().startsWith('http')) {
        this.vm.playerSession.avPlayer!.url = this.videoData.getVideoUrl()
      } else {
        this.vm.playerSession.avPlayer!.url = handleSandboxVideoUrl(this.videoData.getVideoUrl())
      }
      return
    }
    let canPlayStates = [AVPlayerState.PREPARED, AVPlayerState.PAUSED, AVPlayerState.COMPLETED] as media.AVPlayerState[]
    if (canPlayStates.includes(this.vm.playerSession.avPlayer?.state!)) {
      this.vm.playerSession.avPlayer?.setSpeed(1);
      this.vm.playerSession.play();
    }
  }

  // 处理横屏按钮事件
  handleFullScreen(uiContext: UIContext, param: Record<string, Object | AVPlayerSession>) {
    let cardItemInfo: RectInfoInPx = ComponentAttrUtils.getRectInfoById(uiContext, 'player');
    param.cardItemInfo = cardItemInfo;
    // 视频播放，跨页面流转
    this.navDestinationUpdateListeners.delete('fullScreenListener');
    this.navDestinationUpdateListeners.set('fullScreenListener', (info) => {
      if (info.name === 'LandscapeVideo' && info.state === 3) {
        let avPlayer = (param.playerSession as AVPlayerSession).getAVPlayer() as media.AVPlayer;
        if (avPlayer) {
          avPlayer.surfaceId = param.surfaceId as string;
          this.vm.isLandscape = false
        }
      }
    })
    this.vm.isLandscape = true
    // 窗口旋转
    setOrientation(window.Orientation.USER_ROTATION_LANDSCAPE).then(() => {
      this.pathStack.pushPathByName('LandscapeVideo', param);
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 倍速
      PlayerSpeedRateView({
        leftRateOpacity: this.vm.leftRateOpacity,
        rightRateOpacity: this.vm.rightRateOpacity
      })
        .visibility(this.vm.isAccelerate ? Visibility.Visible : Visibility.None)

      Stack() {
        Stack({alignContent: Alignment.Bottom}) {
          Column() {
            Stack() {
              if (this.vm.isPause) {
                Image($r('app.media.ic_paused'))
                  .width(60)
                  .height(60)
                  .zIndex(2)
                  .onClick(() => {
                    this.vm.playOrPause()
                  });
              }

              XComponent({
                id: this.vm.xComponentId,
                type: XComponentType.SURFACE,
                controller: this.xComponentController
              })
                .width(this.vm.playerLayoutSize.getXComponentWidth())
                .height(this.vm.playerLayoutSize.getXComponentHeight())
                .onLoad(() => {
                  let surfaceId = this.xComponentController.getXComponentSurfaceId();
                  // 设置视频窗口ID
                  this.vm.setSurfaceId(surfaceId)
                  // 初始化
                  this.vm.initAVPlayer();
                })

              Column() {
                LoadingProgress()
                  .width(50)
                  .height(50)
                  .color(Color.White);
                Text('缓冲中...')
                  .fontSize(12)
                  .fontColor(Color.White)
              }
              .zIndex(2)
              .visibility(this.vm.isBuffering ? Visibility.Visible : Visibility.Hidden)

              if (this.vm.showCover) {
                if (this.videoData.getCoverUrl()) {
                  Image(this.videoData.getCoverUrl())
                    .width(this.vm.playerLayoutSize.getXComponentWidth())
                }
              }
            }
            .id(this.vm.componentId)
            .width(this.vm.playerLayoutSize.getPlayerWidth())
            .height(this.vm.playerLayoutSize.getPlayerHeight())
            .animation({ duration: 200 })
            .onSizeChange(() => {
              this.vm.adaptiveVideoSize()
            })
          }
          .width('100%')
          .height('100%')
          .padding({bottom: this.bottomTabHeight})

          // 自定义外层操作交互层
          if (this.videoLayerBuilder && !this.vm.isAccelerate) {
            Column() {
              this.videoLayerBuilder?.builder(
                this.videoData,
                this.vm.playerSession,
                this.swipePlayerController,
                this.vm.playerLayoutSize
              )
            }
            .zIndex(2)
            .width('100%')
            .height('100%')
          }
          // 没有设置外层操作层时，默认展示视频进度控制器
          if (!this.videoLayerBuilder && !this.vm.isAccelerate) {
            this.defaultVideoProgressBar()
          }
        }

        // 全屏播放按钮
        if (this.vm.showFullScreenBtn() && !this.vm.isAccelerate) {
          this.fullScreenBtnView()
        }
      }
    }
    .gesture(
      LongPressGesture({ repeat: true, duration: 300 })
        .onAction((event: GestureEvent) => {
          this.vm.onLongPress(event)
        })
        .onActionEnd(() => {
          this.vm.offLongPress()
        })
    )
  }

  @Builder
  fullScreenBtnView() {
    Column() {
      this.fullBtnBuilder()
    }
    .zIndex(4)
    .offset({top: Number(this.vm.playerLayoutSize.getXComponentHeight()) / 2})
    .visibility(this.vm.playerLayoutSize.getLayoutSizeChangeFlag() ? Visibility.Hidden : Visibility.Visible)
    .onClick(() => {
      let uiContext = this.getUIContext()
      let param: Record<string, Object | AVPlayerSession> = {};
      param.playerSession = this.vm.playerSession;
      param.surfaceId = this.vm.surfaceId;
      param.videoWidth = this.vm.videoWidth;
      param.videoHeight = this.vm.videoHeight;
      param.videoTitle = this.videoData.getVideoTitle();
      this.handleFullScreen(uiContext, param)
    })
  }

  @Builder
  defaultVideoProgressBar() {
    Column() {
      VideoProgressBar({
        playerSession: this.vm.playerSession,
      })
    }
    .zIndex(2)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
    .padding({bottom: Constants.BOTTOM_TAB_NAV_HEIGHT})
  }
}