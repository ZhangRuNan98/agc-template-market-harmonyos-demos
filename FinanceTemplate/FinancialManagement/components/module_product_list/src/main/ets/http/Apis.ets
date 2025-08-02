import { IProductItem, IQueryProduct, ISettingData, SectionLabel } from '../types';
import { ProductListDatasetMock } from './MockData';
import {
  product1,
  product10,
  product11,
  product12,
  product2,
  product3,
  product4,
  product5,
  product6,
  product7,
  product8,
  product9,
} from 'module_base'


export class ProductListApis {
  static productList:IProductItem[] = ProductListDatasetMock.productList
  static saleTypeList: ISettingData[] = ProductListDatasetMock.saleTypeList;
  static minimumPurchaseAmountList: ISettingData[] = ProductListDatasetMock.minimumPurchaseAmountList;
  static riskLevelList: ISettingData[] = ProductListDatasetMock.riskLevelList;
  static arrangementList: ISettingData[] = ProductListDatasetMock.arrangementList;
  static selectArrangementList: SelectOption[] = ProductListDatasetMock.getSelectArrangementList();
  static selectSaleTypeList: SelectOption[] = ProductListDatasetMock.getSelectSaleTypeList();

  public static getProductList(data: IQueryProduct) {
    if (data.sectionLabel === SectionLabel.FLEXIBLE_ACCESS) {
      const productList: IProductItem[] = [product1, product2];
      return productList
    }
    if (data.sectionLabel === SectionLabel.FINANCIAL_NIGHT_MARKET) {
      const productList: IProductItem[] = [product3, product4, product5, product6, product7, product8];
      return productList
    }
    if (data.searchText) {
      const productList = ProductListApis.productList.filter((item) => {
        return item.name.includes(data.searchText as string)
      })
      return productList
    }
    if (data) {
      const productList = ProductListApis.productList.filter((item) => {
        return item.type === data.productType
      })
        .filter((item) => {
          return item.saleType === data.saleType
        })
        .filter((item) => {
          if (data.eachCost) {
            return item.minimumPurchaseAmount === data.eachCost
          }
          return item.minimumPurchaseAmount >= 1
        })
        .filter((item) => {
          if (data.risk) {
            return item.risk === data.risk
          }
          return item.risk === item.risk
        })
      if (data.arrangement === 2) {
        productList.sort((a, b) => {
          return b.annualizedRate - a.annualizedRate
        })
      }
      return productList
    }
    return ProductListApis.productList
  }
}
