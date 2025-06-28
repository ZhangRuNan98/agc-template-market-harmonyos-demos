export class Style {
  // 底部导航栏高度
  public static readonly BOTTOM_NAV_HEIGHT: number = 48;
  // 底部导航栏模糊选项 (开启模糊时生效)
  public static readonly BOTTOM_NAV_BLUR_STYLE_OPTION: BackgroundBlurStyleOptions =
    { scale: 0.9 };
  // 元服务胶囊高度
  public static readonly MENU_BAR_HEIGHT: number = 36;
  // 元服务胶囊宽度
  public static readonly MENU_BAR_WIDTH: number = 80.92;
  // 元服务胶囊边框宽度
  public static readonly MENU_BAR_BORDER_WIDTH: Length = $r(
    'sys.float.border_small',
  );
  // 元服务胶囊边框圆角半径
  public static readonly MENU_BAR_BORDER_RADIUS: number = 18;
  // 元服务胶囊与屏幕右边缘的距离
  public static readonly MENU_BAR_MARGIN_RIGHT: number = 8;
  // 标题栏高度
  public static readonly TITLE_BAR_HEIGHT: number = 56;
  // 标题栏返回按钮宽度
  public static readonly TITLE_BAR_BACK_BTN_WIDTH: number = 42;
  // 标题栏返回按钮内嵌图标高度
  public static readonly TITLE_BAR_BACK_ICON_HEIGHT: number = 22;
  // 分割线高度
  public static readonly DIVIDER_HEIGHT: number = 1;
  public static readonly FONT_SIZE_10 = '10fp';
  public static readonly FONT_SIZE_12 = '12fp';
  public static readonly FONT_SIZE_14 = '14fp';
  public static readonly FONT_SIZE_16 = '16fp';
  public static readonly FONT_SIZE_18 = '18fp';
  public static readonly FONT_SIZE_20 = '20fp';
  public static readonly FONT_SIZE_24 = '24fp';
  public static readonly THEME_COLOR = '#E64566';
  public static readonly THEME_COLOR_SECOND = '#F2992C';
  public static readonly FONT_COLOR_LEVEL1 = '#E6000000';
  public static readonly FONT_COLOR_1_INVERT = '#FFFFFF';
  public static readonly FONT_COLOR_LEVEL2 = '#99000000';
  public static readonly FONT_COLOR_LEVEL3 = '#66000000';
  public static readonly DIVIDER_COLOR = '#C4C4C4';
  public static readonly WARNING_COLOR = '#E84026';
  public static readonly BACKGROUND_COLOR = '#FFFFFF';
  public static readonly BACKGROUND_COLOR_GREY = '#f1f3f5';
  public static readonly BACKGROUND_COLOR_THEME = '#1ae64566';
  public static readonly BACKGROUND_COLOR_GREY_2 = '#0D000000';
  public static readonly BORDER_RADIUS_4 = '4vp';
  public static readonly BORDER_RADIUS_16 = '16vp';
  public static readonly BORDER_RADIUS_CAPSULE = '99vp';
}
