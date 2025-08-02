import { HouseType } from '../constants/Enum';

export interface ISearchRequest {
  type?: HouseType,
  keyword: string
}

export interface IFavoriteRequest {
  type: HouseType,
  houseId: string
}

export interface IHistoryRequest {
  type: HouseType,
  date: string,
  houseId: string
}

export interface IHistoryDeleteRequest {
  type: HouseType,
  records: Record[]
}

export interface IHouseListRequest {
  city: string,
  type: HouseType
}

@ObservedV2
export class Record {
  @Trace date: string = '';
  @Trace houses: string[] = [];
}