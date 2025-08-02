import { IProductItem, ISettingData } from '../types'

export enum chartLabel {
  FixedIncome = '固定收益',
  SevenDayAnnualized = '七日年化'
}

export const product1: IProductItem = {
  id: 1,
  name: '理财1号',
  number: 'ES5214541',
  type: 1,
  redemptionCycle: '快赎1万元，普赎T+1到账',
  annualizedRate: 3.25,
  annualizedCycle: '7日年化',
  saleType: 1,
  tip: '交易所工作日17:00前买入T+1计算收益',
  risk: '低风险',
  title: '周末有理',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product2: IProductItem = {
  id: 2,
  name: '理财2号',
  number: 'EWS521454',
  type: 2,
  redemptionCycle: '快赎1万元，普赎T+1到账',
  annualizedRate: 3.67,
  annualizedCycle: '7日年化',
  saleType: 2,
  tip: '交易所工作日17:00前买入T+1计算收益',
  risk: '中风险',
  title: '回行有理',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product3: IProductItem = {
  id: 3,
  name: '理财3号',
  number: 'EWS521454',
  type: 3,
  redemptionCycle: '普通赎回',
  annualizedRate: 3.35,
  annualizedCycle: '7日年化',
  saleType: 1,
  tip: '稳健运作',
  risk: '中风险',
  title: '日精选',
  minimumPurchaseAmount: 1,
  eachCost: 10,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product4: IProductItem = {
  id: 4,
  name: '理财4号',
  number: 'EWS521454',
  type: 4,
  redemptionCycle: '快赎1万元，普赎T+1到账',
  annualizedRate: 3.49,
  annualizedCycle: '7日年化',
  saleType: 2,
  tip: '稳健运作',
  risk: '高风险',
  title: '周精选',
  minimumPurchaseAmount: 1,
  eachCost: 1000,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product5: IProductItem = {
  id: 5,
  name: '理财5号',
  number: 'EWS521454',
  type: 5,
  redemptionCycle: '快赎1万元，普赎T+1到账',
  annualizedRate: 3.08,
  annualizedCycle: '7日年化',
  saleType: 1,
  tip: '稳健运作',
  risk: '低风险',
  title: '月精选',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product6: IProductItem = {
  id: 6,
  name: '理财6号',
  number: 'EWS521454',
  type: 1,
  redemptionCycle: '快赎1万元，普赎T+1到账',
  annualizedRate: 3.18,
  annualizedCycle: '7日年化',
  saleType: 2,
  tip: '稳健运作',
  risk: '低风险',
  title: '季精选',
  minimumPurchaseAmount: 1,
  eachCost: 10,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product7: IProductItem = {
  id: 7,
  name: '理财7号',
  number: 'EWS521454',
  type: 2,
  redemptionCycle: '快赎1万元，普赎T+1到账',
  annualizedRate: 3.59,
  annualizedCycle: '7日年化',
  saleType: 1,
  tip: '稳健运作',
  risk: '低风险',
  title: '年精选',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product8: IProductItem = {
  id: 8,
  name: '理财8号',
  number: 'EWS521454',
  type: 3,
  redemptionCycle: '快赎1万元，普赎T+1到账',
  annualizedRate: 3.46,
  annualizedCycle: '7日年化',
  saleType: 2,
  tip: '稳健运作',
  risk: '低风险',
  title: '长线精选',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product9: IProductItem = {
  id: 9,
  name: '理财9号',
  number: 'EWS521454',
  type: 3,
  redemptionCycle: '普通赎回',
  annualizedRate: 3.07,
  annualizedCycle: '7日年化',
  saleType: 1,
  tip: '稳健运作',
  risk: '低风险',
  title: '日精选',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product10: IProductItem = {
  id: 10,
  name: '理财10号',
  number: 'EWS521454',
  type: 3,
  redemptionCycle: '普通赎回',
  annualizedRate: 3.66,
  annualizedCycle: '7日年化',
  saleType: 2,
  tip: '稳健运作',
  risk: '低风险',
  title: '日精选',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product11: IProductItem = {
  id: 11,
  name: '理财11号',
  number: 'EWS521454',
  type: 3,
  redemptionCycle: '普通赎回',
  annualizedRate: 3.98,
  annualizedCycle: '7日年化',
  saleType: 1,
  tip: '稳健运作',
  risk: '低风险',
  title: '日精选',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const product12: IProductItem = {
  id: 12,
  name: '理财12号',
  number: 'EWS521454',
  type: 3,
  redemptionCycle: '普通赎回',
  annualizedRate: 3.23,
  annualizedCycle: '7日年化',
  saleType: 2,
  tip: '稳健运作',
  risk: '低风险',
  title: '日精选',
  minimumPurchaseAmount: 1,
  eachCost: 1,
  performanceExplanation: '业绩比较基准：本产品定位为现金，对产品设定的投资目标，不是预期收益率。管理人基于产品性质、投资策略、过往经验等因素对产品设定的投资目标，不是预期收益率，不代表产品的未来表现和实际收益，不构成对产品收益的承诺，投资需谨慎。'
}

export const saleType1: ISettingData = {
  id: 1,
  label: '在售',
  value: 1
}

export const saleType2: ISettingData = {
  id: 2,
  label: '预售',
  value: 2
}

export const minimumPurchaseAmount1: ISettingData = {
  id: 1,
  label: '1',
  value: 1
}

export const minimumPurchaseAmount2: ISettingData = {
  id: 2,
  label: '10',
  value: 2
}

export const minimumPurchaseAmount3: ISettingData = {
  id: 3,
  label: '100',
  value: 3
}


export const minimumPurchaseAmount4: ISettingData = {
  id: 4,
  label: '1000',
  value: 4
}


export const minimumPurchaseAmount5: ISettingData = {
  id: 5,
  label: '1万元',
  value: 5
}

export const riskLevel1: ISettingData = {
  id: 1,
  label: '低风险',
  value: 1
}

export const riskLevel2: ISettingData = {
  id: 2,
  label: '中风险',
  value: 2
}

export const riskLevel3: ISettingData = {
  id: 3,
  label: '高风险',
  value: 3
}

export const arrangement1: ISettingData = {
  id: 1,
  label: '综合排序',
  value: 1
}

export const arrangement2: ISettingData = {
  id: 1,
  label: '收益率优先',
  value: 2
}