@ObservedV2
export class MineItem {
  @Trace titleName: string
  @Trace icon: ResourceStr
  @Trace url?: string

  constructor(titleName: string, icon: ResourceStr, url?: string) {
    this.titleName = titleName
    this.icon = icon
    this.url = url
  }
}