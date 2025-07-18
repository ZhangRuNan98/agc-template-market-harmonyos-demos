import { buildTitleBar, CommonConstants } from 'commonlib';
import { LengthMetrics } from '@kit.ArkUI';
import { SearchPageVM } from '../viewModels/SearchPageVM';
import { HomeSearch } from 'home_search';

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@Preview
@ComponentV2
struct SearchPage {
  vm: SearchPageVM = new SearchPageVM();

  aboutToAppear(): void {
    this.vm.getHotkeys();
    this.vm.getDefaultSearch();
  }

  build() {
    NavDestination() {
      Scroll() {
        HomeSearch({
          hotInfo: this.vm.hotInfo,
          resultList: this.vm.resultList,
          paramsKeyword: this.vm.paramsKeyword,
          isShowResult: this.vm.isShowResult,
          isShowSearch: this.vm.formPage !== CommonConstants.CLASSIFICATION_PAGE,
          searchDishes: (keyword: string) => {
            this.vm.searchDishes(keyword)
          },
          changeIndex: (index: number, keyword: string) => {
            this.vm.changeIndex(index, keyword)
          },
          changeShowResult: (flag: boolean) => {
            this.vm.isShowResult = false
            this.vm.resultList = this.vm.resultList.filter(() => false)
          },
          goRecipeDetail: (id: number) => {
            this.vm.goRecipeDetail(id)
          },
        })

      }
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Top)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM]);
    }
    .title(buildTitleBar(this.vm.title, this.vm.formPage === CommonConstants.CLASSIFICATION_PAGE),
      { paddingStart: LengthMetrics.vp(16) });
  }
}


