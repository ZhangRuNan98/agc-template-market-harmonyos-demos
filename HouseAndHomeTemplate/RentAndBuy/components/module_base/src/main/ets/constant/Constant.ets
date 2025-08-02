import { httpsMock } from '../http/HttpApisMock';
import { BaseResponse } from '../model/Index';
import { FacilityType, HouseType, RequestUrl } from './Enum';

export class  Constant {
  static readonly BASE_URL = ''
  static readonly CLUSTER_MAX_ZOOM: number = 1.5;
}

export const DETAIL_MAP: Map<HouseType | string, string> = new Map([
  [HouseType.NEW, 'NewDetail'],
  [HouseType.SECOND, 'SecondDetail'],
  [HouseType.RENT, 'RentDetail'],
]);

export const FACILITY_ICON_MAP: Map<FacilityType, ResourceStr> = new Map([
  [FacilityType.EDUCATION, $r('app.media.education')],
  [FacilityType.TRANSPORT, $r('app.media.transport')],
  [FacilityType.LIFE, $r('app.media.life')],
  [FacilityType.LEISURE, $r('app.media.leisure')],
  [FacilityType.MEDICAL, $r('app.media.medical')],
]);

export const mockMap: MockMap = {
  [RequestUrl.NEW_LIST]: httpsMock.getNewHouseList,
  [RequestUrl.SECOND_LIST]: httpsMock.getSecondHouseList,
  [RequestUrl.RENT_LIST]: httpsMock.getRentHouseList,
};

export type MockMap = Record<string, (...args: ESObject[]) => Promise<BaseResponse>>;