import { IProductItem, ISettingData } from '../types'
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
  saleType1,
  saleType2,
  minimumPurchaseAmount1,
  minimumPurchaseAmount2,
  minimumPurchaseAmount3,
  minimumPurchaseAmount4,
  minimumPurchaseAmount5,
  riskLevel1,
  riskLevel2,
  riskLevel3,
  arrangement1,
  arrangement2,
} from 'module_base'

export class ProductListDatasetMock {
  public static productList: IProductItem[] = [
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
    product9]
  public static saleTypeList: ISettingData[] = [saleType1, saleType2]

  public static getSelectSaleTypeList() {
    const selectSaleTypeList: SelectOption[] = []
    const saleTypeList: ISettingData[] = [saleType1, saleType2]
    saleTypeList.forEach((item) => {
      const data: SelectOption = {
        value: item.label
      }
      selectSaleTypeList.push(data)
    })
    return selectSaleTypeList
  }

  public static minimumPurchaseAmountList: ISettingData[] = [
    minimumPurchaseAmount1,
    minimumPurchaseAmount2,
    minimumPurchaseAmount3,
    minimumPurchaseAmount4,
    minimumPurchaseAmount5
  ]
  public static riskLevelList: ISettingData[] = [riskLevel1, riskLevel2, riskLevel3]
  public static arrangementList: ISettingData[] = [arrangement1, arrangement2]

  public static getSelectArrangementList() {
    const selectArrangementList: SelectOption[] = []
    const arrangementList: ISettingData[] = [arrangement1, arrangement2]
    arrangementList.forEach((item) => {
      const data: SelectOption = {
        value: item.label
      }
      selectArrangementList.push(data)
    })
    return selectArrangementList
  }
}
