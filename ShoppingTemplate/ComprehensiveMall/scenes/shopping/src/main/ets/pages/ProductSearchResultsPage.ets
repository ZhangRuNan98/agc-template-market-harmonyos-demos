import {
  TitleBar,
  Style,
  buildProductGhostSearchBar,
  cache,
  routerStack,
  RouterMap,
} from 'lib_foundation';
import { ProductWaterFlow, RequestType } from 'module_product_waterflow';

@ComponentV2
struct ProductSearchResultsPage {
  @Local
  keywords: string = '';

  aboutToAppear(): void {
    this.keywords = cache.search.lastSubmit;
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({
          barPadding: { right: Style.MENU_BAR_MARGIN_RIGHT },
          barColor: Color.White,
        }) {
          buildProductGhostSearchBar(this.keywords, () => {
            this.keywords = cache.search.lastSubmit;
            routerStack.pop(false);
          }, false);
        };

        Column() {
          ProductWaterFlow({
            requestType: RequestType.BY_WORDS,
            keywords: this.keywords,
            showInitLoading: true,
            handleProductClick: (id) => {
              routerStack.pushPath({
                name: RouterMap.PRODUCT_INFO_NEW,
                param: id,
              });
            },
          })
            .layoutWeight(1);
        }
        .padding(16)
        .layoutWeight(1)
        .backgroundColor(Style.BACKGROUND_COLOR_GREY);
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start);
    }
    .hideTitleBar(true)
    .backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.CUTOUT], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP]);
  }
}

@Builder
export function buildProductSearchResultsPage() {
  ProductSearchResultsPage();
}
