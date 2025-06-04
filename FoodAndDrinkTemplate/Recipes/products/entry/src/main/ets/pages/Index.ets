import { CommonConstants, RouterMap, RouterModule } from 'commonlib';

@Entry
@ComponentV2
struct Index {
  navStack: NavPathStack = RouterModule.getStack();

  aboutToAppear(): void {
    RouterModule.replace(RouterMap.LAUNCH_PAGE)
  }

  build() {
    Navigation(this.navStack) {
    }
    .hideTitleBar(true)
    .hideNavBar(true)
    .mode(NavigationMode.Stack)
    .height(CommonConstants.FULL_HEIGHT)
    .width(CommonConstants.FULL_WIDTH);
  }
}
