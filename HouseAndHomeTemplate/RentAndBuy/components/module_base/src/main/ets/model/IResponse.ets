import {
  HouseType,
  OrientationType,
  StatusType,
  UsageType,
} from '../constant/Enum';

export interface IBasicHouse {
  houseId: string,
  type: HouseType,
  title: string,
  district: string,
  area: string,
  longitude: number,
  latitude: number,
  unit: number,
  cell: string,
  space: number[],
  total: number[],
  labels: string[],
  thumbnail: string,
  bedroom: number,
  lounge: number,
  bathroom: number,
  open: Date,
  usage: UsageType,
  property: number,
  address: string,
  orientation: OrientationType,
  status: StatusType,
  floor: number,
  phone: string,
  favorite: number,
}

export interface BaseResponse<T = ESObject> {
  code: number;
  msg?: string;
  data: T;
}