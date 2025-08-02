import { CommonConstants } from '../constants/CommonContants';
import { RouterModule } from '../utils/RouterModule';
import { WindowUtil } from '../utils/WindowUtil';

class HeaderConstant {
  // 返回图标尺寸_内
  static readonly ICON_SIZE_INNER: Length = 24;
  // 返回图标尺寸_外
  static readonly ICON_SIZE_OUTER: Length = 40;
  //返回图标背景色
  static readonly ICON_BG_COLOR: Length = $r('sys.color.comp_background_tertiary');
  // 标题字体颜色
  static readonly FONT_COLOR: ResourceStr = $r('sys.color.font_primary');
  // 基础高度
  static readonly HEIGHT: number = 56;
  // 内边距
  static readonly PADDING: Length = 16;
  // 外边距
  static readonly MARGIN: Length = 8;
}

@ComponentV2
export struct CommonHeader {
  // 标题文字
  @Param title: string = '';
  // 返回动画
  @Param backAnimation: boolean = true;
  @Param showBackButton: boolean = true;
  headerHeight: number = HeaderConstant.HEIGHT;

  build() {
    Row() {
      if (this.showBackButton) {
        Row() {
          Image($r('app.media.ic_back')).width(HeaderConstant.ICON_SIZE_INNER)
        }
        .aspectRatio(1)
        .borderRadius('50%')
        .justifyContent(FlexAlign.Center)
        .width(HeaderConstant.ICON_SIZE_OUTER)
        .margin({ right: HeaderConstant.MARGIN })
        .backgroundColor(HeaderConstant.ICON_BG_COLOR)
        .onClick(() => {
          RouterModule.pop(this.backAnimation);
        })
      }
      Text(this.title)
        .fontWeight(this.showBackButton ? FontWeight.Bold : FontWeight.Medium)
        .fontSize(this.showBackButton ? $r('sys.float.Title_S') : $r('sys.float.Title_M'))
        .fontColor(HeaderConstant.FONT_COLOR)
        .padding({ left: this.showBackButton ? 0 : 8 })
    }
    .height(this.headerHeight)
    .width(CommonConstants.FULL_WIDTH)
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.Transparent)
    .padding({ left: HeaderConstant.PADDING })
    .margin({ bottom: 4, top: WindowUtil.getAvoidArea().top })
  }
}