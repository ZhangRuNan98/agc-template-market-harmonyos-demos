import { OrderDetailBean, TimeLineNode } from './TimeLineNode'

@ComponentV2
export struct CommonTimeLine {
  @Param timeLineList: OrderDetailBean[] = []
  @Param totalSize: number = 0

  build() {
    List() {
      ForEach(this.timeLineList, (item: object, index: number) => {
        TimeLineNode({ bean: item, index: index, totalSize: this.totalSize })
      }, (item: object) => JSON.stringify(item))
    }
  }
}