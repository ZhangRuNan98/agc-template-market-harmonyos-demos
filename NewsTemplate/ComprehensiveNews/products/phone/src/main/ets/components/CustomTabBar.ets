import { AppStorageV2 } from '@kit.ArkUI';
import { CommonConstants, TabModel, WindowModel } from 'lib_common';
import { TabBarItem, TabBarType, TABS_INFO } from '../common/Constants';

@ComponentV2
export struct CustomTabBar {
  @Param fontSizeRatio: number = 1;
  @Consumer() selectedIndex: number = TabBarType.HOME;
  windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
  tabModel: TabModel = AppStorageV2.connect(TabModel, () => new TabModel())!;

  getTabColor(id: number): ResourceColor {
    if (this.selectedIndex === id) {
      return $r('app.color.app_theme')
    }
    if (this.selectedIndex === TabBarType.VIDEO &&
      (this.tabModel.videoCurrentTabIndex === 0 ||
      this.tabModel.videoCurrentTabIndex === 1)) {
      return $r('sys.color.icon_on_secondary')
    }
    return $r('sys.color.font_tertiary')
  }

  getBgColor(): ResourceColor {
    if (this.selectedIndex === TabBarType.VIDEO) {
      if (this.tabModel.videoCurrentTabIndex === 0 ||
        this.tabModel.videoCurrentTabIndex === 1) {
        return Color.Black
      }
    }
    return $r('sys.color.background_primary');
  }

  build() {
    Row() {
      ForEach(TABS_INFO, (item: TabBarItem) => {
        Column({ space: CommonConstants.SPACE_XS }) {
          Image(item.activeIcon)
            .width($r('app.float.normal_img_size'))
            .draggable(false)
            .fillColor(this.getTabColor(item.id))
            .objectFit(ImageFit.Contain)
          Text(item.title)
            .fontSize(10 * this.fontSizeRatio)
            .fontColor(this.getTabColor(item.id))
        }
        .layoutWeight(1)
        .padding({ top: CommonConstants.PADDING_XS, bottom: CommonConstants.PADDING_XS })
        .onClick(() => {
          this.selectedIndex = item.id;
        })
      }, (v: TabBarItem) => v.id.toString())
    }
    .backgroundColor(this.getBgColor())
    .width(CommonConstants.FULL_PERCENT)
    .padding({ bottom: this.windowModel.windowBottomPadding })
  }
}