import { BaseHeader } from 'commonlib';
import { RangeDesc } from 'network';
import { UICitySelect } from 'module_city_select';
import { CustomPageVM } from '../viewModels/CustomPageVM';
import { SourceItem } from '../types/Index';

@Builder
export function CustomPageBuilder() {
  CustomPage();
}

@Preview
@ComponentV2
struct CustomPage {
  vm: CustomPageVM = CustomPageVM.instance;

  @Builder
  SheetBuilder() {
    Column() {
      UICitySelect({
        currentCity: this.vm.gpsCity,
        emitUpdateCityLocation: (city: string) => {
          if (city){
            this.vm.gpsCity = city
            this.vm.curCity = city
            this.vm.isSheetOpen = false
          }

        },
        goBack: (city: string | undefined) => {
          if (city) {
            this.vm.curCity = city;
            this.vm.gpsCity = city
            this.vm.isSheetOpen = false;
          }
        },
      });
    }.backgroundColor($r('sys.color.background_primary'));
  }

  build() {
    NavDestination() {
      BaseHeader('定制设计');
      Scroll() {
        Column({ space: 12 }) {
          this.bannerBuilder();
          this.infoBuilder();

          Column({ space: 8 }) {
            Text('装修效果预测来源')
              .fontWeight(FontWeight.Bold)
              .fontSize($r('sys.float.Body_M'))
              .fontColor($r('sys.color.font_primary'));
            Row() {
              ForEach(this.vm.sourceList, (item: SourceItem) => {
                Column({ space: 8 }) {
                  Image(item.img).width(42).height(42);
                  Text(item.label)
                    .width(48)
                    .fontWeight(FontWeight.Regular)
                    .fontColor($r('sys.color.font_primary'))
                    .fontSize($r('sys.float.Body_S'))
                    .lineHeight(16);

                }
                .width(100)
                .height(98)
                .borderRadius(16)
                .backgroundColor($r('sys.color.background_primary'))
                .padding(8);

              }, (item: SourceItem) => item.label);
            }.width('100%').justifyContent(FlexAlign.SpaceBetween);
          }.width('100%');
        }.padding({ left: 16, right: 16 });

      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .width('100%')
      .layoutWeight(1)
      .backgroundColor($r('sys.color.background_secondary'));

    }.hideTitleBar(true);
  }

  @Builder
  bannerBuilder() {
    Stack() {
      Image($r('app.media.custom_banner')).width('100%').height(188).borderRadius(16);
      Column({ space: 8 }) {
        Text('“测一测”')
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_on_primary'))
          .fontWeight(FontWeight.Regular);
        Text('我的预算\n都有哪些方案？')
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_on_primary'))
          .fontWeight(FontWeight.Medium)
          .lineHeight(24);
      }.padding({ left: 32, top: 56 }).alignItems(HorizontalAlign.Start)
      .width('100%')
      .height('100%');

    }.width('100%').height(188).borderRadius(16);
  }

  @Builder
  infoBuilder() {
    Column() {
      Stack() {
        Image($r('app.media.ic_badge')).width(80).height(36);
        Text('新人特权').fontWeight(FontWeight.Bold).fontColor($r('sys.color.alert')).fontSize($r('sys.float.Body_M'));
      }.width(80).height(36);

      Column() {
        Text('选择房屋所在城市').baseTitle();
        Row() {
          Image($r('app.media.ic_public_gps_filled')).width(16).height(16).margin({bottom:8})
          Column({ space: 8 }) {
            Text(this.vm.curCity || '请选择所在城市')
              .fontSize($r('sys.float.Body_S'))
              .fontWeight(FontWeight.Medium)
              .fontColor(this.vm.curCity ? $r('sys.color.font_primary') : $r('sys.color.font_secondary'))
              .height(16);
            Divider();
          }.margin({ left: 10, right: 8 })
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start);

          Image($r('app.media.ic_bold_right')).width(16).height(16);
        }.margin({ bottom: 12 }).width('100%')
        .bindSheet($$this.vm.isSheetOpen, this.SheetBuilder, {
          title: {
            title: '选择城市',
          },
          height: SheetSize.LARGE,
        })
        .onClick(() => {
          this.vm.getCityByGPS();
          this.vm.isSheetOpen = true;
        });

        Text('选择房屋面积').baseTitle();
        Row() {
          ForEach(this.vm.areaList, (item: RangeDesc, index) => {
            Text(item.label)
              .backgroundColor(this.vm.curAreaIndex === index ? $r('sys.color.alert') :
              $r('sys.color.comp_background_tertiary'))
              .fontColor(this.vm.curAreaIndex === index ? $r('sys.color.font_on_primary') :
              $r('sys.color.font_primary'))
              .baseBtnExtend()
              .onClick(() => {
                this.vm.curAreaIndex = index;
              });
          }, (item: RangeDesc) => item.label);
        }.justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 16 }).width('100%');

        Text('选择装修预算').baseTitle();
        Row() {
          ForEach(this.vm.budgetList, (item: RangeDesc, index) => {
            Text(item.label)
              .backgroundColor(this.vm.curBudgetIndex === index ? $r('sys.color.alert') :
              $r('sys.color.comp_background_tertiary'))
              .fontColor(this.vm.curBudgetIndex === index ? $r('sys.color.font_on_primary') :
              $r('sys.color.font_primary'))
              .baseBtnExtend()
              .onClick(() => {
                this.vm.curBudgetIndex = index;
              });
          }, (item: RangeDesc) => item.label);
        }.justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 16 }).width('100%');

        Button('获取定制装修方案')
          .height(40)
          .backgroundColor($r('sys.color.alert'))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_on_primary'))
          .width('100%')
          .onClick(() => {
            this.vm.handleCustomData();
          });

        Row({ space: 2 }) {
          Image($r('app.media.ic_warming')).width(10).height(10);
          Text('允许软件来电了解详细装修需求')
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.Caption_L'))
            .fontColor($r('sys.color.font_tertiary'));
        }.margin({ top: 8 }).width('100%').justifyContent(FlexAlign.Center);

      }.padding(12).alignItems(HorizontalAlign.Start);

    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
    .clip(true);
  }
}


@Extend(Text)
function baseBtnExtend() {
  .width(70)
  .height(28)
  .fontSize($r('sys.float.Caption_M'))
  .fontWeight(FontWeight.Regular)
  .padding(0)
  .borderRadius(8)
  .textAlign(TextAlign.Center);
}

@Extend(Text)
function baseTitle() {
  .fontSize($r('sys.float.Body_S'))
  .fontWeight(FontWeight.Regular)
  .fontColor($r('sys.color.font_primary'))
  .margin({ bottom: 8 });
}
