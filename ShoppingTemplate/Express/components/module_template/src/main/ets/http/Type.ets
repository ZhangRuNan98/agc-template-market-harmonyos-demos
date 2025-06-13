
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

export interface IGoods {
  id: number,
  name: string,
  weight: number,
  volume?: number,
}

export interface ITemplate {
  id: number,
  name: string,
  sendAddress: IAddrInfo,
  getAddress: IAddrInfo,
  goods: IGoods,
  shippingMethod: number,
  paymentMethod: number,
  weight: number,
  time?: string,
}

export interface ISetting {
  text: string,
  value: number,
}