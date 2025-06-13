export interface IMainServiceItem {
  text: string,
  image: ResourceStr,
  func: Function
}

export interface IRegion {
  code: string,
  name: string,
  children?: []
}