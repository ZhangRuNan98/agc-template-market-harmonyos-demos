import { SaleState } from '../common/Constant';
import { ProductListApis } from '../http/Apis';
import { IProductItem, ISettingData } from '../types';

@ObservedV2
export class ProductListVM {
  private static _instance: ProductListVM;
  // 接口数据
  @Trace public productList: IProductItem[] = []
  @Trace public saleTypeList: ISettingData[] = ProductListApis.saleTypeList
  @Trace public minimumPurchaseAmountList: ISettingData[] = ProductListApis.minimumPurchaseAmountList
  @Trace public riskLevelList: ISettingData[] = ProductListApis.riskLevelList
  @Trace public arrangementList: ISettingData[] = ProductListApis.arrangementList
  //页面数据
  @Trace public selectSaleTypeList: SelectOption[] = ProductListApis.selectSaleTypeList
  @Trace public selectArrangementList: SelectOption[] = ProductListApis.selectArrangementList
  @Trace public currentIndex: number = 0
  @Trace public selectedIndex: number = 0
  @Trace public searchText: string = ''
  @Trace public saleType: number = 1
  @Trace public tempSaleType: number = 1
  @Trace public minimumPurchaseAmount: number = 1
  @Trace public tempMinimumPurchaseAmount: number = 1
  @Trace public riskLevel: number = 1
  @Trace public tempRiskLevel: number = 1
  @Trace public productType: number = 1
  @Trace public arrangement: number = 1
  @Trace public isSelecting: boolean = false

  public static get instance() {
    if (!ProductListVM._instance) {
      ProductListVM._instance = new ProductListVM();
    }
    return ProductListVM._instance;
  }

  init() {
    this.getProductList(this.productType, this.saleType, this.arrangement)
  }

  clear() {
    this.selectSaleTypeList = []
    this.selectArrangementList = []
    this.currentIndex = 0
    this.selectedIndex = 0
    this.searchText = ''
    this.saleType = 1
    this.minimumPurchaseAmount = 1
    this.riskLevel = 1
    this.productType = 1
    this.arrangement = 1
  }

  refresh(productType: number) {
    this.minimumPurchaseAmount = 1
    this.riskLevel = 1
    this.productType = productType + 1
    this.isSelecting = false
    this.getProductList(this.productType, this.saleType, this.arrangement)
  }

  search() {
    this.getProductList(this.productType, this.saleType, this.arrangement)
  }

  filter() {
    const risk = this.getLabel(this.riskLevelList, this.riskLevel)
    this.getProductList(this.productType, this.saleType, this.arrangement, risk, this.minimumPurchaseAmount)
  }

  reset() {
    this.saleType = 1
    this.minimumPurchaseAmount = 1
    this.riskLevel = 1
    this.search()
  }

  public getProductList(type: number, saleType?: number, arrangement?: number, risk?: string, eachCost?: number) {
    const res = ProductListApis.getProductList({
      productType: type,
      saleType,
      arrangement,
      risk,
      eachCost,
    });
    this.productList = res
  }

  public getValue(arr: ISettingData[], label: string): number {
    const saleType = arr.find((item) => {
      return item.label === label
    })
    if (saleType) {
      return saleType.value
    }
    return 1
  }

  public getLabel(arr: ISettingData[], value: number): string {
    const saleType = arr.find((item) => {
      return item.value === value
    })
    if (saleType) {
      return saleType.label
    }
    return ''
  }

  public getIsYieldPriority(text: string): boolean {
    switch (text) {
      case '综合排序':
        return false
      case '收益率优先':
        return true
      default:
        return false
    }
  }

  public getProductSaleType(value: number): string {
    switch (value) {
      case SaleState.PRE_SALE:
        return '预售'
      case SaleState.FOR_SALE:
        return '在售'
      case SaleState.SOLD_OUT:
        return '售罄'
      default:
        return '售罄'
    }
  }
}
