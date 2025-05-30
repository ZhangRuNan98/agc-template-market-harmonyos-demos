@Component
export struct TitleBar {
  @Prop title: string
  pathStack: NavPathStack = new NavPathStack();
  @StorageLink('clearPath') clearPath: boolean = false
  @StorageLink('stackAnimated') stackAnimated: boolean = true

  build() {
    Row() {
      Row() {
        Image($r('app.media.chevron_left'))
          .width(16)
          .height(16)
          .objectFit(ImageFit.Cover)
      }
      .width(40)
      .height(40)
      .backgroundColor('#E6E8E9')
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        if (this.clearPath) {
          this.pathStack.clear()
          this.clearPath = false
        } else {
          this.pathStack.pop(this.stackAnimated)
          if (!this.stackAnimated) {
            this.stackAnimated = true
          }
        }
      })

      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 8 })
    }
    .width('100%')
    .margin({ top: 8, bottom: 8 })
  }
}