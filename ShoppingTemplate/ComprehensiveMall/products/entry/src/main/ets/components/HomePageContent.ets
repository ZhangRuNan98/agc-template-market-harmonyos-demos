import { Category, iResourceMgr, RouterMap, routerStack, Style } from 'lib_foundation';
import { ProductWaterFlow } from 'module_product_waterflow';

@ComponentV2
export struct HomePageContent {
  @Param
  bannerList: ResourceStr[] = [
    $r('app.media.mock_homepage_banner1'),
    $r('app.media.mock_homepage_banner2'),
    $r('app.media.mock_homepage_banner3'),
  ];
  @Param
  categoryList: Category[] = [];
  @Local
  categoryDisplayList: Category[][] = [];
  @Event
  handleClickCategory: (id: string) => void;

  aboutToAppear(): void {
    this.getCategoryDisplayList();
  }

  build() {
    Scroll() {
      Column({ space: 12 }) {
        this.bannerBuilder();
        this.categoryBuilder();
        ProductWaterFlow({
          handleProductClick: (id) => {
            routerStack.pushPath({
              name: RouterMap.PRODUCT_INFO_NEW,
              param: id,
            });
          },
        });
      };
    }
    .padding(16)
    .backgroundColor(Style.BACKGROUND_COLOR_GREY)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST,
    });
  }

  @Builder
  bannerBuilder() {
    Swiper() {
      ForEach(this.bannerList, (item: ResourceStr) => {
        Image(item)
          .objectFit(ImageFit.Cover)
          .draggable(false);
      }, (item: ResourceStr, index: number) => index + JSON.stringify(item));
    }
    .width('100%')
    .indicator(false)
    .autoPlay(true)
    .aspectRatio(4 / 3)
    .clip(true)
    .borderRadius(8);
  }

  @Builder
  categoryBuilder() {
    Swiper() {
      ForEach(this.categoryDisplayList, (list: Category[]) => {
        Grid() {
          ForEach(list, (category: Category) => {
            GridItem() {
              Column() {
                Image(iResourceMgr.resolveUri(category.iconUrl))
                  .width(48)
                  .height(48)
                  .margin({ bottom: 4 });
                Text(category.label)
                  .fontSize(12)
                  .fontColor(Style.FONT_COLOR_LEVEL3);
              }
              .height(60);
            }
            .onClick(() => {
              this.handleClickCategory?.(category.id);
            });
          }, (category: Category, index: number) => index + category.id);
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .columnsGap(16)
        .rowsGap(16)
        .height(160)
        .padding(16);
      }, (list: Category[], index: number) => index + JSON.stringify(list));
    }
    .backgroundColor(Style.BACKGROUND_COLOR)
    .borderRadius(8)
    .height(188)
    .indicator(
      new DotIndicator()
        .selectedColor(Style.THEME_COLOR)
        .itemWidth(4)
        .itemHeight(4)
        .selectedItemWidth(12)
        .selectedItemHeight(4),
    );
  }

  getCategoryDisplayList() {
    if (this.categoryList.length) {
      for (let i = 0; i < this.categoryList.length; i += 10) {
        const chunk = this.categoryList.slice(i, i + 10);
        this.categoryDisplayList.push(chunk);
      }
    }
  }
}