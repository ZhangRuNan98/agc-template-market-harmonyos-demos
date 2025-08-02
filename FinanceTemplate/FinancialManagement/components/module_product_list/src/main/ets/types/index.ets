import { SaleState } from '../common/Constant'

export enum SectionLabel {
  FLEXIBLE_ACCESS = 1,
  FINANCIAL_NIGHT_MARKET = 2
}

export enum ProductType {
  CASH_MANAGEMENT = 1,
  STABLE_LOW_VOLATILITY = 2,
  STABLE_GROWTH = 3,
  STEADY_PROGRESS = 4,
  ENTERPRISING_INVESTMENT = 5,
}

export interface ISettingData {
  id: number,
  label: string,
  value: number,
}

export interface IProductItem {
  id: number, //产品id
  name: string, //产品名称
  number: string, //产品代码
  type: number, //产品类型
  saleType: SaleState, //产品售卖状态
  redemptionCycle: string, //赎回周期
  annualizedRate: number, //收益率
  annualizedCycle: string, //收益周期
  tip: string, //提示
  risk: string, //风险
  title: string, //标题
  minimumPurchaseAmount: number, //最低购买金额
  eachCost: number, //每一份多少钱
  performanceExplanation?: string, //业绩说明
}

export interface IQueryProduct {
  productType?: ProductType,
  sectionLabel?: SectionLabel,
  searchText?: string,
  saleType?: number,
  arrangement?: number,
  risk?: string,
  eachCost?: number,
}