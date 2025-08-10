import { media } from '@kit.MediaKit';
import { Battery } from '../components/Battery';
import { VideoProgressBar } from '../components/VideoProgressBar';
import { AVPlayerSession } from '../controller/AVPlayerManager';
import { Constants } from '../constants/Constants';
import { AnimationProperties } from '../customtransition/AnimationProperties';
import { RectInfoInPx } from '../customtransition/ComponentAttrUtils';
import { AVPlayerState } from '../type/Index';
import { CustomTransition } from '../customtransition/CustomNavigationUtils';
import { LandscapeVideoVM } from '../viewmodel/LandscapeVideoVM';
import { PlayerSpeedRateView } from '../components/PlayerSpeedRateView';

@Builder
export function LandscapeVideoBuilder() {
  LandscapeVideo()
}

@ComponentV2
export struct LandscapeVideo {
  xComponentController: XComponentController = new XComponentController();

  @Local animationProperties: AnimationProperties = new AnimationProperties(this.getUIContext());
  private pageId: number = -1;
  private prePageDoFinishTransition: () => void = () => {};
  private cardItemInfo: RectInfoInPx = new RectInfoInPx();

  vm: LandscapeVideoVM = new LandscapeVideoVM(this.getUIContext())

  aboutToAppear(): void {
    this.vm.init()
  }

  aboutToDisappear(): void {
    this.vm.disappear()
  }

  private onBackPressed(): boolean {
    this.vm.onBack()
    return true;
  }

  handleXComponentSize() {
    // 横屏页面，需要使用原来竖屏时的宽度当做高度
    let screenHeight = this.animationProperties.windowWidth
    const uiContext = this.getUIContext()
    this.vm.xComponentWidth = uiContext.px2vp(this.vm.videoWidth * screenHeight / this.vm.videoHeight);
    this.vm.xComponentHeight = uiContext.px2vp(screenHeight);
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        // 倍速
        PlayerSpeedRateView({
          leftRateOpacity: this.vm.leftRateOpacity,
          rightRateOpacity: this.vm.rightRateOpacity,
          offsetTop: 56
        })
          .visibility(this.vm.isAccelerate ? Visibility.Visible : Visibility.None)
          .zIndex(2)

        Stack({ alignContent: Alignment.Center }) {
          XComponent({
            id: 'xmComponent',
            type: XComponentType.SURFACE,
            controller: this.xComponentController
          })
          .width(this.vm.xComponentWidth)
          .height(this.vm.xComponentHeight)
          .onLoad(() => {
            const surfaceId = this.xComponentController.getXComponentSurfaceId();
            if (this.vm.player) {
              this.vm.player.surfaceId = surfaceId;
            }
            this.vm.player?.play()
          })

          // 视频外层
          RelativeContainer() {
            // 头部
            Column() {
              this.topRegionView()
            }
            .width('100%')
            .alignRules({
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
            })
            .visibility(this.vm.showBar ? Visibility.Visible : Visibility.Hidden)
            .animation({duration: 200})

            // 中心区域
            Column() {
              this.centerRegionView()
            }
            .width('100%')
            .height('calc(100% - 64vp - 82vp)')
            .alignRules({
              middle: { anchor: '__container__', align: HorizontalAlign.Center },
              center: { anchor: '__container__', align: VerticalAlign.Center }
            })

            // 底部进度条
            Column() {
              VideoProgressBar({
                playerSession: this.vm.playerSession,
                showProgressBarLeft: true,
                showProgressBarRight: true,
                selectedColor: Color.White,
                trackColor: $r('app.color.landscape_slide_track_color'),
                progressBarBuilder: () => {
                  this.bottomRegionView()
                },
                onSlideChange: (flag) => {
                  if (flag) {
                    this.vm.showBar = true
                    this.vm.showLock = true
                  } else {
                    this.vm.showOrHiddenBar()
                  }
                }
              })
            }
            .width(Constants.FULL_PERCENT)
            .position({bottom: Constants.BOTTOM_PADDING_HEIGHT - 10})
            .alignRules({
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start }
            })
            .visibility(this.vm.showBar && !this.vm.isLockScreen ? Visibility.Visible : Visibility.Hidden)
            .animation({duration: 200})

            // 页面锁住时，底部展示控制器
            Column() {
              // 视频的进度控制器
              VideoProgressBar({
                playerSession: this.vm.playerSession,
                canChangeSlide: false,
                isProgressFullWidth: true,
                showSlideBlock: false,
                selectedColor: Color.White,
                slideHeight: 14
              })
            }
            .visibility(this.vm.isLockScreen ? Visibility.Visible : Visibility.Hidden)
            .width(Constants.FULL_PERCENT)
            .padding({left:Constants.PADDING_L, right: Constants.PADDING_L})
            .alignRules({
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start }
            })
          }
          .width(Constants.FULL_PERCENT)
          .height(Constants.FULL_PERCENT)
        }
        .width(Constants.FULL_PERCENT)
        .height(Constants.FULL_PERCENT)
        .gesture(
          LongPressGesture({ repeat: true, duration: 300 })
            .onAction((event: GestureEvent) => {
              // 页面锁住时，不能进行操作
              if (!this.vm.isLockScreen) {
                this.vm.onLongPress(event)
              }
            })
            .onActionEnd(() => {
              // 页面锁住时，不能进行操作
              if (!this.vm.isLockScreen) {
                this.vm.offLongPress()
              }
            })
        )
      }
      .backgroundColor(Color.Black)
      .onClick(() => {
        this.vm.handleClickScreen()
      })
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.vm.pathStack = context.pathStack
      this.pageId = context.pathStack.getAllPathName().length - 1;
      let param = context.pathInfo?.param as Record<string, Object | AVPlayerSession>;
      this.vm.playerSession = (param.playerSession as AVPlayerSession)
      this.vm.player = (param.playerSession as AVPlayerSession).getAVPlayer() as media.AVPlayer;
      this.vm.videoWidth = param.videoWidth as number
      this.vm.videoHeight = param.videoHeight as number
      this.prePageDoFinishTransition = () => {}
      this.cardItemInfo = param.cardItemInfo as RectInfoInPx;
      this.vm.videoTitle = param.videoTitle as string

      this.handleXComponentSize()

      this.vm.playerSession?.onEvent('stateChange', (state: string) => {
        // 横屏时，播放完之后会重头播放，需要保持播放状态
        this.vm.isPlaying = state === AVPlayerState.PLAYING || state === AVPlayerState.COMPLETED
      });
      this.vm.playerSession?.onEvent('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
        if (infoType === media.BufferingInfoType.BUFFERING_START) {
          this.vm.isBuffering = true;
        }
        if (infoType === media.BufferingInfoType.BUFFERING_END) {
          this.vm.isBuffering = false
        }
      });

      CustomTransition.getInstance().registerNavParam(this.pageId,
        (isPush: boolean, isExit: boolean, transitionProxy: NavigationTransitionProxy) => {
          this.animationProperties.doAnimation(
            this.cardItemInfo, isPush, isExit, transitionProxy,
            this.prePageDoFinishTransition, undefined)
        }, 500);
    })
    // 返回后继续播放
    .onBackPressed(() => {
      return this.onBackPressed();
    })
    .onAppear(() => {
      this.vm.windowClass!.setSpecificSystemBarEnabled('navigationIndicator', false);
    })
    .onDisAppear(() => {
      CustomTransition.getInstance().unRegisterNavParam(this.pageId);
      this.vm.windowClass!.setSpecificSystemBarEnabled('navigationIndicator', true);
    })
  }

  @Builder
  topRegionView() {
    Stack({alignContent: Alignment.Center}) {
      Row()
        .width(Constants.FULL_PERCENT)
        .height(64)
        .linearGradient({
          angle: 180,
          colors: [[Color.Black, 0], [Color.Transparent, 1]]
        })

      Row() {
        Row() {
          Row() {
            Image($r('app.media.ic_left_arrow')).width(9).height(16)
          }
          .width(40)
          .height(40)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.vm.onBack()
          })
          // 标题
          Text(this.vm.videoTitle ?? '').fontSize(14)
            .fontColor(Color.White)
        }
        // 电池
        Battery()
      }
      .width(Constants.FULL_PERCENT)
      .padding({left: 16, right: 16})
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(Constants.FULL_PERCENT)
    .height(64)
  }

  @Builder
  centerRegionView() {
    RelativeContainer() {
      // 锁屏按钮
      this.lockScreenView()

      Stack() {
        Image(this.vm.isPlaying && !this.vm.isBuffering ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
          .width(50)
          .height(50)
          .visibility(this.vm.showBar && !this.vm.isBuffering ? Visibility.Visible : Visibility.Hidden)
          .animation({duration: 200})
          .onClick(() => {
            if (!this.vm.isBuffering) {
              this.vm.switchPlayOrPause()
            }
          })

        if (this.vm.isBuffering) {
          Column() {
            LoadingProgress()
              .width(50)
              .height(50)
              .color(Color.White);
            Text('缓冲中...')
              .fontSize(12)
              .fontColor(Color.White)
          }
        }
      }
      .width(60)
      .height(60)
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      })
    }
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
  }

  @Builder
  bottomRegionView() {
    Column() {
      Row() {
        Image(this.vm.isPlaying ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.vm.switchPlayOrPause()
          })

        Image($r('app.media.ic_exit_full_screen'))
          .width(18)
          .height(18)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.vm.onBack()
          })
      }
      .width(Constants.FULL_PERCENT)
      .padding({left: Constants.PADDING_PAGE, right: Constants.PADDING_PAGE})
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .padding({bottom: Constants.BOTTOM_PADDING_HEIGHT})
  }

  @Builder
  lockScreenView() {
    Stack() {
      Row()
        .width(50)
        .height(50)
        .borderRadius('50%')
        .backgroundColor(Color.Black)
        .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
      Image(this.vm.isLockScreen ? $r('app.media.ic_lock') : $r('app.media.ic_unlock'))
        .width(30)
        .height(30)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          this.vm.lockScreen()
        })
    }
    .offset({left: 56})
    .alignRules({
      left: { anchor: '__container__', align: HorizontalAlign.Start },
      center: { anchor: '__container__', align: VerticalAlign.Center }
    })
    .visibility(this.vm.showLock ? Visibility.Visible : Visibility.Hidden)
    .animation({duration: 200})
  }
}