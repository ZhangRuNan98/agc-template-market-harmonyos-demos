@Builder
export function BaseHeader(title: string) {
  Row() {
    Text(title).width('100%').fontSize(24).fontColor($r('sys.color.font_primary')).fontWeight(FontWeight.Medium);
  }
  .width('100%')
  .height(56)
  .padding({
    left: 24,
    right: 24,
    top: 12,
    bottom: 12,
  }).backgroundColor($r('sys.color.background_secondary'))
}