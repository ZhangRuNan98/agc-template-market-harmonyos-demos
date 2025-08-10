import { Constants } from '../constants/Constants';
import { AVPlayerSession } from '../controller/AVPlayerManager';
import { AVPlayerState } from '../type/Index';
import { Logger } from '../utils/Logger';
import { playVideo, setSeek } from '../utils/Util';
import { secondToTime } from '../utils/Util';

const TAG = '[VideoProgressBar]'

@ComponentV2
export struct VideoProgressBar {
  // 视频播放会话
  @Param @Require playerSession: AVPlayerSession;
  // 进度条回调事件
  @Event onSlideChange: (sliderFlag: boolean) => void = (sliderFlag: boolean) => {};
  // 进度条左边区域
  @Param showProgressBarLeft: boolean = false;
  // 进度条左边区域
  @Param showProgressBarRight: boolean = false;
  // 进度条底部
  @BuilderParam progressBarBuilder: CustomBuilder;
  // 能否拖动进度条
  @Param canChangeSlide: boolean = true;
  // 进度条是否占满全屏宽度
  @Param isProgressFullWidth: boolean = false;
  // 进度条的高度
  @Param slideHeight: Length = 20;
  // 是否显示进度条滑块
  @Param showSlideBlock: boolean = true
  // 进度条已滑动部分颜色
  @Param selectedColor: ResourceColor = $r('app.color.slide_default_selected_color');
  // 进度条颜色
  @Param trackColor: ResourceColor = $r('app.color.slide_default_track_color')
  @Local currentTime: number = 0;
  @Local durationTime: number = 0;
  @Local durationStringTime: string = '00:00';
  @Local currentStringTime: string = '00:00';
  @Local isTimeDisplay: boolean = false;
  @Local trackThicknessSize: number = Constants.TRACK_SIZE_MIN;
  @Local isPlaying: boolean = true;
  private duration: number = 0;
  private isSliderMoving: boolean = false;

  aboutToAppear(): void {
    let avPlayer = this.playerSession.getAVPlayer();
    if (avPlayer) {
      this.duration = avPlayer.duration;
      this.durationTime = this.duration / 1000
      this.durationStringTime = secondToTime(Math.floor(this.duration / 1000));
      Logger.info(TAG, 'player duration is ' + this.duration)
    }

    this.playerSession?.onEvent('stateChange', (state: string) => {
      let avPlayer = this.playerSession.getAVPlayer();
      Logger.info(TAG, 'avPlayer state is ' + state)
      if (avPlayer && avPlayer.duration > 0) {
        this.duration = avPlayer.duration;
        this.durationTime = this.duration / 1000
        this.durationStringTime = secondToTime(Math.floor(this.duration / 1000));
      }
      Logger.info(TAG, 'stateChange player durationTime is ' + this.durationTime)

      // 是否播放
      this.isPlaying = state === AVPlayerState.PLAYING || state === AVPlayerState.COMPLETED;
      // 暂停状态
      if (state === AVPlayerState.PAUSED) {
        this.trackThicknessSize = Constants.TRACK_SIZE_MAX;
      } else {
        this.trackThicknessSize = Constants.TRACK_SIZE_MIN;
      }
    });

    this.playerSession?.onEvent('timeUpdate', (time: number) => {
      if (!this.isSliderMoving) {
        this.currentTime = time / 1000;
        this.currentStringTime = secondToTime(Math.floor(time / 1000));
      }
    });
  }

  sliderOnChange(value: number, mode: SliderChangeMode) {
    let avPlayer = this.playerSession.getAVPlayer();
    if (!avPlayer) {
      return
    }

    this.currentTime = value;
    let seekTime: number = value * 1000;
    if (mode === SliderChangeMode.Moving) {
      this.isTimeDisplay = true;
      this.trackThicknessSize = Constants.TRACK_SIZE_MAX;
      this.currentStringTime = secondToTime(Math.floor(seekTime / 1000));
      this.isSliderMoving = true;
    }
    if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
      this.currentStringTime = secondToTime(Math.floor(seekTime / 1000));
      setSeek(avPlayer, seekTime);
      this.isTimeDisplay = false;
      this.trackThicknessSize = Constants.TRACK_SIZE_MIN;
      this.isSliderMoving = false;
      if (!this.isPlaying) {
        let avPlayer = this.playerSession.getAVPlayer()
        playVideo(avPlayer)
      }
    }
    this.onSlideChange && this.onSlideChange(this.isSliderMoving);
  }

  build() {
    Stack({alignContent: Alignment.Bottom}) {
      Row({space: 16}) {
        Text(this.currentStringTime)
          .fontSize(20)
          .fontColor(Color.White)
          .textAlign(TextAlign.End)
          .zIndex(3)

        Divider()
          .vertical(true)
          .height(18)
          .strokeWidth(2)
          .color(Color.White)
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            centerX: '50%',
            centerY: '50%',
            angle: 26
          })

        Text(this.durationStringTime)
          .fontSize(20)
          .fontColor(Color.White)
          .textAlign(TextAlign.Start)
          .opacity(0.5)
          .zIndex(3)
      }
      .width(Constants.FULL_PERCENT)
      .visibility(this.isTimeDisplay ? Visibility.Visible : Visibility.Hidden)
      .justifyContent(FlexAlign.Center)
      .offset({bottom: 120})

      Column() {
        Row({space: 8}) {
          if (this.showProgressBarLeft) {
            Text(this.currentStringTime)
              .fontSize(10)
              .fontColor(Color.White)
              .textAlign(TextAlign.Start)
              .lineHeight(13)
          }

          Slider({
            value: this.currentTime,
            step: 0.1,
            min: 0,
            max: this.durationTime,
            style: this.showSlideBlock ? SliderStyle.OutSet : SliderStyle.NONE
          })
            .layoutWeight(1)
            .height(this.slideHeight)
            .enabled(this.canChangeSlide)
            .blockSize({
              width: this.showSlideBlock ? 4 + (this.trackThicknessSize) : 0,
              height: this.showSlideBlock ? 4 + (this.trackThicknessSize) : 0
            })
            .blockColor(this.isTimeDisplay || !this.isPlaying ? '#ffffff' : this.selectedColor)
            .trackColor(this.trackColor)
            .selectedColor(this.isTimeDisplay || !this.isPlaying ? '#ffffff' : this.selectedColor)
            .showSteps(false)
            .showTips(false)
            .trackThickness(this.trackThicknessSize)
            .trackBorderRadius(2)
            .offset(!this.showSlideBlock ? {top: 6} : null)
            .zIndex(3)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.sliderOnChange(value, mode);
            })

          if (this.showProgressBarRight) {
            Text(this.durationStringTime)
              .fontSize(10)
              .fontColor(Color.White)
              .textAlign(TextAlign.End)
              .lineHeight(13)
          }
        }
        .width(Constants.FULL_PERCENT)
        .padding(this.isProgressFullWidth ? null :
          {left: Constants.PADDING_PAGE, right: Constants.PADDING_PAGE}
        )
        .justifyContent(FlexAlign.SpaceBetween)

        if (this.progressBarBuilder) {
          this.progressBarBuilder()
        }
      }
      .width('100%')
    }
  }
}