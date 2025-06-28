import { querySearchHotkeys, CaseInfo, queryCaseList } from 'network';
import { DataSource } from 'commonlib';

@ObservedV2
export class SearchPageVM {
  @Trace isFocus: boolean = false;
  @Trace keywords: string = '';
  @Trace hotSearch: string[] = [];
  @Trace historyInfo: string[] = [];
  @Trace caseList: CaseInfo[]= [];
  @Trace isSearched: boolean = false;
  private static _instance: SearchPageVM;

  public static get instance() {
    if (!SearchPageVM._instance) {
      SearchPageVM._instance = new SearchPageVM();
    }
    return SearchPageVM._instance;
  }


  public async getHotkeys() {
    const res = await querySearchHotkeys();
    if (res.status === 200) {
      this.hotSearch = res.data;
    }
  }

  public async searchCase() {
    if (this.keywords) {
      // 插入历史记录,并去重
      this.historyInfo.unshift(this.keywords);
      this.historyInfo = Array.from(new Set(this.historyInfo));
      const res = await queryCaseList({ title: this.keywords });
      if (res.status === 200) {
        this.caseList=res.data;
        this.isSearched = true;
      }
    }
  }
}
