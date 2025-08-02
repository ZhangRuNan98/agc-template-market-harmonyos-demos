@ComponentV2
export struct TopBar {
  @Param text: ResourceStr = '';

  build() {
    Text(this.text)
      .fontSize(24)
      .fontColor('rgba(0,0,0,0.90)')
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Start)
      .margin({
        top: 8
      })
  }
}