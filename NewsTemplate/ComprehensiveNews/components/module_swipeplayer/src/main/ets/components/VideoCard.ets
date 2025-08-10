import { media } from '@kit.MediaKit'
import { AVPlayerState, VideoPlayerData } from '../type/Index'
import { secondToTime, toast } from '../utils/Util'
import { Constants } from '../constants/Constants'
import { VideoProgressBar } from './VideoProgressBar'
import { AVPlayerSession } from '../controller/AVPlayerManager'
import { VideoCardModel } from '../viewmodel/VideoCardModel'
import { VideoNetworkModel, VideoNetworkSetting } from '../models/VideoNetworkModel'

@ComponentV2({freezeWhenInactive: true})
export struct VideoCard {
  // 列表视频信息
  @Param @Require videoData: VideoPlayerData
  // List显示区域内中间子组件索引值
  @Param currentIndex: number = 0
  // 列表视频的索引
  @Param index: number = 0;
  // 组件所在页面是否显示
  @Param isShown: boolean = false
  // 网络
  @Param videoNetwork: VideoNetworkModel | undefined = undefined
  @Param videoNetworkSetting: VideoNetworkSetting | undefined = undefined
  // 视频信息view
  @BuilderParam videoInfoViewBuilder: CustomBuilder;
  // 点击title，回调事件
  @Event onClickEvent: (playerSession: AVPlayerSession | undefined, callback: () => void) => void;
  // 播放list某个item的视频
  @Event onPlayItem: (playIndex: number) => void
  // 在移动网络下点击播放按钮，默认为是同意使用流量播放
  @Event setUseMobileData: () => void
  // 播放状态回调
  @Event playerStateCallback: (state: string, id: string) => void = (state: string, id: string) => {}
  // XComponent控制器
  private xComponentController: XComponentController = new XComponentController();

  vm: VideoCardModel = new VideoCardModel(this.getUIContext(), this.index)

  // 准备状态监听事件
  private preparedListener = () => {
    // 自动播放开关打开，才会播放
    if (this.index === this.currentIndex && this.isShown &&
      this.videoNetworkSetting?.autoPlayTabRecommend
    ) {
      this.vm.playerSession.play()
    }
  }
  // 播放状态监听
  private playingListener = () => {
    if (this.index === this.currentIndex && this.videoNetwork) {
      this.videoNetwork.canUseMobileData = true;
      // 播放状态回调
      this.playerStateCallback && this.playerStateCallback(AVPlayerState.PLAYING, this.videoData.getVideoId())
    }
  }
  // 播放完成状态监听事件
  private completedListeners = () => {
    // 设置自动播放下一个，且推荐视频自动播放开关打开，则当前视频播放完之后，继续播放下一个
    if (this.videoNetworkSetting?.autoPlayNext && this.videoNetworkSetting?.autoPlayTabRecommend) {
      this.vm.isPause = true;
      this.vm.playerSession.avPlayer!.seek(0, media.SeekMode.SEEK_CLOSEST);
      this.onPlayItem?.(this.currentIndex + 1)
      this.vm.avPlayerManager.getAVPlayer(this.currentIndex + 1)?.play()
      return
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
        if (this.videoNetworkSetting?.autoPlayTabRecommend) {
          this.vm.isPause = false;
        }
        this.vm.isBuffering = true;
      }
      if (infoType === media.BufferingInfoType.BUFFERING_END) {
        this.vm.isBuffering = false;
        if (!this.isShown) {
          this.vm.playerSession.pause();
        }
      }
    }
  }

  @Monitor('currentIndex')
  onIndexChanged() {
    this.onChangeListIndex();
  }

  @Monitor('videoNetwork.isCellular')
  onCellularChange(monitor: IMonitor) {
    let isCellular = monitor.value()?.now as boolean
    if (this.currentIndex === this.index) {
      if (isCellular && !this.videoNetwork?.hasUseMobileDataTip) {
        toast(this.getUIContext(), {
          message: '正在使用流量播放',
          alignment: Alignment.Center,
        })
        if (this.videoNetwork) {
          this.videoNetwork.hasUseMobileDataTip = true
        }
        return
      }
      if (this.videoNetwork && this.videoNetwork.hasNet) {
        this.vm.playerSession.getAVPlayer()?.play()
      }
    }
  }

  @Monitor('videoNetwork.hasNet')
  onNetworkChange(monitor: IMonitor) {
    let hasNet = monitor.value()?.now as boolean;
    let playerState = this.vm.playerSession.avPlayer?.state
    if (this.currentIndex === this.index && playerState === 'idle' && hasNet) {
      this.vm.playerSession.avPlayer!.url = this.videoData.getVideoUrl()
    }
  }

  @Computed
  get durationStringTime() {
    const durationTime = Math.floor(this.videoData.getVideoDuration() / 1000)
    return secondToTime(durationTime);
  }

  aboutToAppear() {
    this.vm.initPlayerManager(this.videoData)
    this.vm.initXComponentId()
    // 准备状态监听事件
    this.vm.onPreparedListener(this.preparedListener);
    // 视频播放状态监听事件
    this.vm.onPlayingListener(this.playingListener)
    // 完成状态监听事件
    this.vm.onCompletionListener(this.completedListeners);
    // 播放错误状态监听事件
    this.vm.onErrorListener(this.errorListener)
    // 缓存事件监听
    this.vm.onBuffingUpdateListener(this.buffingUpdateListener)
    // 监听首帧事件
    this.vm.onStartRenderFrameListener(() => {
      if (this.index === this.currentIndex) {
        this.vm.showCover = false;
      }
    })
    // 视频尺寸变化监听
    this.vm.onVideoSizeChangedListener(() => {
      this.vm.adaptiveVideoSize()
    })

    // 网络是否可用
    this.handlerNetwork()
    this.vm.videoNetwork = this.videoNetwork
  }

  aboutToDisappear(): void {
    this.vm.handlerDisappear()
  }

  // 处理无网络情况
  handlerNetwork() {
    // 无网络且没有提示过，则提示
    if (this.videoNetwork && !this.videoNetwork.hasNet && !this.videoNetwork.hasOfflineTip) {
      toast(this.vm.uiContext!, {
        message: '网络连接不可用',
        alignment: Alignment.Center,
        textColor: Color.Red
      })
      this.videoNetwork.hasOfflineTip = true
    }
  }

  onChangeListIndex() {
    // 当前是移动流量，且不允许使用移动流量播放
    let disabledPlay = this.videoNetwork && this.videoNetwork.isCellular && !this.videoNetwork.canUseMobileData
    if (this.index !== this.currentIndex || disabledPlay) {
      this.vm.isPause = true;
      this.vm.playerSession.pause();
      return;
    }
    this.vm.isPause = false;
    if (this.vm.playerSession.getAVPlayer()) {
      let canPlayStates = [
        AVPlayerState.PREPARED,
        AVPlayerState.PAUSED,
        AVPlayerState.COMPLETED
      ] as media.AVPlayerState[]
      if (canPlayStates.includes(this.vm.playerSession.avPlayer?.state!)) {
        this.vm.playerSession.avPlayer?.setSpeed(1);
        this.vm.playerSession.play();
        return
      }
      // 有网络
      if (this.videoNetwork?.hasNet) {
        this.vm.playerSession.avPlayer!.url = this.videoData.getVideoUrl();
      }
    }
  }

  // 视频播放
  async onClickVideo() {
    if (this.vm.isPause && this.videoNetwork && !this.videoNetwork.hasNet) {
      toast(this.getUIContext(), {
        message: '网络连接不可用',
        alignment: Alignment.Center,
      })
      return;
    }
    if (this.vm.isPause && this.videoNetwork?.hasNet) {
      this.vm.avPlayerManager.getAVPlayer(this.currentIndex)?.pause();
      this.onPlayItem?.(this.index);

      if (this.vm.playerSession.getAVPlayer()) {
        let playerState = this.vm.playerSession.avPlayer!.state;
        // idle状态
        if (playerState === AVPlayerState.IDLE) {
          this.vm.playerSession.avPlayer!.url = this.videoData.getVideoUrl();
          return;
        }
        await this.vm.playerSession.play()
      } else {
        await this.vm.initAVPlayer();
      }
    }
  }
  // 跳转详情页
  pushToVideoDetailPage() {
    let avPlayer = this.vm.playerSession?.avPlayer;
    let callback = () => {
      if (this.index === this.currentIndex) {
        avPlayer!.surfaceId = this.vm.surfaceId;
        this.vm.playerSession!.avPlayer = avPlayer
        this.vm.showCover = false;
        this.vm.playerSession?.play();
        this.vm.onCompletionListener(this.completedListeners);
        this.vm.initPlayerListener(this.vm.playerSession.avPlayer!)
      }
    }
    this.onClickEvent?.(this.vm.playerSession, callback)
  }
  // 处理点击卡片title
  async handleClickItemCard() {
    await this.onClickVideo()
    this.pushToVideoDetailPage()
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
          if (this.vm.isPause) {
            Image($r('app.media.ic_paused'))
              .width(44)
              .height(44)
          }
        }
        .width(this.vm.xComponentWidth)
        .height(this.vm.xComponentHeight)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .zIndex(3)
        .onClick(() => {
          let playerState = this.vm.playerSession.avPlayer!.state;
          if (playerState === AVPlayerState.PLAYING) {
            this.pushToVideoDetailPage()
          } else {
            this.onClickVideo()
          }
        })
        Stack({alignContent: Alignment.Bottom}) {
          // 视频播放
          XComponent({
            id: this.vm.xComponentId,
            type: XComponentType.SURFACE,
            controller: this.xComponentController
          })
            .width(this.vm.xComponentWidth)
            .height(this.vm.xComponentHeight)
            .onLoad(() => {
              let surfaceId = this.xComponentController.getXComponentSurfaceId();
              // 设置视频窗口ID
              this.vm.setSurfaceId(surfaceId)
              // 初始化
              this.vm.initAVPlayer();
            })

          Column() {
            // 视频的进度控制器
            VideoProgressBar({
              playerSession: this.vm.playerSession,
              canChangeSlide: false,
              isProgressFullWidth: true,
              showSlideBlock: false,
              selectedColor: $r('app.color.slide_selected_color'),
              slideHeight: 14
            })
          }
          .visibility(this.index === this.currentIndex ? Visibility.Visible : Visibility.Hidden)
          .width(Constants.FULL_PERCENT)

          // 封面
          Stack({alignContent: Alignment.BottomEnd}) {
            if (this.vm.showCover && this.videoData.getCoverUrl()) {
              Image(this.videoData.getCoverUrl())
                .width(Constants.FULL_PERCENT)
                .onAreaChange((ov: Area, nv: Area) => {
                  this.vm.coverImgHeight = nv.height
                })
            }

            Text(this.durationStringTime)
              .fontSize(10)
              .fontColor($r('sys.color.white'))
              .padding(4)
              .borderRadius(4)
              .backgroundColor($r('app.color.color_black_40'))
              .offset({bottom: 8, right: 12})
              .visibility(this.vm.isPause ? Visibility.Visible : Visibility.Hidden)
          }
          .width(Constants.FULL_PERCENT)
        }
        // 缓冲中
        if (this.vm.isBuffering && this.index === this.currentIndex) {
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
        }

        // 流量提示
        if (this.currentIndex === this.index && this.videoNetwork &&
          this.videoNetwork.isCellular && !this.videoNetwork.canUseMobileData
        ) {
          Column({space: Constants.SPACE_M}) {
            Row({space: Constants.SPACE_S}) {
              Image($r('app.media.ic_playback')).width(12).height(13)
              Text('继续播放')
                .fontSize(14)
                .fontColor(Color.White)
                .lineHeight(20)
            }
            .padding({left: 10, right: 10, top: 4, bottom: 4})
            .borderRadius(20)
            .backgroundColor('#1b1a1b')
            .onClick(() => {
              this.setUseMobileData && this.setUseMobileData()
              this.vm.playVideoWithMobileData()
            })

            Text('当前非Wi-Fi网络，继续播放将产生流量费用')
              .fontSize(14)
              .fontColor(Color.White)
              .lineHeight(20)
          }
          .width(Constants.FULL_PERCENT)
          .height(this.vm.coverImgHeight)
          .backgroundColor(Color.Black)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .zIndex(4)
        }
      }
      .width(Constants.FULL_PERCENT)

      // 视频信息view
      if (this.videoInfoViewBuilder) {
        Row() {
          this.videoInfoViewBuilder()
        }
        .onClick(() => {
          this.handleClickItemCard()
        })
      }
    }
    .width(Constants.FULL_PERCENT)
  }
}