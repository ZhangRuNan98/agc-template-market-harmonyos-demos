import { FlexLayoutPage } from 'lib_flex_layout';
import { HomeServiceApi, NewsResponse, RequestListData } from 'lib_news_api';
import { NavHeaderBar } from 'lib_widget'
import { Highlight } from 'module_highlight';
import { HomeViewModel } from '../viewmodels/HomeViewModel';

@Builder
export function NewsSearchBuilder() {
  NewsSearch()
}

@ComponentV2
export struct NewsSearch {
  @Local searchValue: string = ''
  @Local hotDataList: RequestListData[] = []
  @Local isSearchCommit: boolean = false;
  @Local homeViewVM: HomeViewModel = new HomeViewModel()
  controller: SearchController = new SearchController();

  async aboutToAppear() {
    this.hotDataList = await HomeServiceApi.queryHomeRecommendList('hotTopChart');
  }

  @Builder
  searchBuilder() {
    Search({ value: this.searchValue, controller: this.controller })
      .cancelButton({
        style: CancelButtonStyle.CONSTANT,
        icon: {
          src: $r('sys.media.ohos_ic_public_cancel_filled'),
        },
      })
      .onFocus(() => {
        this.isSearchCommit = false
      })
      .onChange((value) => {
        this.searchValue = value
        this.homeViewVM.searchChange(this.searchValue)
      })
      .fontColor($r('sys.color.font_primary'))
      .onSubmit(() => {
        this.homeViewVM.getSearchResultList(this.searchValue)
        this.isSearchCommit = true
      })
      .defaultFocus(true)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .textFont({ size: 16, weight: FontWeight.Medium })
      .width('85%')
  }

  @Builder
  historySearch() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text('历史搜索')
          .fontSize(14)
          .fontColor($r('sys.color.font_secondary'))
        Row({ space: 5 }) {
          Image($r('app.media.clear')).width(16).height(16)
          Text('清空')
            .fontSize(14)
            .fontColor($r('sys.color.font_secondary'))
        }
        .onClick(() => {
          this.homeViewVM.clearHistory()
        })
      }

      Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
        Row() {
          Text('暂无历史搜索')
            .fontSize(12)
            .fontColor($r('sys.color.font_secondary'))
        }
        .visibility(this.homeViewVM.searchHistory.historyList.length <= 0 ? Visibility.Visible : Visibility.None)
        .width('100%')
        .justifyContent(FlexAlign.Center)

        ForEach(this.homeViewVM.searchHistory.historyList, (item: string) => {
          Row() {
            Text(item)
              .fontSize(14)
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Medium)
          }
          .padding({
            left: 12,
            right: 12,
            top: 4,
            bottom: 4,
          })
          .onClick(() => {
            this.searchValue = item
            this.homeViewVM.getSearchResultList(this.searchValue)
            this.controller.stopEditing()
            this.isSearchCommit = true
          })
          .margin({ right: 12, bottom: 12 })
          .borderRadius(14)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .visibility(this.homeViewVM.searchHistory.historyList.length <= 0 ? Visibility.None : Visibility.Visible)
        })
      }
      .margin({ top: 12, bottom: 12 })
    }
    .padding({ left: 16, right: 16 })
    .margin({ top: 16 })
  }

  @Builder
  searchResultListBuilder() {
    List() {
      if (this.homeViewVM.searchResultList.length <= 0) {
        ListItem() {
          Column() {
            Image($r('app.media.search_no_result')).width(120).height(120)
            Text('暂无搜索结果')
              .fontSize(14)
              .fontColor($r('sys.color.font_secondary'))
          }
        }
        .width('100%')
        .height('100%')
      } else {
        ForEach(this.homeViewVM.searchResultList, (item: RequestListData) => {
          ListItem() {
            FlexLayoutPage({
              setting: JSON.parse(item.navInfo.setting),
              articles: item.articles,
              extraInfo: { 'searchKey': this.searchValue },
            })
          }
        }, (item: RequestListData) => JSON.stringify(item))
      }
    }
    .scrollBar(BarState.Off)
    .layoutWeight(1)
    .padding({ left: 16, right: 16 })
    .visibility(this.isSearchCommit ? Visibility.Visible : Visibility.None)
  }

  @Builder
  searchListBuilder() {
    List({ space: 21 }) {
      ListItem() {
        Column() {
          Image($r('app.media.search_no_result')).width(120).height(120)
          Text('暂无搜索结果')
            .fontSize(14)
            .fontColor($r('sys.color.font_secondary'))
        }
      }
      .visibility(this.homeViewVM.searchResultList.length <= 0 ? Visibility.Visible : Visibility.None)
      .width('100%')
      .height('100%')

      ForEach(this.homeViewVM.searchResultList, (item: RequestListData) => {
        ForEach(item.articles, (value: NewsResponse) => {
          ListItem() {
            Flex() {
              Image($r('app.media.search')).width(14).height(14)
                .margin({ right: 16 })
                .fillColor($r('sys.color.font_primary'))
              Highlight({
                keywords: [this.searchValue],
                sourceString: value.title,
                textFontWeight: FontWeight.Medium,
                maxLines: 1,
                highLightColor: $r('app.color.app_theme'),
                overflow: TextOverflow.Ellipsis,
              })
                .flexGrow(1)
            }
          }
          .onClick(() => {
            this.homeViewVM.getSearchResultList(this.searchValue)
            this.controller.stopEditing()
            this.isSearchCommit = true
          })
          .visibility(this.homeViewVM.searchResultList.length <= 0 ? Visibility.None : Visibility.Visible)
        })
      }, (item: NewsResponse) => JSON.stringify(item))
    }
    .visibility(this.isSearchCommit ? Visibility.None : Visibility.Visible)
    .padding({ left: 16, right: 16 })
    .scrollBar(BarState.Off)
    .layoutWeight(1)
    .cachedCount(1)
  }

  @Builder
  hotTopChartList() {
    List() {
      ListItem() {
        Row({ space: 5 }) {
          Image($r('app.media.hot_chart')).width(24).height(24)
          Text('热搜榜')
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_primary'))
            .fontSize(18)
        }
      }.padding({ left: 16 })

      ForEach(this.hotDataList, (item: RequestListData) => {
        ListItem() {
          FlexLayoutPage({
            setting: JSON.parse(item.navInfo.setting),
            articles: item.articles,
            extraInfo: item.extraInfo,
          })
        }
      }, (item: RequestListData) => JSON.stringify(item))
    }
    .scrollBar(BarState.Off)
    .layoutWeight(1)
    .cachedCount(1)
  }

  build() {
    NavDestination() {
      NavHeaderBar({
        rightPartBuilder: () => {
          this.searchBuilder()
        },
      })
      if (this.searchValue.trim() !== '') {
        this.searchListBuilder()
        this.searchResultListBuilder()
      } else {
        this.historySearch()
        this.hotTopChartList()
      }
    }
    .hideTitleBar(true)
  }
}