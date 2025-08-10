import { media } from '@kit.MediaKit';
import { display } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import { Constants } from '../constants/Constants';
import { VideoPlayerData } from '../type/Index';
import { VideoPlayerModel } from './VideoPlayerModel';
import { VideoNetworkModel } from '../models/VideoNetworkModel';

@ObservedV2
export class VideoCardModel extends VideoPlayerModel {
  // 封面图的高度
  @Trace coverImgHeight: Length = Constants.VIDEO_CARD_HEIGHT;
  @Trace isPause: boolean = true;
  videoNetwork?: VideoNetworkModel
  xComponentId: string = ''

  initPlayerManager(data: VideoPlayerData) {
    // 设置视频数据
    this.setVideoData(data);
    this.playerId = 'player_' + data.getVideoId() + util.generateRandomUUID();
    this.avPlayerManager.setPlayerId(this.index, this.playerId);
    this.avPlayerManager.setSession(this.playerId, this.playerSession!);
  }

  async initAVPlayer() {
    // 创建播放器
    const avPlayer = await media.createAVPlayer();
    if (avPlayer) {
      this.playerSession.setAVPlayer(avPlayer);
      // 设置视频url
      if (this.videoNetwork?.isWiFi || (this.videoNetwork?.isCellular && this.videoNetwork?.canUseMobileData)) {
        this.setDataSource()
      }
      // 初始化监听事件
      this.initPlayerListener(avPlayer)
    }
  }

  // 计算尺寸
  adaptiveVideoSize() {
    let radio = Number(this.videoWidth) / Number(this.videoHeight);
    let screenWidth = display.getDefaultDisplaySync().width;
    this.xComponentHeight = this.uiContext!.px2vp(screenWidth / radio);
  }

  initXComponentId() {
    this.xComponentId = 'XComponentId' + this.playerId;
  }

  // 使用移动流量播放
  playVideoWithMobileData() {
    let player = this.playerSession.getAVPlayer()
    if (player) {
      if (player.state === 'idle') {
        this.setDataSource()
      } else {
        this.playerSession.getAVPlayer()?.play()
      }
    } else {
      this.initAVPlayer();
    }
  }
}