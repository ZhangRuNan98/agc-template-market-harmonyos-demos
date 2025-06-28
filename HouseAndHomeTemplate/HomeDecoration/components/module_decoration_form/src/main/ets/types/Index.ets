// 表单数据


export interface HomeLayout {
  room: string,
  hall: string,
  washroom: string,
  kitchen: string,
  balcony: string
}

export interface DecorationData {
  homeLayout: HomeLayout,
  homeType: string,
  address: string,
  cellName: string,
  area: string
}


export interface TypeOption{
  label:string,
  desc:string,
  value:string
}