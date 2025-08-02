import { City, HouseType } from '../constants/Enum';
import { CityList, History } from '../model/Index';
import {
  IFavoriteRequest,
  IHistoryDeleteRequest,
  IHistoryRequest,
  IHouseListRequest,
  ISearchRequest,
} from '../model/IRequest';
import {
  BaseResponse,
  IBasicHouse,
  INewHouseDetail,
  IRentHouseDetail,
  ISecondHouseDetail,
} from '../model/IResponse';
import { AppStorageBank } from '../util/AppStorageBank';
import { MockData } from './MockData';

class HttpApiMock {
  public getHotHouseList(param: IHouseListRequest): Promise<BaseResponse<IBasicHouse[]>> {
    let houseListMap = MockData.hotHouseListByCity.get(param.city) ?? MockData.hotHouseListByCity.get(City.NANJING);
    let queryResp: BaseResponse<IBasicHouse[]> = {
      code: 0,
      data: houseListMap?.get(param.type) ?? [],
    };
    return Promise.resolve(queryResp);
  }

  public getNewHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    let queryResp: BaseResponse<IBasicHouse[]> = {
      code: 0,
      data: MockData.newHouseListByCity.get(city) ?? [],
    };
    return Promise.resolve(queryResp);
  }

  public getSecondHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    let queryResp: BaseResponse<IBasicHouse[]> = {
      code: 0,
      data: MockData.secondHouseListByCity.get(city) ?? [],
    };
    return Promise.resolve(queryResp);
  }

  public getRentHouseList(city: string): Promise<BaseResponse<IBasicHouse[]>> {
    let queryResp: BaseResponse<IBasicHouse[]> = {
      code: 0,
      data: MockData.rentHouseListByCity.get(city) ?? [],
    };
    return Promise.resolve(queryResp);
  }

  public getNewHouseDetail(houseId: string): Promise<BaseResponse<INewHouseDetail | undefined>> {
    let item = MockData.newHouseDetails.find((item: INewHouseDetail) => item.house.houseId === houseId);
    let queryResp: BaseResponse<INewHouseDetail | undefined> = {
      code: 0,
      data: item,
    };

    return Promise.resolve(queryResp);
  }

  public getSecondHouseDetail(houseId: string): Promise<BaseResponse<ISecondHouseDetail | undefined>> {
    let item = MockData.secondHouseDetails.find((item: ISecondHouseDetail) => item.house.houseId === houseId);
    let resp: BaseResponse<ISecondHouseDetail | undefined> = {
      code: 0,
      data: item,
    };

    return Promise.resolve(resp);
  }

  public getRentHouseDetail(houseId: string): Promise<BaseResponse<IRentHouseDetail | undefined>> {
    let item = MockData.rentHouseDetails.find((item: IRentHouseDetail) => item.house.houseId === houseId);
    let resp: BaseResponse<IRentHouseDetail | undefined> = {
      code: 0,
      data: item,
    };

    return Promise.resolve(resp);
  }

  public updateRecentCityList(city: string): Promise<BaseResponse<undefined>> {
    AppStorageBank.setCityList(city);
    let resp: BaseResponse<undefined> = {
      code: 0,
      data: undefined,
    };
    return Promise.resolve(resp);
  }

  public getRecentCityList(): Promise<BaseResponse<CityList>> {
    let resp: BaseResponse<CityList> = {
      code: 0,
      data: AppStorageBank.getCityList(),
    };
    return Promise.resolve(resp);
  }

  public getCurrentCity(): Promise<BaseResponse<String>> {
    let resp: BaseResponse<String> = {
      code: 0,
      data: AppStorageBank.getCurrentCity(),
    };
    return Promise.resolve(resp);
  }

  public updateCurrentCity(city: string): Promise<BaseResponse<undefined>> {
    AppStorageBank.setCurrentCity(city);
    let resp: BaseResponse<undefined> = {
      code: 0,
      data: undefined,
    };
    return Promise.resolve(resp);
  }

  public aggregatedHouseSearch(param: ISearchRequest): Promise<BaseResponse<IBasicHouse[]>> {
    let collection = [...MockData.newHouseList, ...MockData.secondHouseList, ...MockData.rentHouseList];
    let houses: IBasicHouse[] = param.type ? collection.filter((item: IBasicHouse) => item.type === param.type &&
      (item.title.includes(param.keyword) || item.cell.includes(param.keyword) || item.area.includes(param.keyword))) ??
      [] :
      collection.filter((item: IBasicHouse) =>
      item.title.includes(param.keyword) || item.cell.includes(param.keyword) || item.area.includes(param.keyword)) ??
        [];
    let resp: BaseResponse<IBasicHouse[]> = {
      code: 0,
      data: houses,
    };
    return Promise.resolve(resp);
  }

  public updateFavorite(param: IFavoriteRequest): Promise<BaseResponse<undefined>> {
    if (param.type === HouseType.NEW) {
      MockData.newHouseDetails = MockData.newHouseDetails.map((item: INewHouseDetail) => {
        if (item.house.houseId === param.houseId) {
          item.house.favorite === 0 ? item.house.favorite = 1 : item.house.favorite = 0;
          return item;
        } else {
          return item;
        }
      });

      let targetIndex: number = 0;
      MockData.newHouseList = MockData.newHouseList.map((item: IBasicHouse, index: number) => {
        if (item.houseId === param.houseId) {
          item.favorite === 0 ? item.favorite = 1 : item.favorite = 0;
          targetIndex = index;
          return item;
        } else {
          return item;
        }
      });

      let targetHouse = MockData.newHouseList.splice(targetIndex, 1);
      MockData.newHouseList.unshift(...targetHouse);
      MockData.hotHouseListMap.set(HouseType.NEW, MockData.newHouseList);
    } else if (param.type === HouseType.SECOND) {
      MockData.secondHouseDetails = MockData.secondHouseDetails.map((item: ISecondHouseDetail) => {
        if (item.house.houseId === param.houseId) {
          item.house.favorite === 0 ? item.house.favorite = 1 : item.house.favorite = 0;
          return item;
        } else {
          return item;
        }
      });

      let targetIndex: number = 0;
      MockData.secondHouseList = MockData.secondHouseList.map((item: IBasicHouse, index: number) => {
        if (item.houseId === param.houseId) {
          item.favorite === 0 ? item.favorite = 1 : item.favorite = 0;
          targetIndex = index;
          return item;
        } else {
          return item;
        }
      });

      let targetHouse = MockData.secondHouseList.splice(targetIndex, 1);
      MockData.secondHouseList.unshift(...targetHouse);
      MockData.hotHouseListMap.set(HouseType.SECOND, MockData.secondHouseList);
    } else {
      MockData.rentHouseDetails = MockData.rentHouseDetails.map((item: IRentHouseDetail) => {
        if (item.house.houseId === param.houseId) {
          item.house.favorite === 0 ? item.house.favorite = 1 : item.house.favorite = 0;
          return item;
        } else {
          return item;
        }
      });

      let targetIndex: number = 0;
      MockData.rentHouseList = MockData.rentHouseList.map((item: IBasicHouse, index: number) => {
        if (item.houseId === param.houseId) {
          item.favorite === 0 ? item.favorite = 1 : item.favorite = 0;
          targetIndex = index;
          return item;
        } else {
          return item;
        }
      });
      let targetHouse = MockData.rentHouseList.splice(targetIndex, 1);
      MockData.rentHouseList.unshift(...targetHouse);
      MockData.hotHouseListMap.set(HouseType.RENT, MockData.rentHouseList);
    }

    let resp: BaseResponse<undefined> = {
      code: 0,
      data: undefined,
    };
    return Promise.resolve(resp);
  }

  public recordHistory(param: IHistoryRequest): Promise<BaseResponse<undefined>> {
    let historyList = MockData.historyMap.get(param.type) ?? [];
    if (!historyList.length) {
      let history: History[] = [{
        date: param.date,
        houseIds: [param.houseId],
      }];
      MockData.historyMap.set(param.type, history);
    } else {
      let hasDateRecord = historyList.some((item: History) => item.date === param.date);
      if (hasDateRecord) {
        let historyItem = historyList.find((item: History) => item.date === param.date);
        if (historyItem && !historyItem.houseIds.includes(param.houseId)) {
          // 是否包含该houseId
          historyItem.houseIds.unshift(param.houseId);
        }
      } else {
        historyList.unshift(...[{
          date: param.date,
          houseIds: [param.houseId],
        }] as History[]);
      }
      MockData.historyMap.set(param.type, historyList);
    }

    let resp: BaseResponse<undefined> = {
      code: 0,
      data: undefined,
    };
    return Promise.resolve(resp);
  }

  public queryHistoryList(type: HouseType): Promise<BaseResponse<Map<string, IBasicHouse[]>>> {
    let historyList = MockData.historyMap.get(type);
    let historyMap: Map<string, IBasicHouse[]> = new Map();
    let list = MockData.hotHouseListMap.get(type) ?? [];

    let houseList: IBasicHouse[] = [];
    historyList?.forEach((item: History) => {
      item.houseIds.forEach((houseId: string) => {
        let house = list.find((item: IBasicHouse) => item.houseId === houseId);
        if (house) {
          houseList.push(house);
        }
      });
      historyMap.set(item.date, houseList);
    });

    let queryResp: BaseResponse<Map<string, IBasicHouse[]>> = {
      code: 0,
      data: historyMap,
    };
    return Promise.resolve(queryResp);
  }

  public deleteHistoryRecords(param: IHistoryDeleteRequest): Promise<BaseResponse<undefined>> {
    let historyList = MockData.historyMap.get(param.type);
    param.records.forEach(item => {
      historyList = historyList?.map(history => {
        if (history.date === item.date) {
          // 取差集
          let result = history.houseIds.filter(houseId => !item.houses.includes(houseId));
          return {
            date: history.date,
            houseIds: result,
          } as History;
        } else {
          return {
            date: history.date,
            houseIds: [],
          };
        }
      });
    });
    MockData.historyMap.set(param.type, historyList ?? []);

    let queryResp: BaseResponse<undefined> = {
      code: 0,
      data: undefined,
    };
    return Promise.resolve(queryResp);
  }
}

const httpsMock = new HttpApiMock();

export { httpsMock };
