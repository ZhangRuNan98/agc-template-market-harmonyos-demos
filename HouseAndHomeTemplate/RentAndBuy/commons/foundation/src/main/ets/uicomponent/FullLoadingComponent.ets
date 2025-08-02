@ComponentV2
export struct FullLoadingComponent {
  build() {
    Column() {
      LoadingProgress().width(30).height(30)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}