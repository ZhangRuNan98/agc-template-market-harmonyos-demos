import { https, IHistoricalPerformance, IProductInfo } from 'lib_foundation';
import { RouterMap, RouterModule } from 'module_base';

@ObservedV2
export class HistoricalPerformanceVM {
  private static _instance: HistoricalPerformanceVM;
  @Trace public productInfo: IProductInfo | undefined
  @Trace public historicalPerformanceList: IHistoricalPerformance[] = []

  public static get instance() {
    if (!HistoricalPerformanceVM._instance) {
      HistoricalPerformanceVM._instance = new HistoricalPerformanceVM();
    }
    return HistoricalPerformanceVM._instance;
  }

  init() {
    const param = RouterModule.getNavParam<IProductInfo>({
      url: RouterMap.HISTORICAL_PERFORMANCE,
    });
    if (param) {
      this.productInfo = param
      this.getProductHistoricalPerformanceList(param.id)
    }

  }

  public async getProductHistoricalPerformanceList(id: number) {
    const res = await https.getProductHistoricalPerformanceList(id);
    if (res.code === 0) {
      this.historicalPerformanceList = res.data;
    }
  }
}
