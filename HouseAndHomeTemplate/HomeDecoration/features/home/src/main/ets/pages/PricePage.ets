import { LengthMetrics } from '@kit.ArkUI';
import { BuildTitleBar, WindowUtil } from 'commonlib';
import { FormDecoration } from 'module_decoration_form';
import { PricePageVM } from '../viewModels/PricePageVM';


@Builder
export function PricePageBuilder() {
  PricePage();
}


@ComponentV2
struct PricePage {
  vm: PricePageVM = PricePageVM.instance;

  aboutToAppear(): void {
    this.vm.cloneDecorationInfo();
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 12 }) {
          Stack() {
            Image($r('app.media.price_img')).width('100%').borderRadius(16).height('100%');
            Column({ space: 12 }) {
              Text('装修预算')
                .fontSize($r('sys.float.Title_L'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_on_primary'));
              Text('10秒快速计算装修报价')
                .fontSize($r('sys.float.Subtitle_L'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_on_primary'));
            }.width('100%').height('100%').padding({ top: 56, left: 16 }).alignItems(HorizontalAlign.Start);
          }.width('100%').height(188);

          FormDecoration({
            buttonText: '立即计算',
            homeType: this.vm.newDecorationInfo.homeType,
            homeLayout: {
              room: this.vm.newDecorationInfo.room,
              hall: this.vm.newDecorationInfo.hall,
              washroom: this.vm.newDecorationInfo.washroom,
              kitchen: this.vm.newDecorationInfo.kitchen,
              balcony: this.vm.newDecorationInfo.balcony,
            },
            address: this.vm.newDecorationInfo.address,
            cellName: this.vm.newDecorationInfo.cellName,
            area: this.vm.newDecorationInfo.area,
            onFormSubmit: (data) => {
              this.vm.newDecorationInfo.address = data.address;
              this.vm.newDecorationInfo.cellName = data.cellName;
              this.vm.newDecorationInfo.area = data.area;
              this.vm.newDecorationInfo.homeType = data.homeType;
              this.vm.newDecorationInfo.room = data.homeLayout.room;
              this.vm.newDecorationInfo.hall = data.homeLayout.hall;
              this.vm.newDecorationInfo.washroom = data.homeLayout.washroom;
              this.vm.newDecorationInfo.kitchen = data.homeLayout.kitchen;
              this.vm.newDecorationInfo.balcony = data.homeLayout.balcony;
              this.vm.handleDecoration();
            },
          });


        }.padding({ left: 16, right: 16 });
      }.align(Alignment.Top).scrollBar(BarState.Off).height('100%');
    }
    .title(BuildTitleBar('装修报价'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });
  }
}

