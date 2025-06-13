import { IAddrInfo } from './Type';
import { CommonUtils } from '../common/Utils';

export class AddrMgtApi {
  static ADDRESS_LIST: IAddrInfo[] = [
    {
      id: 1,
      name: '用户1',
      cellphone: '12345678901',
      province: '江苏省',
      city: '南京市',
      area: '雨花台区',
      detailAddress: 'xx街道xxx小区',
      isDefault: true
    },
    {
      id: 2,
      name: '用户2',
      cellphone: '12345678901',
      province: '江苏省',
      city: '南京市',
      area: '雨花台区',
      detailAddress: 'xx街道xxx小区',
      isDefault: false
    },
  ];

  static getAddressList(): Promise<IAddrInfo[]> {
    return Promise.resolve(AddrMgtApi.ADDRESS_LIST);
  }

  static getAddress(addrId: number): Promise<IAddrInfo | undefined> {
    return Promise.resolve(AddrMgtApi.ADDRESS_LIST.find(v => v.id === addrId));
  }

  static updateAddress(data: IAddrInfo): Promise<boolean> {
    const target = AddrMgtApi.ADDRESS_LIST.find(v => v.id === data.id);
    if (target) {
      CommonUtils.assign(target, data);
    }
    return Promise.resolve(true);
  }

  static deleteAddress(id: number): Promise<boolean> {
    const targetIndex = AddrMgtApi.ADDRESS_LIST.findIndex(v => v.id === id);
    if (targetIndex !== -1) {
      AddrMgtApi.ADDRESS_LIST.splice(targetIndex, 1);
    }
    return Promise.resolve(true);
  }

  static addAddress(data: IAddrInfo): Promise<boolean> {
    data.id = new Date().getTime();
    AddrMgtApi.ADDRESS_LIST.splice(0, 0, data);
    return Promise.resolve(true);
  }
}
