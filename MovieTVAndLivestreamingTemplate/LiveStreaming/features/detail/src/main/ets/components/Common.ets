@Builder
export function titleBuilder(title: ResourceStr) {
  Row() {
    Text(title)
      .width(256)
      .height(27)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .fontColor('#e6000000')
      .textAlign(TextAlign.Start)
  }
  .height(56)
  .width(328)
}