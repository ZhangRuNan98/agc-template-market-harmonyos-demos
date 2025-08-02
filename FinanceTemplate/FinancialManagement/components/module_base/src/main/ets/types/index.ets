export enum SaleState {
  FOR_SALE = 1,
  PRE_SALE = 2,
  SOLD_OUT = 3,
}

export interface UserInfo {
  id: number;
  avatar: string;
  name: string;
  nickname: string;
  sex: string;
  cellphone: string;
  birthday: string;
}

export interface ISettingData {
  id: number,
  label: string,
  value: number,
}

export interface IProfile {
  type: string,
  contract: string,
  information: string,
  managementCompany: string,
  number: string,
  date: string,
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