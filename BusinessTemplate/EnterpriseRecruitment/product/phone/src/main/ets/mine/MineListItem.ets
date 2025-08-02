
@ComponentV2
export default struct MineListItem {
  @Param imagePath: Resource = $r('app.media.star');
  @Param text: string | Resource = '';
  @Param onClickItem: (event: ClickEvent) => void = () => {};
  @Param unReadCount: number = 0;

  build() {
    Row() {
      Row() {
        Image(this.imagePath)
          .width('24vp')
          .height('24vp')
          .backgroundColor(Color.White)
          .margin({right: 16 })
        Text(this.text)
          .fontSize($r('app.float.font_size_16'))
          .fontColor(Color.Black)
          .fontWeight(500)
      }

      Row() {
        if (this.unReadCount !== 0) {
          Text(String(this.unReadCount))
            .width(16)
            .height(16)
            .fontSize(10)
            .fontColor(Color.White)
            .borderRadius('50%')
            .backgroundColor('#E84026')
            .textAlign(TextAlign.Center)
            .margin({
              right:4
            })

        }

        Image($r('app.media.ic_public_arrow_right'))
          .fillColor($r('sys.color.ohos_id_color_foreground'))
          .opacity(0.2)
          .width(12)
          .height(24)
      }



    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(
      (event: ClickEvent) => {
        this.onClickItem(event)
      }
    )
  }
}