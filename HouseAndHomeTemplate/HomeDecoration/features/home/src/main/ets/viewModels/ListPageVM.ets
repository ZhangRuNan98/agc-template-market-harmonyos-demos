import { RouterModule, RouterMap } from 'commonlib';
import { PriceInfo, ProjectItem, accountPrice, AccountPriceBody } from 'network';


@ObservedV2
export class ListPageVM {
  @Trace priceLabels: string[] = ['项目', '工程量', '人工/辅材', '总价'];
  @Trace priceInfo: PriceInfo | undefined = undefined;
  @Trace decorationInfo: AccountPriceBody | undefined = undefined;
  private static _instance: ListPageVM;

  public static get instance() {
    if (!ListPageVM._instance) {
      ListPageVM._instance = new ListPageVM();
    }
    return ListPageVM._instance;
  }


  public async getPriceInfo() {
    if (this.decorationInfo) {
      const res = await accountPrice(this.decorationInfo);
      if (res.status === 200) {
        this.priceInfo = res.data;;
      }
    }
  }


  public getDecorationInfo() {
    const params: AccountPriceBody | undefined = RouterModule.getNavParam<AccountPriceBody>(RouterMap.LIST_PAGE);
    if (params) {
      this.decorationInfo = params;
    }
  }
}