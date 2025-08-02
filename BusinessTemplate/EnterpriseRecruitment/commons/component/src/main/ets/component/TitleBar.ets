@ComponentV2
export struct TitleBar {
  @Param text: ResourceStr = '';

  build() {
    Text(this.text)
      .fontSize(20)
      .fontColor('rgba(0,0,0,0.90)')
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Start)
  }
}