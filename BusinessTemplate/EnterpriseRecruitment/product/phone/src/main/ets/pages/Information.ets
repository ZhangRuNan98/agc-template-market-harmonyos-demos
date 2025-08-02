import { AvoidArea, BreakPointController, SwiperComponent, TitleBar, TopBar } from '@ohos_agcit/common_component';
import { AboutUs } from '../information/AboutUs';
import { Introductions } from '../information/Introductions';
import { AppStorageV2 } from '@kit.ArkUI';

@Entry
@ComponentV2
export struct Information {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  private breakPointController: BreakPointController = BreakPointController.instance;

  @Builder
  tabBuilder(tabName: string | Resource, tabIndex: number) {
    Row() {
      Text(tabName)
        .fontSize($r('app.float.font_size_15'))
        .fontColor(tabIndex === this.currentIndex ? Color.White : '#E6000000')
        .id(tabIndex.toString())
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(tabIndex === this.currentIndex ? $r('app.color.common_blue') :
    $r('app.color.button_gray'))
    .borderRadius(21)
    .width(this.breakPointController.informationBarWidth)
    .height(36)
    .margin({
      left: tabIndex === 0 ? 0 : 8,
      right: tabIndex === 0 ? 8 : 0
    })
    .onClick(() => {
      this.controller.changeIndex(tabIndex);
      this.listScroller.scrollToIndex(tabIndex, true, ScrollAlign.CENTER);
    })
  }

  @Local currentIndex: number = 0
  private controller: TabsController = new TabsController();
  private listScroller: Scroller = new Scroller();

  build() {
    Column() {
      TopBar({ text: $r('app.string.information') })
        .width('100%')
        .height(56)
        .alignSelf(ItemAlign.Start)
        .margin({bottom: 10})

      Scroll() {
        Column() {
          Row() {
            SwiperComponent()
          }
          .height(200)
          .width('100%')

          Tabs({ barPosition: BarPosition.End, controller: this.controller, index: this.currentIndex }) {
            TabContent() {
              AboutUs()
            }
            .tabBar(this.tabBuilder($r('app.string.information_aboutUs'), 0))

            TabContent() {
              Introductions()
            }
            .tabBar(this.tabBuilder($r('app.string.information_hobbies'), 1))
          }
          .scrollable(false)
          .vertical(false)
          .barMode(BarMode.Scrollable)
          .barWidth('100%')
          .barHeight(72)
          .barPosition(BarPosition.Start)
          .animationDuration(0)
          .onChange((index: number) => {
            this.currentIndex = index
          })
          .height('auto')
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .height('90%')
      .width('100%')
    }
    .backgroundColor($r('app.color.common_background'))
    .padding({
      top: px2vp(this.avoidArea.topRectHeight),
      left: '4%',
      right: '4%'
    })
    .width('100%')
    .height('100%')
  }
}
