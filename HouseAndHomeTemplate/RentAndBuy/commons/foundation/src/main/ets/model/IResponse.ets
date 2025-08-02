import {
  HouseType,
  OrientationType,
  PaymentType,
  StatusType,
  SwiperContentType,
  SwiperType,
  UsageType,
} from '../constants/Enum';

export interface SwiperContent {
  type: SwiperContentType,
  content: string,
  preview?: string
}

export interface ComplexInfo {
  uri: string,
  preview: string
}

@ObservedV2
export class SwiperOption {
  @Trace swiperType: SwiperType = SwiperType.ANALYSIS;
  @Trace contents: SwiperContent[] = [];
}

export interface IBasicHouse {
  houseId: string,
  type: HouseType,
  title: string,
  district: string,
  area: string,
  longitude: number,
  latitude: number,
  unit: number,

  // 小区名
  cell: string,

  // 房屋面积
  space: number[],

  // 房屋总价
  total: number[],
  labels: string[],
  thumbnail: string,
  bedroom: number,
  lounge: number,
  bathroom: number,
  open: Date,
  usage: UsageType,

  // 产权
  property: number,
  address: string,
  orientation: OrientationType,

  // 状态
  status: StatusType,

  // 楼层
  floor: number,
  phone: string,
  favorite: number,
}

export interface INewHouse extends IBasicHouse {
  // 探房分析
  inspect: SwiperContent[],

  // 实际效果
  real?: SwiperContent[],

  // 效果图
  effect?: string[],

  // 区位图
  zone?: string[],

  // 项目现场
  onsite?: string[],
}

export interface ISecondHouse extends IBasicHouse {
  // VR看房
  vr?: ComplexInfo,

  // 视频介绍
  video: ComplexInfo[],

  // 房屋图片
  pic: string[],

  // 区位图
  zone?: string[],

  // 周边
  around?: string,

  // 视频预览图
  preview?: string
  // 价值估值
  value: string
}

export interface IRentHouse extends IBasicHouse {
  // 房屋图片
  pic: string[],

  // 看房时间
  viewTime: string,

  // 入住要求
  requirement: string,

  // 押付策略
  payMethod: PaymentType,

  // 配套设施
  supplement: string[]
}

export interface INewHouseDetail {
  house: INewHouse,
  layout: ILayout[],
  basic: IBasic,
}

export interface ISecondHouseDetail {
  house: ISecondHouse,
  basic: IBasic,
}

export interface IRentHouseDetail {
  house: IRentHouse,
}

export interface IRecentCity {
  city: string;
}

// 基本信息
export interface IBasic {
  transport: string,
  plan: string,
  rate: string
}

// 户型介绍
export interface ILayout {
  bedroom: number,
  lounge: number,
  bathroom: number,
  space: number,
  total: number,
  image: string,
  isPivotal: number
}

export interface BaseResponse<T = ESObject> {
  code: number;
  msg?: string;
  data: T;
}

export interface GetUserInfoResp {
  avatar: string;
  nickname: string;
  phone: string;
}