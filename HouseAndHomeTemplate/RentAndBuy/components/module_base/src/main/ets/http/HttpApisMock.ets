import {
  BaseResponse,
  IBasicHouse,
} from '../model/IResponse';
import { MockData } from './MockData';

class HttpApiMock {

  public getNewHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    let resp: BaseResponse<IBasicHouse[]> = {
      code: 0,
      data: MockData.newHouseListByCity.get(city) ?? [],
    };
    return Promise.resolve(resp);
  }

  public getSecondHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    let resp: BaseResponse<IBasicHouse[]> = {
      code: 0,
      data: MockData.secondHouseListByCity.get(city) ?? [],
    };
    return Promise.resolve(resp);
  }

  public getRentHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    let resp: BaseResponse<IBasicHouse[]> = {
      code: 0,
      data: MockData.rentHouseListByCity.get(city) ?? [],
    };
    return Promise.resolve(resp);
  }
}

const httpsMock = new HttpApiMock();

export { httpsMock };
