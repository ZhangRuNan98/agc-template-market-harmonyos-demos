import { IOrder } from 'common';
import { BaseResponse } from '../types/BaseResponse';
import {
  AddCommonAddressesRequest,
  AddNewLicenseNumberRequest,
  DeleteCommonAddressesRequest,
  DeleteOldLicenseNumberRequest,
  DeleteOrderRequest,
  QueryParkingRequest,
  SetDefaultLicenseNumberRequest,
  UpdateCommonAddressesRequest,
} from '../types/AxiosRequestParam';
import { payParkingMock } from './mockData/PayParkingMockData';
import { UserLoginResp } from '../types/responseTypes/UserLoginResp';
import { GetUserInfoResp } from '../types/responseTypes/GetUserInfoResp';
import { AssociateAccountResp } from '../types/responseTypes/AssociateAccountResp';
import { DisassociateAccountResp } from '../types/responseTypes/DiassociateAccountResp';
import { GetHomePageBannerResp } from '../types/responseTypes/GetHomePageBannerResp';
import { AllLicenseInfoResp } from '../types/responseTypes/AllLicenseNumbersResp';
import { GetDefaultLicenseNumberResp } from '../types/responseTypes/GetDefaultLicenseNumberResp';
import { AllOrderResp } from '../types/responseTypes/AllOrderResp';
import { PayParkingResp } from '../types/responseTypes/PayParkingResp';
import { allOrderNormalMock, allOrderNullErrorMock, MAP_ORDER } from './mockData/AllOrderData';
import { userLoginMock } from './mockData/UserLoginData';
import { getUserInfoMock } from './mockData/GetUserInfoData';
import { associateAccountMock } from './mockData/AssociateAccountMockData';
import { getHomePageBannerMock } from './mockData/GetHomePageBannerData';
import { allLicenseInfoMock } from './mockData/AllLicenseInfoData';
import { getDefaultLicenseNumberMock } from './mockData/GetDefaultLicenseNumberData';
import { SetDefaultLicenseNumberResp } from '../types/responseTypes/SetDefaultLicenseNumberResp';
import { setDefaultLicenseNumberMock } from './mockData/SetDefaultLicenseNumberData';
import { AllCommonAddressesResp } from '../types/responseTypes/AllCommonAddressesResp';
import { allCommonAddressesMock } from './mockData/AllCommonAddressesData';
import { GetParkingDetailResp } from '../types/responseTypes/GetParkingDetailResp';
import { getParkingDetailMock } from './mockData/GetParkingDetailData';

class HttpsApiMock {
  /** 用户登录信息 **/
  public userLogin(): Promise<BaseResponse<UserLoginResp>> {
    return Promise.resolve(userLoginMock);
  }

  /** 获取用户信息 **/
  public getUserInfo(): Promise<BaseResponse<GetUserInfoResp>> {
    return Promise.resolve(getUserInfoMock);
  }

  /** 关联用户账号 **/
  public associateAccount(): Promise<BaseResponse<AssociateAccountResp>> {
    return Promise.resolve(associateAccountMock);
  }

  /** 关联用户账号 **/
  public disassociateAccount(): Promise<BaseResponse<DisassociateAccountResp>> {
    return Promise.resolve(associateAccountMock);
  }

  /** 获取首页banner图 **/
  public getHomePageBanner(): Promise<BaseResponse<GetHomePageBannerResp>> {
    return Promise.resolve(getHomePageBannerMock);
  }

  /** 获取所有车牌号 **/
  public getLicenseNumbers(): Promise<BaseResponse<AllLicenseInfoResp>> {
    return Promise.resolve(allLicenseInfoMock);
  }

  /** 获取默认车牌 **/
  public getDefaultLicenseNumber(): Promise<BaseResponse<GetDefaultLicenseNumberResp>> {
    return Promise.resolve(getDefaultLicenseNumberMock);
  }

  /** 修改默认车牌 **/
  public setDefaultLicenseNumber(data: SetDefaultLicenseNumberRequest):
    Promise<BaseResponse<SetDefaultLicenseNumberResp>> {
    setDefaultLicenseNumberMock.data.default = data.new;
    return Promise.resolve(setDefaultLicenseNumberMock);
  }

  /** 添加新车牌 **/
  public addNewLicenseNumber(data: AddNewLicenseNumberRequest): Promise<BaseResponse<AllLicenseInfoResp>> {
    allLicenseInfoMock.data.licenses.push(data.new);
    return Promise.resolve(allLicenseInfoMock);
  }

  /** 删除旧车牌 **/
  public deleteOldLicenseNumber(params: DeleteOldLicenseNumberRequest): Promise<BaseResponse<AllLicenseInfoResp>> {
    allLicenseInfoMock.data.licenses = allLicenseInfoMock.data.licenses.filter(item => item === params.old);
    return Promise.resolve(allLicenseInfoMock);
  }

  /** 查询入场订单 **/
  public queryParking(params: QueryParkingRequest): Promise<BaseResponse<AllOrderResp>> {
    const array = MAP_ORDER.get(params.license);
    if (array) {
      const index = array.findIndex(order => {
        if (order.status !== '2') {
          const timeDifference = (order?.end ?? Date.now()) - order.start;
          // ¥1/15min
          const fee = Math.floor(timeDifference / (15 * 60 * 1000));
          order.cost = fee;
          allOrderNormalMock.data.info = [order];
          return true;
        }
        return false;
      });
      if (index !== -1) {
        return Promise.resolve(allOrderNormalMock);
      }
    }
    return Promise.resolve(allOrderNullErrorMock);
  }

  /** 支付入场订单 **/
  public payParking(): Promise<BaseResponse<PayParkingResp>> {
    payParkingMock.data.mercNo = 'xxx';
    payParkingMock.data.orderStr = 'xxx';
    payParkingMock.data.timestamp = Date.now().toString();
    return Promise.resolve(payParkingMock);
  }

  /** 查询所有订单 **/
  public getAllOrder(): Promise<BaseResponse<AllOrderResp>> {
    const array: IOrder[] = [];
    for (let item of MAP_ORDER) {
      item[1].forEach(order => {
        if (order.status === '2') {
          const timeDifference = (order?.end ?? Date.now()) - order.start;
          // ¥1/15min
          const fee = Math.floor(timeDifference / (15 * 60 * 1000));
          order.cost = fee;
          array.push(order);
        }
      });
    }
    allOrderNormalMock.data.info = array;
    return Promise.resolve(allOrderNormalMock);
  }

  /** 删除指定订单 **/
  public deleteOrder(params: DeleteOrderRequest): Promise<BaseResponse<AllOrderResp>> {
    const array: IOrder[] = [];
    for (let item of MAP_ORDER) {
      const index = item[1].findIndex(order => order.orderId === params.id);
      if (index !== -1) {
        item[1].splice(index, 1);
      }
      item[1].forEach(order => {
        if (order.status === '2') {
          const timeDifference = (order?.end ?? Date.now()) - order.start;
          // ¥1/15min
          const fee = Math.floor(timeDifference / (15 * 60 * 1000));
          order.cost = fee;
          array.push(order);
        }
      });
    }
    allOrderNormalMock.data.info = array;
    return Promise.resolve(allOrderNormalMock);
  }

  /** 获取常用地址 **/
  public getCommonAddresses(): Promise<BaseResponse<AllCommonAddressesResp>> {
    return Promise.resolve(allCommonAddressesMock);
  }

  /** 新增常用地址 **/
  public addCommonAddresses(data: AddCommonAddressesRequest): Promise<BaseResponse<AllCommonAddressesResp>> {
    allCommonAddressesMock.data.addresses.push({
      siteId: data.siteId,
      name: data.name,
      addr: data.addr,
      location: data.location,
      type: data.type,
    });
    return Promise.resolve(allCommonAddressesMock);
  }

  /** 更新常用地址 **/
  public updateCommonAddresses(data: UpdateCommonAddressesRequest): Promise<BaseResponse<AllCommonAddressesResp>> {
    if (data.oldSiteId !== '') {
      allCommonAddressesMock.data.addresses.findIndex(item => {
        if (item.siteId === data.oldSiteId) {
          item.siteId = data.siteId;
          item.name = data.name;
          item.addr = data.addr;
          item.location = data.location;
          return true;
        }
        return false;
      });
    } else {
      allCommonAddressesMock.data.addresses.findIndex(item => {
        if (item.type === data.type) {
          item.siteId = data.siteId;
          item.name = data.name;
          item.addr = data.addr;
          item.location = data.location;
          return true;
        }
        return false;
      });
    }
    return Promise.resolve(allCommonAddressesMock);
  }

  /** 删除常用地址 **/
  public deleteCommonAddresses(params: DeleteCommonAddressesRequest): Promise<BaseResponse<AllCommonAddressesResp>> {
    allCommonAddressesMock.data.addresses =
      allCommonAddressesMock.data.addresses.filter(item => item.siteId !== params.siteId);
    return Promise.resolve(allCommonAddressesMock);
  }

  /** 获取停车场详情 **/
  public getParkingDetail(): Promise<BaseResponse<GetParkingDetailResp>> {
    return Promise.resolve(getParkingDetailMock);
  }
}

const httpsMock = new HttpsApiMock();

export { httpsMock };