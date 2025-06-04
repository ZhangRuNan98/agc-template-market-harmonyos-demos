import { RecipeBriefInfo, SortType, TabItem } from '../types/Index';
import { SearchKeys } from './SearchKeys';
import { SearchResult } from './SearchResult';

@ComponentV2
export struct HomeSearch {
  @Param hotInfo: string[] = []
  @Param resultList: RecipeBriefInfo[] = [];
  @Param isShowResult: boolean = false;
  @Param isShowSearch: boolean = true;
  @Param paramsKeyword: string = '';
  @Local tabList: TabItem[] =
    [{ label: '综合', sortType: SortType.General }, { label: '收藏最多', sortType: SortType.Grade },
      { label: '浏览最多', sortType: SortType.Cooked }];
  // 搜索框聚焦
  @Local isFocus: boolean = true;
  @Local keyword: string = '';
  @Local historyInfo: string[] = [];
  // 当前tab栏索引
  @Local curTabIndex: number = 0;
  @Event searchDishes: (keyword: string) => void = () => {
  }
  @Event changeIndex: (index: number, keyword: string) => void = () => {
  }
  @Event changeShowResult: (flag: boolean) => void = () => {
  }
  @Event goRecipeDetail: (id: number) => void = () => {
  }

  aboutToAppear(): void {
    this.keyword = this.paramsKeyword
  }

  build() {
    Column() {
      Search({ placeholder: '输入关键词', value: $$this.keyword })
        .width('100%')
        .onChange((res) => {
          this.keyword = res.trim();
          if (!this.keyword) {
            this.changeShowResult(false);
          }
        })
        .onSubmit(() => {
          if (this.keyword) {
            // 插入历史记录,并去重
            this.historyInfo.unshift(this.keyword);
            this.historyInfo = Array.from(new Set(this.historyInfo));
            this.curTabIndex = 0
          }
          this.searchDishes(this.keyword);
        })
        .searchButton('搜索', {
          fontColor: '#0A59F7',
          fontSize: 14,
        })
        .defaultFocus(true)
        .margin({ top: 8 })
        .visibility(this.isShowSearch ? Visibility.Visible : Visibility.None)


      if (this.isShowResult) {
        SearchResult({
          curTabIndex: this.curTabIndex,
          resultList: this.resultList,
          changeIndex: (index: number) => {
            this.curTabIndex = index
            this.changeIndex(index, this.keyword)
          },
          goRecipeDetail: (id: number) => {
            this.goRecipeDetail(id)
          },
        })
      } else {
        Column() {
          SearchKeys({
            title: '搜索历史',
            keys: this.historyInfo,
            onKeyClick: (key: string) => {
              this.keyword = key;
              if (this.keyword) {
                // 插入历史记录,并去重
                this.historyInfo.unshift(this.keyword);
                this.historyInfo = Array.from(new Set(this.historyInfo));
              }
              this.searchDishes(this.keyword);
              this.curTabIndex = 0
            },
          }) {
            Text('清空')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .height(28)
              .width(72)
              .textAlign(TextAlign.Center)
              .backgroundColor('#0D000000')
              .borderRadius(14)
              .onClick(() => {
                this.historyInfo = [];
              });
          }
        }
        .margin({ top: 16 }).visibility(this.historyInfo.length ? Visibility.Visible : Visibility.None)

        SearchKeys({
          title: '热门搜索',
          keys: this.hotInfo,
          onKeyClick: (item) => {
            this.keyword = item;
            if (this.keyword) {
              // 插入历史记录,并去重
              this.historyInfo.unshift(this.keyword);
              this.historyInfo = Array.from(new Set(this.historyInfo));
            }
            this.searchDishes(this.keyword);
            this.curTabIndex = 0
          },
        }).margin({ top: 24 })
      }
    }.padding({ left: 16, right: 16 });
  }
}
