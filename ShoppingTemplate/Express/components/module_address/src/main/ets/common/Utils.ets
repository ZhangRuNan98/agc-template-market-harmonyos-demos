import { shippingAddress } from '@kit.AccountKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'module_base';
import { IAddrInfo } from '../http/Type';

const TAG = 'module_address_manage'

/**
 * 通用Utils
 */
export class CommonUtils {
  static assign(target: Object, ...source: Object[]) {
    for (let s of source) {
      for (let key of Object.keys(s)) {
        const value = Reflect.get(s, key) as Object;
        Reflect.set(target, key, value)
      }
    }
  }

  public static async chooseAddress(): Promise<IAddrInfo | null> {
    try {
      const data: shippingAddress.AddressInfo = await shippingAddress.chooseAddress(getContext())
      if (data) {
        const address: IAddrInfo = {
          id: 0,
          name: data.userName,
          cellphone: data.mobileNumber,
          province: data.provinceName,
          city: data.cityName,
          area: data.districtName,
          detailAddress: data.streetName + data.detailedAddress,
          isDefault: false
        }
        return address
      }
      return null
    } catch (error) {
      CommonUtils._dealAllError(error);
    }
    return null
  }

  private static _dealAllError(error: BusinessError): void {
    Logger.error(TAG, `Failed to login, errorCode: ${error.code}, errorMsg: ${error.message}`);
  }
}