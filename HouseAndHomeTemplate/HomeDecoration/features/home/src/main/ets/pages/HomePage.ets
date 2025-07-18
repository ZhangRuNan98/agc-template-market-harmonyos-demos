import { emitter } from '@kit.BasicServicesKit';
import { RouterModule, RouterMap, BaseHeader, DataSource } from 'commonlib';
import { HomePageVM } from '../viewModels/HomePageVM';
import { CaseInfo } from 'network';
import { serverItem } from '../types/Index';


@Builder
export function HomePageBuilder() {
  HomePage();
}


@ComponentV2
struct HomePage {
  vm: HomePageVM = HomePageVM.instance;
  controller: TabsController = new TabsController();

  aboutToAppear(): void {
    this.vm.getCaseList();
    this.vm.getHotCaseList();
    this.vm.getCurrentCityByGPS();
    this.vm.InitCity();
  }

  @Builder
  serverListBuilder() {
    Row() {
      ForEach(this.vm.serverList, (item: serverItem, index) => {
        Column({ space: 8 }) {
          Image(item.icon).width(40);
          Text(item.label)
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Caption_L'));
        }.onClick(() => {
          if (index === 0) {
            RouterModule.push(RouterMap.HOME_CASE_PAGE);
          }

          if (index === 1) {
            emitter.emit('toFindPage');
          }

          if (index === 2) {
            RouterModule.push(RouterMap.PRICE_PAGE);
          }


        });
      }, (item: serverItem) => item.label);

    }.width('100%').justifyContent(FlexAlign.SpaceAround).padding({ top: 16, bottom: 16 });
  }

  @Builder
  tabsBuilder() {
    Row({ space: 24 }) {
      ForEach(this.vm.tabList, (item: string, index) => {
        Stack({ alignContent: Alignment.Bottom }) {
          if (this.vm.curIndex === index) {
            Image($r('app.media.icon_oval')).width(24).height(8).alignSelf(ItemAlign.Center);
          }

          Text(item)
            .height(19)
            .fontSize($r('sys.float.Body_M'))
            .fontColor(this.vm.curIndex === index ? $r('sys.color.font_primary') : $r('sys.color.font_secondary'))
            .fontWeight(this.vm.curIndex === index ? FontWeight.Bold : FontWeight.Regular)
            .alignSelf(ItemAlign.Center);
        }.height(19)
        .onClick(() => {
          this.vm.curIndex = index;
          this.controller.changeIndex(index);
        });
      }, (item: string) => item);

    }.width('100%').padding({ left: 14 }).margin({ bottom: 12 });

    Tabs({ barPosition: BarPosition.Start, index: this.vm.curIndex, controller: this.controller }) {
      TabContent() {
        WaterFlow() {
          LazyForEach(this.vm.hotCaseInfo, (item: CaseInfo, index) => {
            this.flowItemBuilder(item);
          }, (item: CaseInfo) => item.caseId.toString());

        }
        .flowExtend();
      };

      TabContent() {
        WaterFlow() {
          LazyForEach(this.vm.caseInfoList, (item: CaseInfo, index) => {
            this.flowItemBuilder(item);
          }, (item: CaseInfo) => item.caseId.toString());

        }.flowExtend();
      };

    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .scrollable(true)
    .height('calc(100% - 31vp)')
    .barHeight(0)
    .padding({ bottom: 16 })
    .animationDuration(0)
    .onChange((index: number) => {
      this.vm.curIndex = index;

    });
  }

  @Builder
  flowItemBuilder(item: CaseInfo) {
    FlowItem() {
      Column() {
        Image(item.homeCover ? $r(`app.media.${item.homeCover}`) : $r(`app.media.${item.cover}`))
          .width('100%')
          .borderRadius({
            topLeft: 16,
            topRight: 16,
          });
        Column() {
          if (item.caseType === '1') {
            Text(item.area + '㎡' + '·' + item.homeTypeLabel + '·' + item.price + '万')
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.multi_color_08'))
              .fontWeight(FontWeight.Medium);
          }
          Text(item.title)
            .fontSize($r('sys.float.Body_S'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_primary'))
            .margin({ top: 8, bottom: 12 });
          Row() {
            Row({ space: 8 }) {
              Image($r(`app.media.${item.designer.avatar}`)).width(16).height(16).borderRadius(8);
              Text(item.designer.name)
                .width(70)
                .fontSize(8)
                .textOverflow({ overflow: TextOverflow.Clip })
                .maxLines(1)
                .fontWeight(FontWeight.Regular)
                .fontColor($r('sys.color.font_secondary'))
                .fontSize($r('sys.float.Caption_M'));
            };

          }.width('100%').justifyContent(FlexAlign.SpaceBetween);
        }.padding({ top: 12, left: 12, bottom: 12 }).alignItems(HorizontalAlign.Start);

      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .borderRadius(16)
      .backgroundColor($r('sys.color.background_primary'));
    }.onClick(() => {
      RouterModule.push(RouterMap.CASE_DETAIL_PAGE, item);
    });
  }

  build() {
    NavDestination() {
      BaseHeader('首页');
      Scroll() {
        Column() {
          Column() {
            Row() {
              Row({ space: 4 }) {
                Text(this.vm.currentCity.cityName)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .constraintSize({ maxWidth: 140 })
                  .fontWeight(FontWeight.Medium)
                  .fontSize($r('sys.float.Body_M'))
                  .fontColor($r('sys.color.font_primary'));
                Image($r('app.media.ic_public_spinner_small')).width(12);
              }.padding({ right: 12 }).onClick(() => {
                RouterModule.push(RouterMap.ALL_CITY_PAGE);
              });

              Divider().vertical(true).backgroundColor('#999999').height(18);
              Row() {
                Text('请输入关键词搜索')
                  .margin({ left: 12 })
                  .fontWeight(FontWeight.Regular)
                  .fontColor('#999999')
                  .fontSize(14);
                Image($r('app.media.ic_public_search')).width(16).fillColor($r('sys.color.icon_secondary'));
              }.layoutWeight(1).justifyContent(FlexAlign.SpaceBetween).onClick(() => {
                RouterModule.push(RouterMap.SEARCH_PAGE);
              });
            }
            .width('100%')
            .height(42)
            .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
            .borderRadius(20)
            .padding(12);

          }
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            bottom: 12,
          });

          Column() {
            Image($r('app.media.home_banner')).width('100%').height(140).borderRadius(16);
            this.serverListBuilder();
            this.tabsBuilder();

          }.width('100%').padding({ left: 16, right: 16 });
        };

      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .backgroundColor($r('sys.color.background_secondary'))
      .edgeEffect(EdgeEffect.Spring)

    }.hideTitleBar(true);
  }
}


@Extend(WaterFlow)
function flowExtend() {
  .columnsGap(12)
  .rowsGap(12)
  .columnsTemplate('1fr 1fr')
  .nestedScroll({ scrollForward: NestedScrollMode.SELF_FIRST, scrollBackward: NestedScrollMode.SELF_FIRST })
  .edgeEffect(EdgeEffect.Spring)
}
