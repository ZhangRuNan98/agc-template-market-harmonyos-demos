import { media } from '@kit.MediaKit';
import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Constants } from '../constants/Constants'
import { AVPlayerSession } from '../controller/AVPlayerManager';
import { pauseVideo, playVideo, setOrientation } from '../utils/Util';

@ObservedV2
export class LandscapeVideoVM {
  player: media.AVPlayer | undefined;
  @Trace xComponentWidth: Length = Constants.FULL_PERCENT;
  @Trace xComponentHeight: Length = Constants.FULL_PERCENT;
  @Trace videoWidth: number = Constants.SURFACE_WIDTH;
  @Trace videoHeight: number = Constants.SURFACE_HEIGHT;
  // 当前跳转过来的路由栈
  @Trace pathStack: NavPathStack = new NavPathStack()
  // 当前视频的标题
  @Trace videoTitle: string = ''
  // 当前视频播放会话
  @Trace playerSession: AVPlayerSession | undefined = undefined;
  // 定时隐藏
  @Trace showBar: boolean = true
  @Trace time: number = 0
  // 是否锁屏
  @Trace showLock: boolean = true
  @Trace isLockScreen: boolean = false
  // 返回标识
  @Trace isBackFlag: boolean = false
  // 是否播放
  @Trace isPlaying: boolean = true;
  // 是否缓存
  @Trace isBuffering: boolean = false;
  @Trace trackThicknessSize: number = Constants.TRACK_SIZE_MIN;
  // 倍速
  @Trace isAccelerate: boolean = false;
  @Trace leftRateOpacity: number = 0;
  @Trace rightRateOpacity: number = 1;

  uiContext?: UIContext
  windowClass?: window.Window
  constructor(uiContext: UIContext) {
    this.uiContext = uiContext
    const context: common.UIAbilityContext = uiContext.getHostContext() as common.UIAbilityContext
    this.windowClass = context.windowStage!.getMainWindowSync();
  }

  init() {
    this.windowClass?.on('windowSizeChange', (size) => {
      if (!this.isBackFlag && size.width < size.height &&
        this.pathStack.getAllPathName().includes('LandscapeVideo')
      ) {
        this.pathStack.pop();
        setOrientation(window.Orientation.PORTRAIT)
      }
    })
    this.showOrHiddenBar()
  }

  disappear() {
    this.windowClass!.off('windowSizeChange')
  }

  onBack() {
    this.isBackFlag = true;
    // 设置横竖屏
    setOrientation(window.Orientation.PORTRAIT).then(() => {
      this.pathStack.pop();
    })
  }

  showOrHiddenBar() {
    if (this.showBar || this.showLock) {
      clearTimeout(this.time)
      this.time = setTimeout(() => {
        this.showBar = false
        this.showLock = false
      }, 4000)
    } else {
      this.time && clearTimeout(this.time)
    }
  }

  lockScreen() {
    this.isLockScreen = !this.isLockScreen
    if (this.isLockScreen) {
      this.showBar = false
      this.showOrHiddenBar()
    } else {
      this.showBar = true
      if (this.isPlaying) {
        this.showOrHiddenBar()
      } else {
        this.time && clearTimeout(this.time)
      }
    }
  }

  switchPlayOrPause() {
    if (this.isPlaying) {
      pauseVideo(this.player);
      this.isPlaying = false;
      this.trackThicknessSize = Constants.TRACK_SIZE_MAX;
    } else {
      playVideo(this.player);
      this.isPlaying = true;
      this.trackThicknessSize = Constants.TRACK_SIZE_MIN;
    }
    this.windowClass?.setWindowKeepScreenOn(true);
    // 处理视频外层的显示和隐藏
    if (this.isPlaying) {
      this.showOrHiddenBar()
    } else {
      this.showBar = true
      if (this.time) {
        clearTimeout(this.time)
      }
    }
  }

  handleClickScreen() {
    this.showBar = this.isLockScreen ? false : !this.showBar
    this.showLock = !this.showLock
    if (this.isPlaying) {
      this.showOrHiddenBar()
    }
  }

  // 长按加速
  onLongPress(event: GestureEvent) {
    if (this.playerSession?.avPlayer?.state === 'playing') {
      // 快进图标显隐变化
      this.leftRateOpacity = 1;
      this.rightRateOpacity = 0;
      if (event?.repeat) {
        this.isAccelerate = true;
        this.playerSession.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X)
      }
    }
  }
  // 取消长按
  offLongPress() {
    if (this.playerSession?.avPlayer?.state === 'playing') {
      this.isAccelerate = false;
      this.playerSession.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X)
    }
  }
}