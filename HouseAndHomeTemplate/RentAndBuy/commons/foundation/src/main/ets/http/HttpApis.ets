import { AxiosRequestHeaders } from '@ohos/axios';
import { HouseType, RequestUrl } from '../constants/Enum';
import request from '../model/AxiosRequest';
import { CityList } from '../model/Index';
import {
  IFavoriteRequest,
  IHistoryDeleteRequest,
  IHistoryRequest,
  IHouseListRequest,
  ISearchRequest,
} from '../model/IRequest';
import { BaseResponse, IBasicHouse, INewHouseDetail, IRentHouseDetail, ISecondHouseDetail } from '../model/IResponse';

class HttpApi {
  public updateCitySelected(city: string): Promise<BaseResponse<undefined>> {
    return request.post({ url: RequestUrl.CITY_UPDATE, headers: {} as AxiosRequestHeaders, data: city });
  }

  public getHotHouseList(param: IHouseListRequest): Promise<BaseResponse<IBasicHouse[]>> {
    return request.post({
      url: RequestUrl.HOT_HOUSE_LIST,
      headers: {} as AxiosRequestHeaders,
      data: param,
    });
  }

  public getNewHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    return request.post({
      url: RequestUrl.NEW_LIST,
      headers: {} as AxiosRequestHeaders,
      data: city,
    });
  }

  public getNewHouseDetail(houseId: string): Promise<BaseResponse<INewHouseDetail>> {
    return request.post({
      url: RequestUrl.NEW_DETAIL,
      headers: {} as AxiosRequestHeaders,
      data: houseId,
    });
  }

  public getRentHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    return request.post({
      url: RequestUrl.RENT_LIST,
      headers: {} as AxiosRequestHeaders,
      data: city,
    });
  }

  public getRentHouseDetail(houseId: string): Promise<BaseResponse<IRentHouseDetail>> {
    return request.post({
      url: RequestUrl.RENT_DETAIL,
      headers: {} as AxiosRequestHeaders,
      data: houseId,
    });
  }

  public getSecondHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    return request.post({
      url: RequestUrl.SECOND_LIST,
      headers: {} as AxiosRequestHeaders,
      data: city,
    });
  }

  public getSecondHouseDetail(houseId: string): Promise<BaseResponse<ISecondHouseDetail>> {
    return request.post({
      url: RequestUrl.SECOND_DETAIL,
      headers: {} as AxiosRequestHeaders,
      data: houseId,
    });
  }

  public updateRecentCityList(city: string): Promise<BaseResponse<undefined>> {
    return request.post({
      url: RequestUrl.UPDATE_RECENT_CITY,
      headers: {} as AxiosRequestHeaders,
      data: city,
    });
  }

  public getRecentCityList(): Promise<BaseResponse<CityList>> {
    return request.post({
      url: RequestUrl.RECENT_CITY_LIST,
      headers: {} as AxiosRequestHeaders,
    });
  }

  public getCurrentCity(): Promise<BaseResponse<string>> {
    return request.post({
      url: RequestUrl.CURRENT_CITY,
      headers: {} as AxiosRequestHeaders,
    });
  }

  public updateCurrentCity(city: string): Promise<BaseResponse<undefined>> {
    return request.post({
      url: RequestUrl.UPDATE_CURRENT_CITY,
      headers: {} as AxiosRequestHeaders,
      data: city,
    });
  }

  public aggregatedHouseSearch(param: ISearchRequest): Promise<BaseResponse<IBasicHouse[]>> {
    return request.post({
      url: RequestUrl.HOUSE_SEARCH,
      headers: {} as AxiosRequestHeaders,
      data: param,
    });
  }

  public updateFavorite(param: IFavoriteRequest): Promise<BaseResponse<undefined>> {
    return request.post({
      url: RequestUrl.HOUSE_FAVORITE,
      headers: {} as AxiosRequestHeaders,
      data: param,
    });
  }

  public recordHistory(param: IHistoryRequest): Promise<BaseResponse<undefined>> {
    return request.post({
      url: RequestUrl.HISTORY_ADD,
      headers: {} as AxiosRequestHeaders,
      data: param,
    });
  }

  public queryHistoryList(type: HouseType): Promise<BaseResponse<Map<string, IBasicHouse[]>>> {
    return request.post({
      url: RequestUrl.HISTORY_QUERY,
      headers: {} as AxiosRequestHeaders,
      data: type,
    });
  }

  public deleteHistory(param: IHistoryDeleteRequest): Promise<BaseResponse<Map<string, IBasicHouse[]>>> {
    return request.post({
      url: RequestUrl.HISTORY_DELETE,
      headers: {} as AxiosRequestHeaders,
      data: param,
    });
  }
}

const https = new HttpApi();

export { https };