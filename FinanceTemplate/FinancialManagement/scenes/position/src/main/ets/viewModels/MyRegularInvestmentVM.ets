import { https, IRegularInvestmentItem } from 'lib_foundation';

@ObservedV2
export class MyRegularInvestmentVM {
  private static _instance: MyRegularInvestmentVM;
  @Trace public regularInvestmentList: IRegularInvestmentItem[] = []

  public static get instance() {
    if (!MyRegularInvestmentVM._instance) {
      MyRegularInvestmentVM._instance = new MyRegularInvestmentVM();
    }
    return MyRegularInvestmentVM._instance;
  }

  init() {
    this.getRegularInvestmentList(1)
  }

  public async getRegularInvestmentList(userId: number) {
    const res = await https.getRegularInvestmentList(userId);
    if (res.code === 0) {
      this.regularInvestmentList = res.data;
    }
  }
}
