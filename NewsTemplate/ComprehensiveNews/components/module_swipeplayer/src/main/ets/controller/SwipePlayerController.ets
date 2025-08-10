import { media } from '@kit.MediaKit';
import { AVPlayerManager } from './AVPlayerManager';

export class SwipePlayerController {
  private avPlayerMgr?: AVPlayerManager;
  public curentIndex: number = 0;
  private swiperController?: SwiperController;

  public getCurrentPlayerSession() {
    return this.avPlayerMgr?.getSession(this.curentIndex)
  }

  public setAVPlayerMgr(object: Object) {
    this.avPlayerMgr = object as AVPlayerManager;
  }

  public getAVPlayerMgr(): AVPlayerManager | undefined {
    return this.avPlayerMgr
  }

  public setSwiperController(swiperController: SwiperController) {
    this.swiperController = swiperController
  }

  public getAVPlayer() {
    return this.avPlayerMgr?.getAVPlayer(this.curentIndex);
  }

  public async play() {
    await this.avPlayerMgr?.play(this.curentIndex);
  }

  public async pause() {
    await this.avPlayerMgr?.pause(this.curentIndex);
  }

  public async release() {
    await this.avPlayerMgr?.release(this.curentIndex);
  }

  public seek(timeMs: number) {
    this.avPlayerMgr?.seek(this.curentIndex, timeMs);
  }

  public setSpeed(speed: media.PlaybackSpeed) {
    this.avPlayerMgr?.setSpeed(this.curentIndex, speed);
  }

  // 播放指定索引的视频
  public changeIndex(index: number, useAnimation: boolean = true) {
    this.swiperController?.changeIndex(index, useAnimation)
  }
}