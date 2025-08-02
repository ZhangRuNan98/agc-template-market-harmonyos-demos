import { Style } from '../constants/Style';
import { routerStack } from '../utils/RouterStack';


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
  public onBackButtonClick: () => void = () => routerStack.pop();
  @BuilderParam
  public titleContentBuilder: () => void = buildEmptyComponent;

  build() {
    Row() {
      Row() {
        if (!this.hideBackButton) {
          Column() {
            Image($r('app.media.ic_left_arrow'))
              .height(Style.TITLE_BAR_BACK_ICON_HEIGHT)
              .objectFit(ImageFit.Contain)
              .fillColor($r('sys.color.mask_secondary'));
          }
          .width(Style.TITLE_BAR_BACK_BTN_WIDTH)
          .height(Style.TITLE_BAR_HEIGHT)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .onClick(this.onBackButtonClick);
        }
        Column() {
          this.titleContentBuilder();
        }
        .layoutWeight(1)
        .height(Style.TITLE_BAR_HEIGHT)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .padding(this.barPadding);
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .height(Style.TITLE_BAR_HEIGHT);
    }
    .backgroundColor(this.barColor)
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], this.barExpandSafeArea ? [SafeAreaEdge.TOP] : [])
  }
}

@Builder
function buildEmptyComponent() {
  // No need to do anything
}
