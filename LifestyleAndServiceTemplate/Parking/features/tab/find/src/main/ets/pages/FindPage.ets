import { CommonConstants, RouterMap, RouterModule } from 'common';
import { TopPart } from '../components/TopPart';
import { ParkingMapList } from 'module_parking_map';

@ComponentV2
export struct FindPage {
  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 地图+列表
      ParkingMapList({
        cardClick: (item) => {
          RouterModule.push({ url: RouterMap.SITE_DETAIL, param: item });
        },
      })

      // 顶部展示栏
      TopPart()
    }
    .height(CommonConstants.FULL_HEIGHT)
    .backgroundColor($r('app.color.system_color_background_gray'))
  }
}

@Builder
export function findPageBuilder() {
  FindPage()
}