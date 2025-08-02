export interface SwiperOption {
  swiperType: SwiperType,
  contents: SwiperContent[]
}

export interface SwiperContent {
  type: SwiperContentType,
  content: string,
  preview?: string
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