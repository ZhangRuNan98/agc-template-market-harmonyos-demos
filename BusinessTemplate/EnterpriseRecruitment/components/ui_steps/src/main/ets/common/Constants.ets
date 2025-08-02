export class Constants {
  // 图标尺寸
  static readonly ICON_CONTEXT_SIZE: number = 16
  // 图标圆点尺寸
  static readonly ICON_TEXT_SIZE: number = 8
  // 图标总尺寸
  static readonly ICON_SIZE: number = 24
  // 分隔器组件宽度
  static readonly DIVIDER_WIDTH: number = 1
  // 分割器等默认宽度
  static readonly INIT_SIZE: number = 58
  // 步骤条起始下标
  static readonly START_ID: number = 0
  // 文字最长多行数
  static readonly MAX_LINES: number = 3
  // 前一步
  static readonly PREVIOUS_NUMBER: number = 1
  // 圆角角度
  static readonly BORDER_RADIOUS: string = '50%'
  static readonly INIT_NUMBER: number = 0
  // 默认透明度
  static readonly DEFAULT_OPACITY: number = 0.6
  // 步骤条padding
  static readonly STEPS_PADDING: number = 16
  // 纵向状态文本距离图标的距离
  static readonly TEXT_COLOUM_OFFSET: number = 8
  // 焦点边框宽度
  static readonly FOCUS_BORDER_WIDTH: number = 2
  // 文字默认宽度
  static readonly DEFAULT_TEXT_WIDTH: number = 58
  // 标题行高
  static readonly TITLE_HEIGHT_LINE: number = 22
  // 详情行高
  static readonly DESC_HEIGHT_LINE: number = 20
}

// 步骤条方向
export enum Direction {
  // 横向
  ROW = 'row',
  // 纵向
  COLOUM = 'coloum',
}