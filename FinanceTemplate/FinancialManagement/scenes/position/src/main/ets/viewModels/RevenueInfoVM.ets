import { https, IRevenueInfo } from 'lib_foundation';

@ObservedV2
export class RevenueInfoVM {
  private static _instance: RevenueInfoVM;
  @Trace public revenueInfo: IRevenueInfo | undefined

  public static get instance() {
    if (!RevenueInfoVM._instance) {
      RevenueInfoVM._instance = new RevenueInfoVM();
    }
    return RevenueInfoVM._instance;
  }

  init() {
    this.getRevenueInfo(1, 1)
  }

  public async getRevenueInfo(userId: number, id: number) {
    const res = await https.getRevenueInfo(userId, id);
    if (res.code === 0) {
      this.revenueInfo = res.data;
    }
  }

  public getWidth(revenue: number): string {
    if (revenue === 0) {
      return '50%'
    } else {
      return `${50 + revenue}%`
    }
  }
}
