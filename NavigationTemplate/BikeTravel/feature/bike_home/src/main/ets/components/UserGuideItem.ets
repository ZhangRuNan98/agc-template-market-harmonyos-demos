@ComponentV2
export struct UserGuideItem {
  @Param @Require title: string
  @Param @Require content: string

  build() {
    Column({ space: 8 }) {
      Text(this.title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.contentColor'))
        .copyOption(2)

      Text(this.content)
        .fontSize(14)
        .fontColor($r('app.color.tab_font_color'))
        .copyOption(2)
    }
    .alignItems(HorizontalAlign.Start)
    .margin({top:10})
  }
}