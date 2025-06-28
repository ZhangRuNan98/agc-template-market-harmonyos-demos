import { ProductCardItem, ProductListResp } from '../commons/Types';
import { MOCK_PRODUCT_LIST } from './MockData';

export class ProductWaterFlowApis {
  private static _requestCount: number = 0;

  public static getProductList(): Promise<ProductListResp> {
    const res: ProductListResp = {
      isFinal: ProductWaterFlowApis._mockMultiData(),
      list: MOCK_PRODUCT_LIST,
    };
    return ProductWaterFlowApis._simulateDelay(res, 500);
  }

  public static getProductListByCategoryId(
    id: string,
  ): Promise<ProductListResp> {
    const res: ProductListResp = {
      isFinal: ProductWaterFlowApis._mockMultiData(),
      list: MOCK_PRODUCT_LIST,
    };
    return ProductWaterFlowApis._simulateDelay(res, 500);
  }

  public static getProductListByKeywords(
    words: string,
  ): Promise<ProductListResp> {
    const list: ProductCardItem[] =
      words.length ? MOCK_PRODUCT_LIST.filter((item) => item.title.includes(words)) : MOCK_PRODUCT_LIST;
    const res: ProductListResp = {
      isFinal: ProductWaterFlowApis._mockMultiData(),
      list,
    };
    return ProductWaterFlowApis._simulateDelay(res, 500);
  }

  private static _mockMultiData() {
    ProductWaterFlowApis._requestCount++;
    const isFinal = ProductWaterFlowApis._requestCount > 2;
    if (isFinal) {
      ProductWaterFlowApis._requestCount = 0;
    }
    return isFinal;
  }

  private static _simulateDelay<T>(data: T, delay: number): Promise<T> {
    return new Promise<T>((resolve) => {
      setTimeout(() => {
        resolve(data);
      }, delay);
    });
  }
}
