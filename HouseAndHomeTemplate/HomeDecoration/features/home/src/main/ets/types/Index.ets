
// 轮播图信息
export interface BannerItem {
  url: ResourceStr,
  dishName: string,
  desc: string
}

export interface serverItem {
  label: string,
  icon: ResourceStr
}

// 案例
export interface CaseInfo{
  id:number,
  authorId:number,
  type:string
  cover:string,
  title:string,
  author:string,
  avatar:string,
  features:string,
  area:number,
  room:number,
  budget:number,
  isCollected:boolean,
  collect:number,
  pictures:ResourceStr[],
  phone:string
}






export interface RangeItem{
  label:string,
  min:number,
  max:number
}


export interface ProjectItem{
  name:string,
  quantity:number,
  price:number
  total:number
}