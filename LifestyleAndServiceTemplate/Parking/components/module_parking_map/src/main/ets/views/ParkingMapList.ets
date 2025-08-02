import { MapListVM } from '../viewmodels/MapListVM';
import { BottomPart } from '../components/BottomPart';
import { MapComponent } from '@kit.MapKit';
import { BasicParkInfo, FormatUtil } from 'module_parking_base';

@ComponentV2
export struct ParkingMapList {
  // 高度档位
  @Param detents: [string, string, string] = ['8%', '50%', '80%'];
  // 点击事件
  @Event cardClick?: (item: BasicParkInfo) => void;
  vm: MapListVM = MapListVM.instance;

  build() {
    Column() {
      // 地图(高度为1-detents[0])
      MapComponent({ mapOptions: this.vm.mapOptions, mapCallback: this.vm.mapInitCallback })
        .height(FormatUtil.getComplementPercentage(this.detents[0]))

      // 底部列表栏
      BottomPart({ detents: this.detents, cardClick: this.cardClick }).position({ bottom: 0 })
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}