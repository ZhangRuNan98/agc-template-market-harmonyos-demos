import { MockService } from 'external_interactions';
import { TitleBar } from 'uicomponents';
import { window } from '@kit.ArkUI';

@Component
export struct ClubEnvironmentDetail {
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;
  @Prop pathStack: NavPathStack;
  controller: VideoController = new VideoController()

  @Builder
  videoBuilder() {
    Column() {
      Video({
        src: $r('app.media.club'),
        previewUri: $r('app.media.material9'),
        controller: this.controller,
        currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X
      })
        .width('100%')
        .height(148)
        .borderRadius(8)
        .margin({ bottom: 5 })
        .onFullscreenChange((event) => {
          // 改变设备横竖屏状态
          window.getLastWindow(getContext(this)).then((lastWindow) => {
            lastWindow.setPreferredOrientation(event.fullscreen ? window.Orientation.LANDSCAPE :
            window.Orientation.PORTRAIT)
          });
        })
      Text('力健健身房配备齐全的器械设备，其中包括力量训练器械、有氧运动器械、功能性训练器械以及高科技健身设备等，满足不同健身需求。')
        .fontSize(10)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ bottom: 15 })
    .padding(16)
  }

  @Builder
  swiperBuilder() {
    Column() {
      Swiper() {
        ForEach(MockService.homeSwiperImageList, (item: string) => {
          Image($r(item))
            .width('100%')
            .height('100%')
        }, (item: string) => item)
      }
      .width('100%')
      .height(148)
      .borderRadius(8)
      .margin({ bottom: 5 })
      .curve(Curve.Smooth)

      Text('力量训练；适当的力量训练，可以增强身体肌肉含量，保证身体足够蛋白质，提高免疫力，我们的力量区有优秀的教练，专业的器材。')
        .fontSize(10)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ bottom: 15 })
    .padding(16)
  }

  @Builder
  imageBuilder(imageStr: string, text: string) {
    Column() {
      Image($r(imageStr))
        .width('100%')
        .height(148)
        .borderRadius(8)
        .margin({ bottom: 5 })
      Text(text)
        .fontSize(10)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ bottom: 15 })
    .padding(16)
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: '俱乐部环境', pathStack: this.pathStack })
          .margin({ left: 16, right: 16 })
        Scroll() {
          Column() {
            this.videoBuilder()
            this.imageBuilder('app.media.material1',
              '有氧训练；专业的有氧训练器材，宽敞的有氧训练场地，可以让你安全放松的完成一场有益身心的有氧训练。')
            this.swiperBuilder()
            this.imageBuilder('app.media.material8',
              '力量训练；适当的力量训练，可以增强身体肌肉含量，保证身体足够蛋白质，提高免疫力，我们的力量区有优秀的教练，专业的器材。')
          }
        }
        .margin({ left: 16, right: 16 })
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }.height('100%')
    }
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx?.pathStack
    })
    .hideTitleBar(true)
    .backgroundColor($r('app.color.main_background_color'))
    .padding({ top: px2vp(this.topRectHeight), bottom: px2vp(this.bottomRectHeight) })
  }
}