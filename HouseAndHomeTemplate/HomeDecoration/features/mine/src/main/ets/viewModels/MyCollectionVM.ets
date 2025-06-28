import { queryCaseList, queryCollection, CaseInfo } from 'network';


@ObservedV2
export class MyCollectionVM {
  @Trace collectionList: number[] = [];
  @Trace caseList: CaseInfo[] = [];
  private static _instance: MyCollectionVM;

  public static get instance() {
    if (!MyCollectionVM._instance) {
      MyCollectionVM._instance = new MyCollectionVM();
    }
    return MyCollectionVM._instance;
  }

  public async getCaseList() {
    const res = await queryCaseList();
    if (res.status === 200) {
      this.caseList = res.data.filter((item => this.collectionList.includes(item.caseId)));
    }
  }

  public async getCollectionList() {
    const res = await queryCollection();
    if (res.status === 200) {
      this.collectionList = res.data;
    }
  }
}