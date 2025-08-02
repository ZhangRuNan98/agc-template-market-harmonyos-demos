import { TitleBar, buildProductGhostSearchBar, Category, routerStack, Style, Card, RouterMap } from 'lib_foundation';
import { ProductWaterFlow, RequestType } from 'module_product_waterflow';
import { CommonModifier } from '@kit.ArkUI';
import { client } from 'lib_network';

@ComponentV2
export struct CategoryPageContent {
  @Param
  public pageName: string | undefined = '';
  @Param
  public initId: string = '';
  @Local
  private isSubPage: boolean = false;
  @Local
  isLoading: boolean = false;
  @Local
  categoryTabs: Category[] = [];
  @Local
  curIndex: number = 0;
  @Local
  productList: Card[] = [];
  tabBarModifier: CommonModifier = new CommonModifier().align(Alignment.Top);
  controller: TabsController = new TabsController();

  @Computed
  get curCategoryId() {
    return this.categoryTabs[this.curIndex]?.id ?? undefined;
  }

  public aboutToAppear(): void {
    this.isSubPage = Boolean(this.pageName);
    this.isLoading = true;
    client.cardList.getCategoryList()
      .then((list: Category[]) => {
        this.categoryTabs = list;
        const index = this.categoryTabs.findIndex((item) => item.id === this.initId);
        if (index >= 0) {
          this.curIndex = index;
        }
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  build() {
    NavDestination() {
      Column() {
        this.searchBarBuilder();
        this.categoryBarBuilder();
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]);
    }
    .hideTitleBar(true)
  }

  @Builder
  searchBarBuilder() {
    TitleBar({
      hideBackButton: !this.isSubPage,
      barColor: Color.White,
      barPadding: this.isSubPage ? { right: 12 } : { left: 12, right: 12 },
      barExpandSafeArea: true,
    }) {
      buildProductGhostSearchBar(
        '请输入搜索内容',
        () => routerStack.pushPathByName(RouterMap.PRODUCT_SEARCH, null),
      );
    }
  }

  @Builder
  categoryBarBuilder() {
    Row() {
      if (this.isLoading) {
        LoadingProgress().width(32).height(32);
      } else {
        List() {
          ForEach(this.categoryTabs, (item: Category, index: number) => {
            ListItem() {
              this.tabBarItemBuilder(item, index);
            };
          }, (item: Category, index: number) => index + JSON.stringify(item));
        }
        .width('30%')
        .height('100%')
        .borderWidth({ right: 1 })
        .borderColor(Style.BACKGROUND_COLOR_GREY);

        Column() {
          ProductWaterFlow({
            bgColor: Style.BACKGROUND_COLOR,
            requestType: RequestType.BY_CATEGORY,
            categoryId: this.curCategoryId,
            isVertical: true,
            showInitLoading: true,
            handleProductClick: (id: string) => {
              routerStack.pushPath({ name: RouterMap.PRODUCT_INFO_NEW, param: id });
            },
          })
            .layoutWeight(1);
        }
        .padding(16)
        .layoutWeight(1);
      }
    }
    .layoutWeight(1)
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Start)
    .width('100%');
  }

  @Builder
  tabBarItemBuilder(item: Category, index: number) {
    Row() {
      Text(item.label)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontColor(index === this.curIndex ? Style.THEME_COLOR : Style.FONT_COLOR_LEVEL2)
        .fontWeight(index === this.curIndex ? FontWeight.Medium : FontWeight.Regular)
        .fontSize(12);
    }
    .width('100%')
    .height(48)
    .padding(16)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.curIndex = index;
    });
  }
}

@Builder
export function buildCategoryPage(pageName?: string, initId?: string) {
  CategoryPageContent({ pageName: pageName, initId: initId })
}
