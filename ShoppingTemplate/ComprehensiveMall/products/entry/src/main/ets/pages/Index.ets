import { iData, routerStack, LoadingStatus, TabSwiper, Style, BreakpointSystem } from 'lib_foundation';
import { IndexLogic } from '../logic/IndexLogic';
import { uiObserver } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {

  private readonly logic: IndexLogic = new IndexLogic();

  aboutToAppear(): void {
    BreakpointSystem.register(this.getUIContext())
    iData.global.isNavPathStackEmpty = routerStack.size() === 0;
    uiObserver.on('navDestinationUpdate', (_: NavDestinationInfo) => {
      iData.global.isNavPathStackEmpty = routerStack.size() === 0;
    });
  }

  aboutToDisappear(): void {
    uiObserver.off('navDestinationUpdate');
  }

  build(): void {
    if (this.logic.loadingStatus === LoadingStatus.SUCCESS) {
      Navigation(routerStack) {
        TabSwiper({
          viewData: this.logic.tabSwiperViewData,
          disableSwipe: true,
          tabLayoutMode: 'SpaceAround',
          tabsContainerMinHeight: Style.BOTTOM_NAV_HEIGHT,
          trackEdgeEffectMode: EdgeEffect.None,
          barPosition: BarPosition.End,
          barOverlap: true,
          barBackgroundColor: this.logic.barBackgroundColor,
          barExpandSafeArea: true,
          barBackgroundBlurStyle: this.logic.barBackgroundBlurStyle,
          barBackgroundBlurStyleOptions: Style.BOTTOM_NAV_BLUR_STYLE_OPTION,
          swiperInitialIndex: this.logic.initialIndex,
          swiperBackgroundColor: '#FFF1F3F5',
          swiperExpandSafeArea: true,
          onChange: this.logic.onTabSwiperChange,
        })
      }
      .width('100%')
      .height('100%')
      .titleMode(NavigationTitleMode.Mini)
      .mode(NavigationMode.Stack)
      .hideTitleBar(true, false)
      .hideBackButton(true)
    }
  }
}
