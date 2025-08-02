@ComponentV2
export struct TitleBar {
  @Param @Require title: string;
  @Param isShowBack: boolean = true;
  @Param @Require stack: NavPathStack

  build() {
    Row({ space: 8 }) {
      Image($r('app.media.icon_nav_left'))
        .size({ height: 40, width: 40 })
        .onClick(() => {
          this.stack.pop();
        });
      Text(this.title)
        .fontSize(20)
        .width('50%')
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontWeight(FontWeight.Medium);
    }
    .margin({ top: 38 })
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .padding({
      left: 12,
      right: 12,
    });
  }
}