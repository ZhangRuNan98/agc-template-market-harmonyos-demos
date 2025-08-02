import { RouterMap, RouterModule } from 'module_base';

interface IParamData {
  type: number,
  index: number,
}

@ObservedV2
export class ProductListVM {
  private static _instance: ProductListVM;
  @Trace productType: number = 1
  @Trace currentIndex: number = 0
  @Trace searchText:string = ''

  public static get instance() {
    if (!ProductListVM._instance) {
      ProductListVM._instance = new ProductListVM();
    }
    return ProductListVM._instance;
  }

  init() {
    const param: IParamData | undefined = RouterModule.getNavParam({ url: RouterMap.PRODUCT_LIST })
    if (param) {
      this.productType = param.type
      this.currentIndex = param.index
    }
  }
}
