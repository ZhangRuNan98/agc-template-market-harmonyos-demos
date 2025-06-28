import { RouterModule, RouterMap } from 'commonlib';
import { CaseInfo, CustomParams, queryCustomList } from 'network';

@ObservedV2
export class CustomResultVM {
  @Trace baseInfo: CustomParams | undefined = undefined;
  @Trace caseList: CaseInfo[] = [];
  private static _instance: CustomResultVM;

  public static get instance() {
    if (!CustomResultVM._instance) {
      CustomResultVM._instance = new CustomResultVM();
    }
    return CustomResultVM._instance;
  }

  public async getCaseList() {
    const params: CustomParams | undefined = RouterModule.getNavParam<CustomParams>(RouterMap.CUSTOM_RESULT);
    if (params) {
      this.baseInfo = params;
      const res = await queryCustomList(params);
      if (res.status === 200) {
        this.caseList = res.data;
      }
    }
  }
}