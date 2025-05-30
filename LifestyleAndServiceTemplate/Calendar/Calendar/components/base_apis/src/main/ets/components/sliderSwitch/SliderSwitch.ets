import { ToggleItem } from './Index.type'

@ComponentV2
export struct BaseSliderSwitch {
  /**
   * 切换条高度
   */
  @Param switchHeight: ResourceStr | number = 36
  /**
   * 默认背景色
   */
  @Param defaultBg: ResourceStr | Color = $r('sys.color.background_secondary')
  /**
   * 选中背景色
   */
  @Param selectedBg: ResourceStr | Color = $r('sys.color.background_primary')
  /**
   * 右侧图标
   */
  @Param toggleList: ToggleItem[] = []
  /**
   * 默认选中项
   */
  @Param currentIndex: number = 0

  /**
   * 切换事件
   */
  @Event onChooseChange: (index: number) => void = () => {}


  @Local chooseIndex: number = 0


  @Monitor('currentIndex')
  onStrChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      this.chooseIndex = this.currentIndex
    })
  }

  aboutToAppear(): void {
    this.chooseIndex = this.currentIndex
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(this.toggleList, (item: ToggleItem, index: number) => {
          Row() {
            Text(item.name)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.chooseIndex === index ? this.selectedBg :
          this.defaultBg)
          .borderRadius(18)
          .flexGrow(1)
          .onClick(() => {
            animateTo({
              duration: 300,
              curve: Curve.EaseOut
            }, () => {
              this.chooseIndex = index
              this.onChooseChange(this.chooseIndex)
            })
          })
        }, (item: ToggleItem) => item.id)
      }
      .backgroundColor(this.defaultBg)
      .height(36)
      .borderRadius(18)
      .padding(3)
    }
  }
}