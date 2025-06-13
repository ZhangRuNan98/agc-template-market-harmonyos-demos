import { OrderType, TypeAddressPage } from '../common/Constant';

export interface ParamAddressPage {
  type: TypeAddressPage;
  param?: IAddrInfo;
}

// 寄件/收件人地址信息
export interface IAddrInfo {
  id: number,
  name: string,
  cellphone: string,
  province: string,
  city: string,
  area: string,
  detailAddress: string,
  isDefault: boolean
}

export interface IAddrInfoDetail {
  id: number,
  name: string,
  cellphone: string,
  province: string,
  city: string,
  area: string,
  detailAddress: string,
  isDefault: boolean,
  orderType: OrderType
}

export interface IBuilderType {
  label: string,
  placeholder: string,
  placeholderColor: ResourceStr,
  text: string,
  textColor: ResourceStr,
  isDivider: boolean,
  isTime: boolean,
  func: Function,
}

export interface ISetting {
  text: string,
  value: number,
}

export interface IParam {
  orderId?: number,
  templateId?: number,
}