import { BasicParkInfo, CommonSpotItem } from 'module_parking_base';
import { MapListVM } from '../viewmodels/MapListVM';

@ComponentV2
export struct BottomPart {
  // 高度档位
  @Param detents: [string, string, string] = ['8%', '50%', '80%'];
  // 点击事件
  @Event cardClick: (item: BasicParkInfo) => void;
  @Local curHeight: number = 0;
  vm: MapListVM = MapListVM.instance;

  /** 修改高度档位 **/
  changeHeight(offset: number) {
    if (offset > 0 && this.curHeight !== 0) {
      this.curHeight = this.curHeight === 1 ? 0 : 1;
    } else if (offset < 0 && this.curHeight !== 2) {
      this.curHeight = this.curHeight === 1 ? 2 : 1;
    }
    this.vm.controller.scrollToIndex(this.vm.curIndex, true);
  }
  
  build() {
    Column({ space: 8 }) {
      // 控制条
      this.barBuilder()

      // 描述标题
      this.descTextBuilder()

      // 排序方式
      this.sortBuilder()

      // 附近列表
      this.listBuilder()
    }
    .clip(true)
    .height(this.detents[this.curHeight])
    .width('100%')
    .animation({ duration: 300 })
    .padding({ left: 12, right: 12, bottom: 12 })
    .backgroundColor($r('sys.color.white'))
    .border({ width: { bottom: 1 }, color: '#F1F3F5' })
    .borderRadius({ topLeft: 16, topRight: 16 })
    .gesture(
      PanGesture({ direction: PanDirection.Vertical }).onActionStart((event: GestureEvent) => {
        this.changeHeight(event.offsetY);
      }),
    )
  }

  @Builder
  barBuilder() {
    Row() {
      Row()
        .height(4)
        .width(48)
        .backgroundColor($r('sys.color.icon_fourth'))
        .borderRadius(2)
    }
    .height(28)
    .width(88)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Top)
    .padding({ top: 8 })
    .onClick(() => {
      if (this.curHeight !== 1) {
        this.curHeight = 1;
      }
    })
  }

  @Builder
  descTextBuilder() {
    Text('附近停车场')
      .fontWeight(FontWeight.Medium)
      .width('100%')
      .fontSize($r('sys.float.Body_M'))
      .fontColor($r('sys.color.font_primary'))
  }

  @Builder
  sortBuilder() {
    Row({ space: 8 }) {
      Text('距离最近').btnStyle(this.vm.sort === 0).onClick(() => {
        this.vm.sort = 0;
      })
      Text('余位最多').btnStyle(this.vm.sort === 1).onClick(() => {
        this.vm.sort = 1;
      })
    }.justifyContent(FlexAlign.Start).width('100%')
  }

  @Builder
  listBuilder() {
    List({ space: 8, scroller: this.vm.controller }) {
      ForEach(this.vm.sortedSpots, (item: BasicParkInfo) => {
        ListItem() {
          CommonSpotItem({
            item: item,
            selected: item.siteId === this.vm.selectedSpot?.siteId,
            cardClick: this.cardClick,
          })
        }
      }, (item: BasicParkInfo, index) => JSON.stringify(item) + '_' + index)
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .border({ width: 1, color: '#E7EFFE', radius: 16 })
    .divider({ strokeWidth: 1, color: 'rgba(0,0,0,0.20)' })
    .padding(6)
    .onScrollIndex((start) => {
      this.vm.curIndex = start;
    })
  }
}

@Extend(Text)
function btnStyle(isActive: boolean) {
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_primary'))
  .borderRadius(10)
  .backgroundColor(isActive ? '#cedefd' : ' #f3f3f3')
  .padding({
    left: 10,
    right: 10,
    top: 6,
    bottom: 6,
  })
}