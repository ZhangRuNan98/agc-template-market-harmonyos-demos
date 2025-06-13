import { window } from '@kit.ArkUI';

@ComponentV2
export struct Banner {
  @Local avoidAreaTop: number = 0

  async aboutToAppear() {
    const mainWindow = await window.getLastWindow(getContext());
    const avoidAreaType = window.AvoidAreaType.TYPE_SYSTEM; // 系统默认区域，包括状态栏，导航栏
    const avoidArea = mainWindow.getWindowAvoidArea(avoidAreaType);
    const height = avoidArea.topRect.height;
    this.avoidAreaTop = px2vp(height)
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.ic_vip_banner'))
        .height(325)
        .width('100%')
        .draggable(false)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
      Column() {
        Row() {
          Image($r('app.media.ic_money'))
            .width(16)
            .height(16)
            .margin({ right: 4 })
          Text() {
            Span('积分余额')
              .fontSize(16)
            Span('35')
              .fontSize(24)
          }
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
        }
        .width('100%')
        .margin({ bottom: 12 })

        Row() {
          Row() {
            Text('今日积分已领取，每100积分可抵扣快递费5元')
              .fontSize(12)
              .fontWeight(FontWeight.Regular)
              .fontColor(Color.White)
          }
          .width('100%')
        }
        .width('100%')
      }
      .margin({ top: 109, left: 16, right: 16 })
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}