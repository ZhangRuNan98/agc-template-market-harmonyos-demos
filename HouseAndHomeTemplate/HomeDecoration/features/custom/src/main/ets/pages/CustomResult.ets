import { LengthMetrics } from '@kit.ArkUI';
import { BuildTitleBar, RouterModule, RouterMap, WindowUtil } from 'commonlib';
import { CaseInfo } from 'network';
import { CustomResultVM } from '../viewModels/CustomResultVM';

@Builder
export function CustomResultBuilder() {
  CustomResult();
}


@ComponentV2
export struct CustomResult {
  vm: CustomResultVM = CustomResultVM.instance;

  aboutToAppear(): void {
    this.vm.getCaseList();
  }

  aboutToDisappear(): void {
    this.vm.caseList = [];
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 12 }) {
          this.bannerBuilder();
          Column() {
            Stack() {
              Image($r('app.media.result_top')).width('100%').height('100%');
              Text('根据您的预算推荐以下装修案例参考')
                .margin({ left: 12 })
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Bold)
                .fontColor($r('sys.color.alert'));
            }.width(248).height(36);

            List({ space: 16 }) {
              ForEach(this.vm.caseList, (item: CaseInfo) => {
                ListItem() {
                  Row({ space: 16 }) {
                    Image($r(`app.media.${item.cover}`)).width(152).height(114).borderRadius(16);
                    Column({ space: 13 }) {
                      Row({ space: 12 }) {
                        Text('房屋面积').labelExtend();
                        Text(item.area + '㎡').contentExtend();
                      };

                      Row({ space: 12 }) {
                        Text('装修风格').labelExtend();
                        Text(item.style).contentExtend();
                      };

                      Row({ space: 12 }) {
                        Text('装修造价').labelExtend();
                        Text(item.price + '万').contentExtend();
                      };

                    }.alignItems(HorizontalAlign.Start);
                  };
                }.onClick(() => {
                  RouterModule.push(RouterMap.CASE_DETAIL_PAGE, item);
                });
              }, (item: CaseInfo) => item.caseId.toString());


            }.padding(12);

          }
          .width('100%')
          .borderRadius(16)
          .backgroundColor($r('sys.color.background_primary'))
          .alignItems(HorizontalAlign.Start);

        }
        .alignItems(HorizontalAlign.Start)
        .borderRadius(16);

      }
      .scrollBar(BarState.Off)
      .height('100%')
      .align(Alignment.Top)
      .width('100%')
      .padding({ left: 16, right: 16 })
      .edgeEffect(EdgeEffect.Spring)

    }
    .title(BuildTitleBar('定制结果'), { paddingStart: LengthMetrics.vp(16) })
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });
  }

  @Builder
  bannerBuilder() {
    Stack() {
      Image($r('app.media.custom_banner')).width('100%').height(188).borderRadius(16);
      Column({ space: 8 }) {
        Text('定制结果')
          .width(80)
          .height(28)
          .textAlign(TextAlign.Center)
          .border({
            width: 1,
          })
          .borderColor($r('sys.color.background_primary'))
          .borderRadius(16)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.font_on_primary'))
          .fontWeight(FontWeight.Regular);

        Row({ space: 24 }) {
          Text('所在城市')
            .fontSize($r('sys.float.Subtitle_S'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_on_primary'));
          Text(this.vm.baseInfo?.city)
            .lineHeight(24)
            .fontSize($r('sys.float.Subtitle_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'));
        }.height(24);

        Row({ space: 24 }) {
          Text('房屋面积')
            .fontSize($r('sys.float.Subtitle_S'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_on_primary'));
          Text(this.vm.baseInfo?.area.label)
            .lineHeight(24)
            .fontSize($r('sys.float.Subtitle_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'));
        }.height(24);

        Row({ space: 24 }) {
          Text('装修预算')
            .fontSize($r('sys.float.Subtitle_S'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_on_primary'));
          Text(this.vm.baseInfo?.price.label)
            .lineHeight(24)
            .fontSize($r('sys.float.Subtitle_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'));
        }.height(24);

      }.padding({ left: 32, top: 32 }).alignItems(HorizontalAlign.Start)
      .width('100%')
      .height('100%');

    }.width('100%').height(188).borderRadius(16);
  }
}


@Extend(Text)
function contentExtend() {
  .fontSize($r('sys.float.Subtitle_S')).fontWeight(FontWeight.Regular).fontColor($r('sys.color.font_primary'));
}

@Extend(Text)
function labelExtend() {
  .fontSize($r('sys.float.Subtitle_S')).fontWeight(FontWeight.Regular).fontColor($r('sys.color.font_secondary'));
}
