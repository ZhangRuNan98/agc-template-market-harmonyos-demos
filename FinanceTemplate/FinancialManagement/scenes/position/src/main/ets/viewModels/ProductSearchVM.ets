import { https, IProductItem } from 'lib_foundation';

@ObservedV2
export class ProductSearchVM {
  private static _instance: ProductSearchVM;
  @Trace public total: number = 0
  @Trace public productList: IProductItem[] = []
  @Trace public searchText: string = ''

  public static get instance() {
    if (!ProductSearchVM._instance) {
      ProductSearchVM._instance = new ProductSearchVM();
    }
    return ProductSearchVM._instance;
  }

  search(value: string) {
    this.getProductList(value)
  }

  clear() {
    this.total = 0
    this.productList = []
    this.searchText = ''
  }

  public async getProductList(searchText: string) {
    const res = await https.getProductList({ searchText: searchText });
    if (res.code === 0) {
      this.productList = res.data;
    }
  }
}
