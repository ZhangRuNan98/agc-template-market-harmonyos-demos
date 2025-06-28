import { ProductInfo, ProductSelectionInfo } from '../commons/Types';
import { getProductListMock } from './MockData';

export class ProductDetailApis {
  static _mockList: ProductInfo[] = getProductListMock();

  static getProductDetail(id: string): Promise<ProductInfo> {
    const item = ProductDetailApis._mockList.filter((item) => item.id === id);
    return ProductDetailApis._simulateDelay(item[0], 500);
  }

  static getProductStockInfo(id: string): Promise<ProductSelectionInfo> {
    const item = ProductDetailApis._mockList.filter((item) => item.id === id);
    return ProductDetailApis._simulateDelay(item[0].selectionInfo, 100);
  }

  private static _simulateDelay<T>(data: T, delay: number): Promise<T> {
    return new Promise<T>((resolve) => {
      setTimeout(() => {
        resolve(data);
      }, delay);
    });
  }
}
