import { AxiosRequestHeaders } from '@ohos/axios';
import { RequestUrl } from '../constant/Enum';
import request from '../model/AxiosRequest';
import { BaseResponse, IBasicHouse } from '../model/IResponse';

class HttpApi {
  public getNewHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    return request.post({
      url: RequestUrl.NEW_LIST,
      headers: {} as AxiosRequestHeaders,
      data: city,
    });
  }

  public getRentHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    return request.post({
      url: RequestUrl.RENT_LIST,
      headers: {} as AxiosRequestHeaders,
      data: city,
    });
  }

  public getSecondHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    return request.post({
      url: RequestUrl.SECOND_LIST,
      headers: {} as AxiosRequestHeaders,
      data: city,
    });
  }
}

const https = new HttpApi();

export { https };