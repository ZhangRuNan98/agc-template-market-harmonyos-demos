import { common } from '@kit.AbilityKit';
import { BasicParkInfo } from '../types/ParkSpot';
import { FormatUtil } from '../utils/FormatUtil';
import { LocationUtil } from '../utils/LocationUtil';

@ComponentV2
export struct CommonSpotItem {
  // 点击事件
  @Event cardClick: (item: BasicParkInfo) => void;
  // 停车场信息
  @Require @Param item: BasicParkInfo;
  // 是否选中
  @Param selected: boolean = false;
  // 内边距
  @Param pad: Padding | Length = {
    left: 10,
    right: 10,
    top: 16,
    bottom: 8,
  };

  // 获取图标背景颜色
  getIconBgColor(nev: boolean, left: number): ResourceStr {
    if (nev) {
      return '#64bb5c';
    }
    if (left > 20) {
      return '#387BF1';
    } else if (left > 10) {
      return '#F9A01E';
    } else {
      return '#E84026';
    }
  }

  // 获取图标文字背景颜色
  getTextBgColor(nev: boolean, left: number): ResourceStr {
    if (nev) {
      return '#EEFFEC';
    }
    if (left > 20) {
      return '#E7EFFE';
    } else if (left > 10) {
      return '#FEF1E9';
    } else {
      return '#FCE4E0';
    }
  }

  build() {
    Row() {
      Column({ space: 4 }) {
        Text(this.item.name)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_primary'))
          .textStyle2()

        Row({ space: 8 }) {
          Text(`距您${FormatUtil.distanceDisplay(this.item.distance)}`).textStyle1()
          Text(this.item.addr).textStyle1().textStyle2().flexShrink(1)
        }.width('100%')

        Text('收费标准以停车场公示为准').textStyle1()

        Row({ space: 8 }) {
          this.numItemBuilder(false, this.item.leftSpots)
          if (this.item.chargeSpots) {
            this.numItemBuilder(true, this.item.leftChargeSpots)
          }
        }.margin(4)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .onClick(() => {
        this.cardClick(this.item);
      })

      Image($r('app.media.ic_nav_inner')).width(24).onClick(() => {
        LocationUtil.navWithLatLng(this.item.location, getContext(this) as common.UIAbilityContext);
      })
    }
    .padding(this.pad)
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .backgroundColor(this.selected ? '#ecf2fe' : 'auto')
    .borderRadius(8)
  }

  @Builder
  numItemBuilder(nev: boolean, value: number) {
    Row() {
      Text(nev ? '桩' : 'P')
        .width(24)
        .aspectRatio(1)
        .textAlign(TextAlign.Center)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_on_primary'))
        .borderRadius(8)
        .backgroundColor(this.getIconBgColor(nev, value))
      Text((nev ? '闲桩 ' : '余位 ') + value)
        .fontWeight(FontWeight.Medium)
        .height('100%')
        .padding({ left: 4, right: 8 })
        .fontSize($r('sys.float.Caption_M'))
        .fontColor(this.getIconBgColor(nev, value))
    }
    .backgroundColor(this.getTextBgColor(nev, value))
    .borderRadius(8)
    .clip(true)
    .height(24)
  }
}

@Extend(Text)
function textStyle1() {
  .fontColor($r('sys.color.font_secondary'))
  .fontSize($r('sys.float.Caption_M'))
}

@Extend(Text)
function textStyle2() {
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
}