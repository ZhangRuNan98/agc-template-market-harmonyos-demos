import { queryRecipeList, querySearchHotkeys, RecipeBriefInfo } from 'network';
import { CommonConstants, RouterMap, RouterModule } from 'commonlib';

const TAG = '[SearchPageVM]';

@ObservedV2
export class SearchPageVM {
  @Trace hotInfo: string[] = [];
  // 搜索结果
  @Trace resultList: RecipeBriefInfo[] = [];
  // 是否展示搜索结果
  @Trace isShowResult: boolean = false;
  @Trace paramsKeyword: string = '';
  // 来源页
  @Trace formPage: string = '';
  @Trace title: string = '菜谱搜索';

  // 搜索菜谱
  public async searchDishes(keyword: string) {
    const res = await queryRecipeList({ name: keyword });
    if (res.status === 200) {
      this.resultList = res.data;
      this.isShowResult = true;
    }
  }

  public async getHotkeys() {
    const res = await querySearchHotkeys();
    if (res.status === 200) {
      this.hotInfo = res.data;
    }
  }

  public getDefaultSearch() {
    const params: Record<string, string> | undefined = RouterModule.getNavParam(RouterMap.SEARCH);
    if (params) {
      this.formPage = params.form;
      if (this.formPage === CommonConstants.CLASSIFICATION_PAGE) {
        this.title = params.keyword
      }
      this.paramsKeyword = params.keyword
      this.searchDishes(params.keyword);
    }
  }

  changeIndex(index: number, keyword: string) {
    if (index === 1) {
      this.resultList = this.resultList.sort((a, b) => b.likes - a.likes);
    } else if (index === 2) {
      this.resultList = this.resultList.sort((a, b) => b.views - a.views);
    } else {
      this.searchDishes(keyword);
    }
  }

  goRecipeDetail(id: number) {
    RouterModule.push(RouterMap.DISHES, { 'id': id } as Record<string, number>);
  }
}
