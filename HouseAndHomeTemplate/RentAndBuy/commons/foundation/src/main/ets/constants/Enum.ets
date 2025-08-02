export enum ShortCutType {
  NEW = 1,
  SECOND = 2,
  RENT = 3,
  MAP = 4,
}

export enum TabBarType {
  HOME = 0,
  MINE = 1
}

export enum HouseType {
  REC = 0,
  NEW = 1,
  SECOND = 2,
  RENT = 3,
}

export enum EventEmitName {
  MAKE_CALL = 'makeCall',
  UPDATE_AVATAR = 'update_avatar',
  INIT_MAP = 'init_map',
  CANCEL_CALL = 'cancelCall',
  CLEAR_MAKER_STATUS = 'clearMakerStatus'
}

export enum AreaType {
  JIANG_NING = '江宁区',
  GU_LOU = '鼓楼区',
  PU_KOU = '浦口区',
  YU_HUA = '雨花台区',
  JIAN_YE = '建邺区',
  QIN_HUAI = '秦淮区'
}

export enum RequestUrl {
  CITY_UPDATE = '/city/update',
  HOT_HOUSE_LIST = `/hot/list`,
  NEW_LIST = `/new/list`,
  SECOND_LIST = `/second/list`,
  RENT_LIST = `/rent/list`,
  NEW_DETAIL = `/new/detail`,
  SECOND_DETAIL = `/second/detail`,
  RENT_DETAIL = `/rent/detail`,
  RECENT_CITY_LIST = `/recentCity/list`,
  UPDATE_RECENT_CITY = `/recentCity/update`,
  CURRENT_CITY = `/currentCity/detail`,
  UPDATE_CURRENT_CITY = `/currentCity/update`,
  HOUSE_SEARCH = `/house/search`,
  HOUSE_FAVORITE = `/house/favorite`,
  HISTORY_ADD = `/history/add`,
  HISTORY_QUERY = `/history/query`,
  HISTORY_DELETE = `/history/delete`
}

export enum UsageType {
  RESIDENCE = '住宅',
  COMMERCIAL = '商业',
}

export enum PropertyType {
  RESIDENCE = 70,
  COMMERCIAL = 30,
}

export enum AvatarFunctionButtonErrCode {
  ACCOUNT_NOT_LOGIN = 1001600002
}

export enum StatusType {
  SOLD = '已售',
  SALE = '在售',
}

export enum City {
  NANJING = '南京市'
}

export enum OrientationType {
  SOUTH_NORTH = '南北',
  WEST_SOUTH = '西南',
  SOUTH = '朝南'
}

export enum PaymentType {
  DEPOSIT_ONE_PAY_ONE = '押一付一',
  DEPOSIT_ONE_PAY_THREE = '押一付三',
}

export enum HouseInfoType {
  LAYOUT_INTRODUCTION = 0,
  BASIC_INFORMATION = 1,
  SURROUNDING_FACILITIES = 2,
  VALUE_EVALUATION = 3,
}

export enum PersonalInfoType {
  FOLLOW = 0,
  HISTORY = 1,
  SETTING = 2
}

export enum SettingType {
  PRIVACY_POLICY = '隐私政策',
  TERMS_OF_SERVICE = '用户协议'
}

export enum SwiperType {
  ANALYSIS = '探房分析',
  REAL = '实景图',
  EFFECT = '效果图',
  LOCATION = '位置图',
  PROGRAM = '项目现场',
  VR = 'VR视角',
  HOUSE = '房屋图片',
  VIDEO = '视频介绍'
}

export enum SwiperContentType {
  IMAGE = 0,
  VIDEO = 1,
  WEB = 2,
}

export enum FacilityType {
  EDUCATION = '教育',
  TRANSPORT = '交通',
  LIFE = '生活',
  LEISURE = '休闲',
  MEDICAL = '医疗',
}


