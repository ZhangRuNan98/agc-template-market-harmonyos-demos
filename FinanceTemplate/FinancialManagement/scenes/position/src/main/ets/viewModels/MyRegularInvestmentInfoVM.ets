import { https, IInvestmentRecordItem, IRegularInvestmentInfo } from 'lib_foundation';
import { RouterMap, RouterModule, } from 'module_base';


@ObservedV2
export class MyRegularInvestmentInfoVM {
  private static _instance: MyRegularInvestmentInfoVM;
  @Trace public regularInvestmentInfo: IRegularInvestmentInfo | undefined
  @Trace public investmentRecordList: IInvestmentRecordItem[] = []

  public static get instance() {
    if (!MyRegularInvestmentInfoVM._instance) {
      MyRegularInvestmentInfoVM._instance = new MyRegularInvestmentInfoVM();
    }
    return MyRegularInvestmentInfoVM._instance;
  }

  init() {
    const param = RouterModule.getNavParam<number>({
      url: RouterMap.MY_REGULAR_INVESTMENT_INFO,
    });
    if (param) {
      this.getRegularInvestmentInfo(1, param)
      this.getInvestmentRecordList(1, param)
    }
  }

  public async getRegularInvestmentInfo(userId: number, id: number) {
    const res = await https.getRegularInvestmentInfo(userId, id);
    if (res.code === 0) {
      this.regularInvestmentInfo = res.data;
    }
  }

  public async getInvestmentRecordList(userId: number, id: number) {
    const res = await https.getInvestmentRecordList(userId, id);
    if (res.code === 0) {
      this.investmentRecordList = res.data;
    }
  }
}
