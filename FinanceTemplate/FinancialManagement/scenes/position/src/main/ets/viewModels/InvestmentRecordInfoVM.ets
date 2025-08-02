import { AccountUtil, RouterMap, RouterModule, UserInfoModel, } from 'module_base';
import { IInvestmentRecordItem, IRegularInvestmentInfo, } from 'lib_foundation';
import { IInvestmentParam } from '../types';

@ObservedV2
export class InvestmentRecordInfoVM {
  @Trace userInfo: UserInfoModel = AccountUtil.getUserInfo();
  private static _instance: InvestmentRecordInfoVM;
  @Trace public investmentInfo: IRegularInvestmentInfo | undefined
  @Trace public investmentRecordItem: IInvestmentRecordItem | undefined

  public static get instance() {
    if (!InvestmentRecordInfoVM._instance) {
      InvestmentRecordInfoVM._instance = new InvestmentRecordInfoVM();
    }
    return InvestmentRecordInfoVM._instance;
  }

  init() {
    const param = RouterModule.getNavParam<IInvestmentParam>({
      url: RouterMap.INVESTMENT_RECORD_INFO,
    });
    if (param) {
      this.investmentInfo = param.investmentInfo
      this.investmentRecordItem = param.record
    }
  }
}
