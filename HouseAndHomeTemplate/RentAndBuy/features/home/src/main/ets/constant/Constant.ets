import {
  HouseTabBarModule,
  HouseInfoTabBarModule,
  HouseInfoType,
  HouseType,
  RouterModule,
  ShortCutModule,
  ShortCutType,
  https,
  AppStorageBank,
} from 'foundation';
import { Facility, FacilityType } from '../model/Index';

export const SHORT_CUTS: ShortCutModule[] = [
  {
    id: ShortCutType.NEW,
    title: '新房',
    icon: $r('app.media.new'),
    click: () => {
      RouterModule.push({ url: 'HouseList', param: ShortCutType.NEW });
    },
  },
  {
    id: ShortCutType.SECOND,
    title: '二手房',
    icon: $r('app.media.second_hand'),
    click: () => {
      RouterModule.push({ url: 'HouseList', param: ShortCutType.SECOND });
    },
  },
  {
    id: ShortCutType.RENT,
    title: '租房',
    icon: $r('app.media.rent'),
    click: () => {
      RouterModule.push({ url: 'HouseList', param: ShortCutType.RENT });
    },
  },
  {
    id: ShortCutType.MAP,
    title: '地图找房',
    icon: $r('app.media.search_by_map'),
    click: () => {
      let city = AppStorageBank.getCurrentCity();
      RouterModule.push({
        url: 'HouseMap',
        param: [https.getNewHouseList(city), https.getSecondHouseList(city), https.getRentHouseList(city)],
      });
    },
  },
];

export const SEARCH_HOUSE_TAB: HouseTabBarModule[] = [
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

export const HOT_HOUSE_TAB: HouseTabBarModule[] = [
  {
    id: HouseType.REC,
    title: '推荐',
  },
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

export const NEW_HOUSE_INFO_CONTENT: HouseInfoTabBarModule[] = [
  {
    type: HouseInfoType.LAYOUT_INTRODUCTION,
    title: '户型介绍',
  },
  {
    type: HouseInfoType.BASIC_INFORMATION,
    title: '基础信息',
  },
  {
    type: HouseInfoType.SURROUNDING_FACILITIES,
    title: '周边配套',
  },
];

export const SECOND_HOUSE_INFO_CONTENT: HouseInfoTabBarModule[] = [
  {
    type: HouseInfoType.VALUE_EVALUATION,
    title: '价值评估',
  },
  {
    type: HouseInfoType.BASIC_INFORMATION,
    title: '基础信息',
  },
  {
    type: HouseInfoType.SURROUNDING_FACILITIES,
    title: '周边配套',
  },
];

export const FACILITY_TYPES: Facility[] = [
  {
    type: FacilityType.EDUCATION,
    name: '教育情况',
    sites: [],
    keyword: '小学,初中,高中',
  },
  {
    type: FacilityType.TRANSPORT,
    name: '交通情况',
    sites: [],
    keyword: '地铁站,公交站',
  },
  {
    type: FacilityType.LIFE,
    name: '生活配套',
    sites: [],
    keyword: '商场',
  },
];