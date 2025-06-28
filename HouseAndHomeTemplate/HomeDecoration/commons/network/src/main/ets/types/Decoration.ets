// 设计师信息
export interface DesignerInfo {
  id: number,
  name: string,
  avatar: string,
  min: number,
  max: number,
  address: string,
  phone: string,
  goodSpace: string
}


// 案例信息
export interface CaseInfo {
  caseId: number,
  caseType: string,
  title: string,
  cover: string,
  homeCover?: string,
  designer: DesignerInfo,
  detail: string[],
  isCollected: boolean
  collection: number,
  style: string,
  homeTypeLabel: string,
  room: number,
  area: number,
  price: number
}


export interface DesignerDetail extends DesignerInfo {
  ownerCases: CaseInfo[],
  ownerArticle: CaseInfo[]
}


// 评论信息
export interface ReviewItem {
  reviewId: number
  authorAvatar: string,
  author: string,
  postTime: string,
  reviewType: string,
  review: string
}

export interface ReviewInfo {
  applauseRate: number,
  reviewList: ReviewItem[]
}


// 搜索列表参数
export interface QueryListParams {
  style?: string,
  title?: string,
  caseType?: string,
}


export interface Range {
  max: number;
  min: number;
}

export interface RangeDesc extends Range {
  label: string;
}


export interface CustomParams {
  city: string,
  area: RangeDesc,
  price: RangeDesc
}

export interface FilterListParams {
  style?: string,
  homeTypeLabel?: string,
  area?: Range,
  price?: Range
}


// 搜索列表参数
export interface QueryDesignerParams {
  max: number,
  min: number,
  goodSpace: string
}

// 预约请求
export interface OrderDesignerBody {
  id: number,
  firstName: string,
  area: string,
  budget: string
}

// 收藏请求
export interface CollectionBody {
  caseId: number;
}

export interface CityBody {
  city: string;
}


// 计算价格
export interface AccountPriceBody {
  address: string;
  cellName: string;
  area: string;
  room: string;
  hall: string;
  washroom: string;
  kitchen: string;
  balcony: string;
  homeType: string;
}


export interface ProjectItem {
  name: string,
  quantity: number,
  price: number
  total: number
}

export interface PriceListItem {
  label: string,
  details: ProjectItem[]
}


export interface PriceInfo {
  mainMember: string,
  assistant: string,
  manpower: string,
  priceList: PriceListItem[]
}






