import {
  AreaType,
  HouseInfoType,
  HouseType,
  PersonalInfoType,
  SettingType,
  ShortCutType,
  TabBarType,
} from '../constants/Enum';
import { BaseResponse, IBasicHouse } from './IResponse';

export interface ShortCutModule {
  id: ShortCutType;
  title: ResourceStr;
  icon: ResourceStr;
  click: (event: ClickEvent) => void;
}

export interface TabBarModule {
  id: TabBarType;
  title: ResourceStr;
  activeIcon: ResourceStr;
  defaultIcon: ResourceStr;
  component: WrappedBuilder<[]>;
}

export interface HouseTabBarModule {
  id: HouseType;
  title: ResourceStr;
}

export interface HouseInfoTabBarModule {
  type: HouseInfoType,
  title: string,
}

export interface PersonalInfoModule {
  type: PersonalInfoType,
  icon: Resource,
  name: string,
  clickEvent: () => void
}

export interface SettingInfoModule {
  type: SettingType,
  clickEvent: () => void
}

export interface History {
  date: string,
  houseIds: string[],
}

export interface AreaInfo {
  area: AreaType,
  position: number[]
}

export interface HouseOptions {
  house: IBasicHouse,
  type: HouseType,
  enableEdit: boolean,
  allowFollow: boolean,
  inEdit?: boolean,
}

export class CityList {
  cityList: string[] = [];
}

export interface HouseDetailRouteParam {
  houseId: string,
  allowFollow: boolean
}

export class CurrentAddressInfo {
  city: string = '';
  latitude: number = 0;
  longitude: number = 0;
}

export type MockMap = Record<string, (...args: ESObject[]) => Promise<BaseResponse>>;