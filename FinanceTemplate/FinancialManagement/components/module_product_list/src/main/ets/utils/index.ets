import { ISettingData } from '../types'
import { SaleState } from '../common/Constant'

export function getValue(arr: ISettingData[], label: string): number {
  const saleType = arr.find((item) => {
    return item.label === label
  })
  if (saleType) {
    return saleType.value
  }
  return 1
}

export function getLabel(arr: ISettingData[], value: number): string {
  const saleType = arr.find((item) => {
    return item.value === value
  })
  if (saleType) {
    return saleType.label
  }
  return ''
}

export function getProductSaleType(value: number): string {
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