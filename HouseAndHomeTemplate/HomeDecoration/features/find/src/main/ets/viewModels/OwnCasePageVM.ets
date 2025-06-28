import { CaseInfo } from 'network';
import { RouterModule, RouterMap } from 'commonlib';
import { RouterParams } from '../types/Index';


@ObservedV2
export class OwnCasePageVM {
  @Trace title: string = '设计师案例';
  @Trace caseList: CaseInfo[] = [];
  private static _instance: OwnCasePageVM;

  public static get instance() {
    if (!OwnCasePageVM._instance) {
      OwnCasePageVM._instance = new OwnCasePageVM();
    }
    return OwnCasePageVM._instance;
  }

  public getOwnCaseList() {
    const params = RouterModule.getNavParam<RouterParams>(RouterMap.OWN_CASE_PAGE);
    if (params) {
      this.caseList = params.caseList;
      this.title = params.title;
    }
  }


}
