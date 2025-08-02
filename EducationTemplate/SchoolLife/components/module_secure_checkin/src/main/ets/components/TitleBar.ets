

@ComponentV2
export struct TitleBar {

  @Param
  public hideBackButton: boolean = false;

  @Param
  public barColor: ResourceColor = Color.Transparent;

  @Param
  public barExpandSafeArea: boolean = true;

  @Param
  public barPadding: Padding = {};

  @Event
  public onBackButtonClick: () => void = () => {};

  @BuilderParam
  private titleContentBuilder: () => void = buildEmptyComponent;

  // 在 ArkUI Inspector 中查看到元服务胶囊的宽度为 80.92
  private atomicServiceBarWidth: number = this.getUIContext().getAtomicServiceBar()?.getBarRect().width ?? 80.92;

  build() {
    Row() {
      Row() {
        if (!this.hideBackButton) {
          Column() {
            Image($r('app.media.ic_arrow_back'))
              .objectFit(ImageFit.Fill)
              .width(40)
              .height(40)
          }
          .width(56)
          .height(56)
          .alignItems(HorizontalAlign.End)
          .justifyContent(FlexAlign.Center)
          .onClick(this.onBackButtonClick)
        }
        Column() {
          this.titleContentBuilder();
        }
        .layoutWeight(1)
        .height(56)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .padding(this.barPadding)
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .backgroundColor(this.barColor)
      .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], this.barExpandSafeArea ? [SafeAreaEdge.TOP] : [])
      .padding({ right: this.atomicServiceBarWidth + 8 })
    }
    .width('100%')
    .height(56)
  }
}

@Builder
function buildEmptyComponent() {
  // No need to do anything
}
