export enum HouseType {
  REC = 0,
  NEW = 1,
  SECOND = 2,
  RENT = 3,
}

export enum FacilityType {
  EDUCATION = '教育',
  TRANSPORT = '交通',
  LIFE = '生活',
  LEISURE = '休闲',
  MEDICAL = '医疗',
}

export enum OrientationType {
  SOUTH_NORTH = '南北',
  WEST_SOUTH = '西南',
  SOUTH = '朝南'
}

export enum UsageType {
  RESIDENCE = '住宅',
  COMMERCIAL = '商业',
}

export enum StatusType {
  SOLD = '已售',
  SALE = '在售',
}

export enum RequestUrl {
  NEW_LIST = `/new/list`,
  SECOND_LIST = `/second/list`,
  RENT_LIST = `/rent/list`,
}

export enum City {
  NANJING = '南京市'
}

export enum EventEmitName {
  CLEAR_MAKER_STATUS = 'clearMakerStatus'
}