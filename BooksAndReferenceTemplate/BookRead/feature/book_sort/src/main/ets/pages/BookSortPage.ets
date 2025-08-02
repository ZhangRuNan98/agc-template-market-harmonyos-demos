import { BookApi, BookCategory, BookSubcategory, NavHeaderBar, GetBookCategoryRsp, BookCategoryItem } from 'common';

@ComponentV2
export struct BookSortPage {
  @Local categoryChannel: Resource[] = [];
  @Local currentSortIndex: number = 0;
  @Local currentTitleId: number = 0;
  private categoryList: Array<BookCategory> = [];
  private navTitleScroller: Scroller = new Scroller();
  private bookListScroller: Scroller = new Scroller();

  async aboutToAppear(): Promise<void> {
    this.categoryChannel.push($r('app.string.boys_channel'));
    this.categoryChannel.push($r('app.string.girls_channel'));
    this.categoryChannel.push($r('app.string.free_channel'));
    this.getBooksCategory();
  }

  async getBooksCategory() {
    const rsp: GetBookCategoryRsp = await BookApi.getBookCategoryList();
    this.categoryList = rsp.category;
  }

  @Builder
  categoryTab() {
    Column() {
      List({ space: 15 }) {
        ForEach(this.categoryChannel, (item: ResourceStr, index: number) => {
          ListItem() {
            Text(item)
              .textAlign(TextAlign.Center)
              .fontSize($r('sys.float.Body_L'))
              .fontColor(this.currentSortIndex === index ? Color.White : $r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
              .height(40)
              .width(100)
              .backgroundColor(this.currentSortIndex === index ? Color.Black : $r('app.color.common_background'))
              .borderRadius(21)
              .onClick(async () => {
                this.currentSortIndex = index
              })
          }
        }, (item: ResourceStr) => JSON.stringify(item))
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .listDirection(Axis.Horizontal)
      .padding({ top: 10, left: 18, right: 18 })
    }

  }

  @Builder
  goodsHeaderBuilder(headerName: string) {
    Row() {
      Text(headerName)
        .fontSize(16)
        .fontWeight(500)
    }
    .width('100%')
    .height(56)
    .padding({ left: 8 })
    .backgroundColor($r('sys.color.white'))
  }

  listChange(index: number, isGoods: boolean) {
    if (this.currentTitleId !== index) {
      this.currentTitleId = index;
      if (isGoods) {
        this.bookListScroller.scrollToIndex(index);
      } else {
        this.navTitleScroller.scrollToIndex(index);
      }
    }
  }

  @Builder
  SecondaryLevelList() {
    Column() {
      Row() {
        List({ space: 8, scroller: this.navTitleScroller }) {
          ForEach(this.categoryList, (item: BookCategory, index: number) => {
            ListItem() {
              Row() {
                Text(item.categoryName)
                  .width('100%')
                  .height(56)
                  .fontSize(this.currentTitleId === index ? 16 : 14)
                  .textAlign(TextAlign.Center)
                  .fontColor(this.currentTitleId === index ? '#ffffff' : '#000000')
                  .opacity(this.currentTitleId === index ? 1 : 0.6)
                  .fontWeight(this.currentTitleId === index ? FontWeight.Bold :
                  FontWeight.Normal)
                  .onClick(() => {
                    this.listChange(index, true);
                  })
              }
              .width(88)
              .height(40)
              .borderRadius({
                topRight: 12,
                bottomRight: 12
              })
              .backgroundColor(this.currentTitleId === index ? '#E84026' : '')
            }
          }, (item: BookCategory) => JSON.stringify(item.categoryName))
        }
        .width(100)
        .height('100%')
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Off)
        .backgroundColor('#F1F3F5')
        .padding({ top: 12 })
        List({ scroller: this.bookListScroller }) {
          ForEach(this.categoryList, (item: BookCategory) => {
            ListItemGroup({ space: 8, header: this.goodsHeaderBuilder(item.categoryName) }) {
              ForEach(item.subcategory, (bookCategoryItem: BookSubcategory) => {
                ListItem() {
                  BookCategoryItem({ categoryInfo: bookCategoryItem })
                }
              }, (bookCategoryItem: BookSubcategory) => JSON.stringify(bookCategoryItem.subcategoryId))
            }

          }, (item: BookCategory) => JSON.stringify(item.subcategory))
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .lanes(3)
        .scrollBar(BarState.Off)
        .sticky(StickyStyle.Header)
        .edgeEffect(EdgeEffect.Spring)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        .padding({ left: 8, right: 12 })
        .backgroundColor('#ffffff')
        .onScrollIndex((index: number) => {
          this.listChange(index, false)
        })
      }
      .width('100%')
      .height('90.5%')
      .justifyContent(FlexAlign.Center)
      .alignSelf(ItemAlign.Center)
      .margin({ top: 12 })
    }

  }

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: $r('app.string.book_sort'),
          hasBackButton: false,
          hasBgColor: false,
          isMainPage: true,
        })
        Column() {
          Scroll() {
            this.categoryTab()
          }
          this.SecondaryLevelList()
        }
        .height('100%')
        .width('100%')
        .layoutWeight(1)
      }
    }
    .hideTitleBar(true)
  }
}

