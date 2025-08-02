import { httpsMock } from './HttpRequestApiMock';
import { promptAction } from '@kit.ArkUI';
import { CommonConstants, FullLoading, Logger } from 'common';
import { BaseResponse } from '../types/BaseResponse';
import { RequestUrl } from './Constants';
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

export async function replaceMockData(url: string | undefined, args: Object): Promise<Object | string> {
  let response: BaseResponse | undefined = undefined;
  switch (url) {
    case RequestUrl.URL_USER_LOGIN:
      response = await httpsMock.userLogin();
      break;
    case RequestUrl.URL_USER_INFO:
      response = await httpsMock.getUserInfo();
      break;
    case RequestUrl.URL_USER_ASSOCIATE:
      response = await httpsMock.associateAccount();
      break;
    case RequestUrl.URL_USER_DISASSOCIATE:
      response = await httpsMock.disassociateAccount();
      break;
    case RequestUrl.URL_ADDRESS_GET:
      response = await httpsMock.getCommonAddresses();
      break;
    case RequestUrl.URL_ADDRESS_ADD:
      response = await httpsMock.addCommonAddresses(args as AddCommonAddressesRequest);
      break;
    case RequestUrl.URL_ADDRESS_UPDATE:
      response = await httpsMock.updateCommonAddresses(args as UpdateCommonAddressesRequest);
      break;
    case RequestUrl.URL_ADDRESS_DELETE:
      response = await httpsMock.deleteCommonAddresses(args as DeleteCommonAddressesRequest);
      break;
    case RequestUrl.URL_LICENSE_LIST:
      response = await httpsMock.getLicenseNumbers();
      break;
    case RequestUrl.URL_LICENSE_DEFAULT_GET:
      response = await httpsMock.getDefaultLicenseNumber();
      break;
    case RequestUrl.URL_LICENSE_DEFAULT_SET:
      response = await httpsMock.setDefaultLicenseNumber(args as SetDefaultLicenseNumberRequest);
      break;
    case RequestUrl.URL_LICENSE_ADD:
      response = await httpsMock.addNewLicenseNumber(args as AddNewLicenseNumberRequest);
      break;
    case RequestUrl.URL_LICENSE_DELETE:
      response = await httpsMock.deleteOldLicenseNumber(args as DeleteOldLicenseNumberRequest);
      break;
    case RequestUrl.URL_ORDER_QUERY:
      response = await httpsMock.queryParking(args as QueryParkingRequest);
      break;
    case RequestUrl.URL_ORDER_PAY:
      response = await httpsMock.payParking();
      break;
    case RequestUrl.URL_ORDER_LIST:
      response = await httpsMock.getAllOrder();
      break;
    case RequestUrl.URL_ORDER_DELETE:
      response = await httpsMock.deleteOrder(args as DeleteOrderRequest);
      break;
    case RequestUrl.URL_BANNER_GET:
      response = await httpsMock.getHomePageBanner();
      break;
    case RequestUrl.URL_DETAIL_GET:
      response = await httpsMock.getParkingDetail();
      break;
    default:
      return mockErrorHandler('cannot find url.');
  }
  if (response) {
    const delayResponse: BaseResponse = await simulateDelay(response, CommonConstants.SIMULATE_DELAY);
    FullLoading.hideLoading();
    return Promise.resolve(delayResponse);
  }
  return mockErrorHandler('cannot find mock function.');
}

function simulateDelay<T>(data: T, delay: number): Promise<T> {
  return new Promise<T>((resolve) => {
    setTimeout(() => {
      resolve(data);
    }, delay);
  });
}

function mockErrorHandler(msg?: string): Promise<string> {
  const errMsg: string = 'replace mock data failed!';
  FullLoading.hideLoading();
  promptAction.showToast({ message: errMsg });
  Logger.error('[MockRequest]', msg ?? '', errMsg);
  return Promise.reject(errMsg);
}