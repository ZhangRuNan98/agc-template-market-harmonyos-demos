import { BasicParkInfo, CommonSpotItem } from 'module_parking_base';
import { TabComp } from '../components/TabComp';
import { SpotsTabVM } from '../viewmodels/SpotsTabVM';

@ComponentV2
export struct SpotsTab {
  @Param start: boolean = true;
  @Param space: number = 16;
  @Param offsetLeft: number = 28;
  @Event cardClick?: (item: BasicParkInfo) => void;
  @Local index: number = 0;
  vm: SpotsTabVM = SpotsTabVM.instance;

  aboutToAppear(): void {
    this.vm.getNearBySpots();
  }

  build() {
    Column() {
      TabComp({
        tabBar: ['附近停车场', '收藏停车场'],
        index: this.index!!,
        start: this.start,
        space: this.space,
        offsetLeft: this.offsetLeft,
        tabBarHeight: 40,
        relativeY: 30,
        activeSize: $r('sys.float.Body_M'),
        frozenSize: $r('sys.float.Body_M'),
        activeColor: '#496ffa',
        frozenColor: $r('sys.color.font_secondary'),
        contentUi: (index) => {
          this.listBuilder(index);
        },
      })
    }
  }

  @Builder
  listBuilder(index: number) {
    Column() {
      if ((index ? this.vm.collectList.list : this.vm.nearbyList).length === 0) {
        Column({ space: 4 }) {
          Image($r('app.media.ic_null_spots_inner')).width(120)
          Text(index ? '暂无收藏停车场' : '暂无附近停车场')
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_tertiary'))
        }
        .height(180)
        .padding(12)
        .borderRadius(16)
        .backgroundColor($r('sys.color.white'))
        .width('100%')
      } else {
        Refresh({ refreshing: $$this.vm.refreshing }) {
          List({ space: 26 }) {
            ForEach(index ? this.vm.collectList.list : this.vm.nearbyList, (item: BasicParkInfo) => {
              ListItem() {
                CommonSpotItem({ item: item, pad: 0, cardClick: this.cardClick })
              }
            }, (item: BasicParkInfo, index) => JSON.stringify(item) + '_' + index)
          }
          .scrollBar(BarState.Off)
          .divider({ strokeWidth: 1, color: $r('sys.color.comp_divider') })
          .nestedScroll({ scrollForward: NestedScrollMode.PARENT_FIRST, scrollBackward: NestedScrollMode.SELF_FIRST })
          .padding(12)
          .borderRadius(16)
          .backgroundColor($r('sys.color.white'))
          .width('100%')
        }
        .clip(false)
        .onRefreshing(() => {
          this.vm.refreshNewNearby();
        })
      }
      Blank().layoutWeight(1)
    }.width('calc(100% - 32vp)')
  }
}