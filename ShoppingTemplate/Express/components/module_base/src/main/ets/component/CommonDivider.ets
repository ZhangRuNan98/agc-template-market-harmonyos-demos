@ComponentV2
export struct CommonDivider {
  @Param color: ResourceColor = '#f7f7f7';
  @Param strokeWidth: string | number = 1;

  build() {
    Divider()
      .vertical(false)
      .color(this.color)
      .strokeWidth(this.strokeWidth)
      .lineCap(LineCapStyle.Butt)
      .margin({
        top: 8,
        bottom: 8,
      });
  }
}