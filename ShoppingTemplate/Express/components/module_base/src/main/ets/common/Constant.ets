import { IAddrInfo } from '../types'

export interface IGoods {
  id: number,
  name: string,
  weight: number,
  volume?: number,
}

export enum RouterMap {
  ORDER_PAGE = 'OrderPage',
  EDIT_ORDER_PAGE = 'EditOrderPage',
  ORDER_INFO_PAGE = 'OrderInfoPage',
  EXPRESS_PAGE = 'ExpressPage',
  GOODS_PAGE = 'GoodsPage',
  TEMPLATE_PAGE = 'TemplatePage',
  PURCHASE_PAGE = 'PurchasePage',
  QUICK_LOGIN_PAGE = 'QuickLoginPage',
  PERSONAL_INFORMATION_PAGE = 'PersonalInformationPage',
  Edit_Name_Page = 'EditNamePage',
  Edit_Phone_Page = 'EditPhonePage',
  SETTING_PAGE = 'SettingPage',
  ADDRESS_PAGE = 'AddressPage',
  EDIT_ADDRESS_PAGE = 'EditAddressPage',
  TEMPLATE_LIST_PAGE = 'TemplateListPage',
  SERVICE_POINT_PAGE = 'ServicePointPage',
  PRIVACY_PAGE = 'PrivacyPage',
  REAL_NAME_AUTH_PAGE = 'RealNameAuthPage',
}

/**
 * AppStorage应用临时缓存映射表
 */
export enum AppStorageMap {
  UI_CONTEXT = 'uiContext',
}

export enum TypeAddressPage {
  NEW = 1,
  EDIT = 2,
}

export enum OrderType {
  ALL = '全部',
  SEND = '寄快递',
  RECEIVE = '收快递',
}

export const goodsList: IGoods[] =
  [
    {
      id: 1,
      name: '文件',
      weight: 1
    },
    {
      id: 2,
      name: '衣服',
      weight: 1
    },
    {
      id: 3,
      name: '发票',
      weight: 1
    },
    {
      id: 4,
      name: '茶叶',
      weight: 1
    },
    {
      id: 5,
      name: '手机',
      weight: 1
    },
    {
      id: 6,
      name: '白酒',
      weight: 1
    },
    {
      id: 7,
      name: '行李',
      weight: 5
    },
    {
      id: 8,
      name: '灯具',
      weight: 2
    }
  ]

export const sendAddressData: IAddrInfo = {
  id: 0,
  name: '请填写寄件人信息',
  cellphone: '',
  province: '支持智能识别文字与图片中的地址',
  city: '',
  area: '',
  detailAddress: '',
  isDefault: false,
}

export const getAddressData: IAddrInfo = {
  id: 0,
  name: '请填写收件人信息',
  cellphone: '',
  province: '支持智能识别文字与图片中的地址',
  city: '',
  area: '',
  detailAddress: '',
  isDefault: false,
}