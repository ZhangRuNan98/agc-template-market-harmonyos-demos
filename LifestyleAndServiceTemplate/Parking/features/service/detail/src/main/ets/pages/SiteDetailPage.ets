import {
  CommonConstants,
  CommonHeader,
  CONTAINER_STYLE_CALC_WIDTH,
  FormatUtil,
  TelUtil,
  WindowUtil,
} from 'common';
import { SiteDetailPageVM } from '../viewmodels/SiteDetailPageVM';
import { common } from '@kit.AbilityKit';
import { SwiperPicsPreview } from 'module_swiper_preview';

@ComponentV2
struct SiteDetailPage {
  vm: SiteDetailPageVM = SiteDetailPageVM.instance;

  aboutToAppear() {
    this.vm.init();
  }

  build() {
    NavDestination() {
      /** 标题 **/
      CommonHeader({ title: '停车详情' })

      Scroll() {
        if (this.vm.detail) {
          Column({ space: 12 }) {
            // 基本信息
            this.basicInfoBuilder()

            // 轮播图
            this.swiperBuilder()

            //车位信息
            this.numBuilder()

            //收费标准
            this.chargeBuilder()

            Blank().layoutWeight(1)
          }
        }
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
    .backgroundColor($r('app.color.system_color_background_gray'))
    .hideTitleBar(true)
  }

  @Builder
  basicInfoBuilder() {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 8 }) {
          Text(this.vm.detail!.name)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Subtitle_M'))
            .fontColor($r('sys.color.font_primary'))
          Text() {
            Span('营业时间 ').fontColor($r('sys.color.font_primary'))
            Span(this.vm.detail!.parkTime).fontColor($r('sys.color.font_secondary'))
          }.fontSize($r('sys.float.Caption_M'))
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Image($r('app.media.ic_collect'))
          .width(24)
          .fillColor(this.vm.isCollect ? $r('app.color.icon_collect') : $r('app.color.icon_no_collect'))
          .onClick(() => {
            this.vm.collectOrCancel();
          })
      }.alignItems(VerticalAlign.Top)

      Divider().color($r('sys.color.comp_divider'))

      Row() {
        Column({ space: 8 }) {
          Text(`驾车${FormatUtil.distanceDisplay(this.vm.detail?.distance ?? 0)}`)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Caption_L'))
            .fontColor($r('sys.color.font_primary'))
          Text(this.vm.detail!.addr)
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Image($r('app.media.ic_nav')).width(24).onClick(() => {
          const uri = `https://www.petalmaps.com/routes/?utm_source=fb&daddr=${this.vm.detail!.location.latitude + ',' +
          this.vm.detail!.location.longitude}`;
          const ctx = getContext(this) as common.UIAbilityContext;
          if (ctx) {
            ctx.openLink(uri, { appLinkingOnly: true });
          }
        })

        Image($r('app.media.ic_call')).width(24).onClick(() => {
          TelUtil.open({ title: '联系客服', phoneNum: this.vm.detail!.phone });
        }).margin({ left: $r('app.string.margin_16') })
      }.alignItems(VerticalAlign.Center)
    }
    .attributeModifier(CONTAINER_STYLE_CALC_WIDTH)
  }

  @Builder
  swiperBuilder() {
    SwiperPicsPreview({
      pics: this.vm.detail?.basicPic,
      iHeight: 120,
      pad: 16,
      out: 50,
    })
  }

  @Builder
  numBuilder() {
    Column({ space: 8 }) {
      Text('车位信息').titleStyle()
      Text(`共${this.vm.detail!.totalSpots}停车位，${this.vm.detail!.chargeSpots}充电桩（车位信息仅供参考，具体以实际为准）`)
        .textStyle()
      Row({ space: 8 }) {
        this.numItemBuilder(0, this.vm.detail?.leftSpots ?? 0)
        if (this.vm.detail?.chargeSpots) {
          this.numItemBuilder(1, this.vm.detail?.leftChargeSpots ?? 0)
        }
      }
    }.attributeModifier(CONTAINER_STYLE_CALC_WIDTH).alignItems(HorizontalAlign.Start)
  }

  @Builder
  chargeBuilder() {
    Column({ space: 4 }) {
      Text('收费标准').titleStyle()
      Column({ space: 12 }) {
        Text(this.vm.detail!.chargeRules).textStyle()
        this.chargeItemBuilder(0, 1)
        this.chargeItemBuilder(1, 2)
        Row() {
          Text('收费时间: 全天')
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_primary'))
          Text('停车不满15分钟免费')
            .fontSize($r('sys.float.Caption_M'))
            .fontColor($r('sys.color.font_secondary'))
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(CommonConstants.FULL_WIDTH)
      }
    }.attributeModifier(CONTAINER_STYLE_CALC_WIDTH)
  }

  @Builder
  numItemBuilder(type: number, value: number) {
    Row() {
      Text(type ? '桩' : 'P')
        .width(24)
        .aspectRatio(1)
        .textAlign(TextAlign.Center)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_on_primary'))
        .borderRadius($r('app.string.border_radius_8'))
        .backgroundColor(type ? $r('app.color.icon_bg_green') : $r('app.color.icon_bg_blue'))
      Text((type ? '闲桩 ' : '余位 ') + value)
        .fontWeight(FontWeight.Medium)
        .height(CommonConstants.FULL_HEIGHT)
        .borderRadius({ topRight: $r('app.string.border_radius_8'), bottomRight: $r('app.string.border_radius_8') })
        .padding({ left: $r('app.string.padding_4'), right: $r('app.string.padding_4') })
        .backgroundColor(type ? $r('app.color.text_bg_green') : $r('app.color.text_bg_blue'))
        .fontSize($r('sys.float.Caption_M'))
        .fontColor(type ? $r('app.color.icon_bg_green') : $r('app.color.icon_bg_blue'))
    }
    .height(24)
  }

  @Builder
  chargeItemBuilder(type: number, value: number) {
    Row() {
      Image(type ? $r('app.media.ic_car_max') : $r('app.media.ic_car_min')).width(24).margin({ right: 4 })
      Text(type ? '大型车' : '小型车')
        .fontSize(8)
        .padding($r('app.string.padding_4'))
        .borderRadius($r('app.string.border_radius_16'))
        .fontColor($r('app.color.icon_bg_blue'))
        .backgroundColor($r('app.color.text_bg_blue'))
      Blank().layoutWeight(1)
      Text() {
        Span('¥ ')
        Span(value.toString()).fontWeight(FontWeight.Medium).fontSize(14)
        Span('/15分钟')
      }
      .fontSize(12)
      .fontColor($r('app.color.icon_bg_blue'))
    }
  }
}

@Extend(Text)
function titleStyle() {
  .fontWeight(FontWeight.Medium)
  .width(CommonConstants.FULL_WIDTH)
  .fontSize($r('sys.float.Body_M'))
  .fontColor($r('sys.color.font_primary'))
}


@Extend(Text)
function textStyle() {
  .width(CommonConstants.FULL_WIDTH)
  .fontSize($r('sys.float.Caption_M'))
  .fontColor($r('sys.color.font_secondary'))
}

@Builder
export function siteDetailPageBuilder() {
  SiteDetailPage()
}