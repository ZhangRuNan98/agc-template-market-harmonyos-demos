import { Constant, RouterModule, TabBarModule } from 'foundation';
import { TABS_INFO } from '../constant/Constant';

@Entry
@ComponentV2
struct Index {
  @Local homeTabIndex: number = 0;

  @Builder
  mainTabBar(title: ResourceStr, targetIndex: number, selectedImg: ResourceStr, normalImg: ResourceStr) {
    Column({ space: 4 }) {
      Image(this.homeTabIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 24 });
      Text(title)
        .fontSize(10)
        .fontColor(this.homeTabIndex === targetIndex ? '#64BB5C' :
        Color.Black)
        .opacity(this.homeTabIndex === targetIndex ? 1 : 0.6);
    }.onClick(() => {
      this.homeTabIndex = targetIndex;
    })
    .width(Constant.FULL_PERCENT)
    .justifyContent(FlexAlign.Center);
  }

  build() {
    Navigation(RouterModule.stack) {
      Column() {
        Tabs({ index: this.homeTabIndex }) {
          ForEach(TABS_INFO, (item: TabBarModule) => {
            TabContent() {
              item.component.builder();
            }.tabBar(this.mainTabBar(item.title, item.id, item.activeIcon, item.defaultIcon));
          }, (item: TabBarModule) => JSON.stringify(item));
        }
        .backgroundColor($r('sys.color.white'))
        .barMode(BarMode.Fixed)
        .scrollable(false)
        .animationDuration(0)
        .barPosition(BarPosition.End)
        .onChange((value: number) => {
          this.homeTabIndex = value;
        });
      }.height(Constant.FULL_PERCENT);
    }.hideTitleBar(true).mode(NavigationMode.Stack);
  }
}