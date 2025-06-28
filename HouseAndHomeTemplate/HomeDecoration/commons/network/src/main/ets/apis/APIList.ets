import { AxiosResponse } from '@ohos/axios';
import { axiosInstance } from './HttpRequest';

import {
  DesignerInfo,
  CaseInfo,
  DesignerDetail,
  QueryDesignerParams,
  ReviewInfo,
  OrderDesignerBody,
  CollectionBody,
  CityBody,
  QueryListParams,
  FilterListParams,
  CustomParams,
  AccountPriceBody,
  PriceInfo,
} from '../types/Decoration';

import '../mocks/RequestMock';

// 查询列表
export const queryCaseList = (params?: QueryListParams): Promise<AxiosResponse<Array<CaseInfo>, void>> => {
  const url = '/decoration/list';
  return axiosInstance.get(url, { params });
};

// 查询列表
export const queryFilterCaseList = (params: FilterListParams): Promise<AxiosResponse<Array<CaseInfo>, void>> => {
  const url = '/decoration/filter/list';
  return axiosInstance.get(url, { params });
};


// 热门搜索词
export const querySearchHotkeys = (): Promise<AxiosResponse<Array<string>, void>> => {
  const url = '/decoration/hot-keys';
  return axiosInstance.get(url);
};


// 查询设计师列表
export const queryDesignerList = (params: QueryDesignerParams): Promise<AxiosResponse<Array<DesignerDetail>, void>> => {
  const url = '/decoration/designerList';
  return axiosInstance.get(url, { params });
};

// 查询评论
export const queryReview = (id: number): Promise<AxiosResponse<ReviewInfo, void>> => {
  const url = '/decoration/reviewList';
  return axiosInstance.get(url, { params: { id } });
};


// 预约设计师
export const orderDesigner = (data: OrderDesignerBody): Promise<AxiosResponse<void, OrderDesignerBody>> => {
  const url = '/decoration/order/designer';
  return axiosInstance.post(url, data);
};


// 查询收藏列表
export const queryCollection = (): Promise<AxiosResponse<Array<number>, void>> => {
  const url = '/decoration/collection/list';
  return axiosInstance.get(url);
};


// 添加收藏
export const addCollection = (caseId: number): Promise<AxiosResponse<void, CollectionBody>> => {
  const url = '/decoration/Collection/add';
  const data: CollectionBody = {
    caseId: caseId,
  };
  return axiosInstance.post(url, data);
};


// 取消收藏
export const cancelCollection = (caseId: number): Promise<AxiosResponse<void, CollectionBody>> => {
  const url = '/decoration/Collection';
  const data: CollectionBody = {
    caseId,
  };
  return axiosInstance.delete(url, { data });
};


// 更新城市
export const upDateCity = (city: string): Promise<AxiosResponse<void, CityBody>> => {
  const url = '/decoration/city';
  const data: CityBody = {
    city,
  };
  return axiosInstance.post(url, data);
};


// 获取定制方案
export const queryCustomList = (params: CustomParams): Promise<AxiosResponse<Array<CaseInfo>, void>> => {
  const url = '/decoration/custom/list';
  return axiosInstance.get(url, { params });
};


// 计算价格
export const accountPrice = (data: AccountPriceBody): Promise<AxiosResponse<PriceInfo, AccountPriceBody>> => {
  const url = '/decoration/account/price';
  return axiosInstance.post(url, data);
};




