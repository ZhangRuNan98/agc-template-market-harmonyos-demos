import { httpsMock } from '../http/HttpApisMock';
import { HouseTabBarModule, MockMap } from '../model/Index';
import { AreaType, FacilityType, HouseType, RequestUrl } from './Enum';

export class Constant {
  static readonly FULL_PERCENT: string = '100%';
  static readonly BASE_URL: string = '';
  static readonly CLUSTER_MAX_ZOOM: number = 1.5;
}

export const mockMap: MockMap = {
  [RequestUrl.HOT_HOUSE_LIST]: httpsMock.getHotHouseList,
  [RequestUrl.NEW_LIST]: httpsMock.getNewHouseList,
  [RequestUrl.SECOND_LIST]: httpsMock.getSecondHouseList,
  [RequestUrl.RENT_LIST]: httpsMock.getRentHouseList,
  [RequestUrl.NEW_DETAIL]: httpsMock.getNewHouseDetail,
  [RequestUrl.SECOND_DETAIL]: httpsMock.getSecondHouseDetail,
  [RequestUrl.RENT_DETAIL]: httpsMock.getRentHouseDetail,
  [RequestUrl.UPDATE_RECENT_CITY]: httpsMock.updateRecentCityList,
  [RequestUrl.RECENT_CITY_LIST]: httpsMock.getRecentCityList,
  [RequestUrl.CURRENT_CITY]: httpsMock.getCurrentCity,
  [RequestUrl.UPDATE_CURRENT_CITY]: httpsMock.updateCurrentCity,
  [RequestUrl.HOUSE_SEARCH]: httpsMock.aggregatedHouseSearch,
  [RequestUrl.HOUSE_FAVORITE]: httpsMock.updateFavorite,
  [RequestUrl.HISTORY_ADD]: httpsMock.recordHistory,
  [RequestUrl.HISTORY_QUERY]: httpsMock.queryHistoryList,
  [RequestUrl.HISTORY_DELETE]: httpsMock.deleteHistoryRecords,
};

export const HOUSE_MAP: Map<HouseType, string> = new Map([[HouseType.REC, '推荐'],
  [HouseType.NEW, '新房'],
  [HouseType.SECOND, '二手房'],
  [HouseType.RENT, '租房']]);

export const DETAIL_MAP: Map<HouseType | string, string> = new Map([
  [HouseType.NEW, 'NewDetail'],
  [HouseType.SECOND, 'SecondDetail'],
  [HouseType.RENT, 'RentDetail'],
]);

export const BEDROOM_MAP: Map<number, string> = new Map([
  [1, '一'],
  [2, '二'],
  [3, '三'],
  [4, '四'],
  [5, '五'],
]);

export const AREA_POSITION_MAP: Map<string, number[]> = new Map([
  [AreaType.JIANG_NING, [31.9527, 118.84]],
  [AreaType.GU_LOU, [32.0664, 118.7701]],
  [AreaType.PU_KOU, [32.0590, 118.6284]],
  [AreaType.YU_HUA, [31.9923, 118.7787]],
  [AreaType.JIAN_YE, [32.0033, 118.7315]],
  [AreaType.QIN_HUAI, [32.0390, 118.7945]],
]);

export const HOUSE_TAB: HouseTabBarModule[] = [
  {
    id: HouseType.NEW,
    title: '新房',
  },
  {
    id: HouseType.SECOND,
    title: '二手房',
  },
  {
    id: HouseType.RENT,
    title: '租房',
  },
];


