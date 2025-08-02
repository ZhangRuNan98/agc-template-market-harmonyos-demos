import { display } from '@kit.ArkUI';
import { AggregatedSwiper } from 'aggregated_swiper';
import {
  AvoidAreaUtil,
  Constant,
  HouseInfoTabBarModule,
  HouseInfoType,
  HouseType,
  https,
  SecondHouseInfo,
  SwiperOption,
  RouterModule,
  TitleBar,
  FullLoadingComponent,
  HouseDetailRouteParam,
} from 'foundation';
import { Surrounding } from 'surround_facility';
import { Action } from '../components/Action';
import { BasicInfoBuilder } from '../components/BasicInfo';
import { ValueBuilder } from '../components/Value';
import { SECOND_HOUSE_INFO_CONTENT, FACILITY_TYPES } from '../constant/Constant';
import { HomeVM } from '../viewmodel/HomeVM';

@Builder
export function SecondDetailBuilder() {
  SecondDetail();
}

@Extend(Column)
function detailCard() {
  .backgroundColor($r('sys.color.white')).padding(12).borderRadius(16);
}

@Extend(Text)
function detailText(opa: number) {
  .fontSize(12).opacity(opa).fontColor($r('sys.color.black'));
}

@ComponentV2
export struct SecondDetail {
  vm: HomeVM = HomeVM.instance;
  @Local isLoading: boolean = true;
  @Local isFavorite: number = 0;
  @Local detail: SecondHouseInfo = new SecondHouseInfo();
  @Local secondHouseSwiperOptions: SwiperOption[] = [];
  @Local allowFollow: boolean = true;
  @Local isShow: boolean = false;
  @Local selectedHouseInfoType: HouseInfoType = HouseInfoType.VALUE_EVALUATION;
  @Local foldStatus: display.FoldStatus = 0;

  aboutToAppear(): void {
    this.foldStatus = display.getFoldStatus();
  }

  @Builder
  buildDetailItem(item: string, content: ResourceStr) {
    GridItem() {
      Row() {
        Text(item).fontSize(12).opacity(0.4);
        Text(content).opacity(0.9).margin({ left: 6 }).fontSize(12);
      }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
    };
  }

  @Builder
  buildBasicItem(icon: Resource, content: string, title: string) {
    Row({ space: 8 }) {
      Image(icon).size({ width: 16, height: 16 });
      Column({ space: 4 }) {
        Text(content).fontSize(14).fontWeight(600).fontColor('#E84026');
        Text(title).fontSize(10);
      };
    };
  }

  @Builder
  basicInfoBuilder() {
    Column({ space: 12 }) {
      Row() {
        Text(this.detail.house.title)
          .width('80%')
          .fontSize(14)
          .opacity(0.9)
          .fontWeight(500)
          .fontColor($r('sys.color.black'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis });
        Image($r('app.media.sale')).size({ width: 44, height: 44 });
      }.width(Constant.FULL_PERCENT).justifyContent(FlexAlign.SpaceBetween);

      Row() {
        Row({ space: 8 }) {
          Image($r('app.media.total')).size({ width: 16, height: 16 });
          Column({ space: 4 }) {
            Text(`${this.detail.house.total[0]}万`).fontSize(14).fontWeight(FontWeight.Bold).fontColor('#E84026');
            Text('参考价格').fontSize(10).opacity(0.4);
          };
        };

        Row({ space: 8 }) {
          Image($r('app.media.layout')).size({ width: 16, height: 16 });
          Column({ space: 4 }) {
            Text(`${this.detail.house.bedroom}室${this.detail.house.lounge}厅${this.detail.house.bathroom}卫`)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#E84026');
            Text('房型').fontSize(10).opacity(0.4);
          };
        };

        Row({ space: 8 }) {
          Image($r('app.media.space')).size({ width: 16, height: 16 });
          Column({ space: 4 }) {
            Text(`${this.detail.house.space[0]}㎡`).fontSize(14).fontWeight(FontWeight.Bold).fontColor('#E84026');
            Text('建筑面积').fontSize(10).opacity(0.4);
          };
        };
      }.width(Constant.FULL_PERCENT).justifyContent(FlexAlign.SpaceBetween);

      Row({ space: 8 }) {
        ForEach(this.detail.house.labels, (item: string, index: number) => {
          Text(item)
            .fontSize(8)
            .borderRadius(16)
            .fontColor($r('sys.color.black'))
            .backgroundColor(index === 0 ? '#64BB5C' : 'rgba(0,0,0,0.10)')
            .padding({
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            });
        }, (item: string, index: number) => item);
      }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
    }.detailCard();
  }

  @Builder
  extraInfoBuilder() {
    Column({ space: 12 }) {
      Row({ space: 24 }) {
        ForEach(SECOND_HOUSE_INFO_CONTENT, (item: HouseInfoTabBarModule) => {
          Stack() {
            if (this.selectedHouseInfoType === item.type) {
              Image($r('app.media.oval')).size({ width: 12, height: 12 });
            }
            Text(item.title)
              .fontWeight(this.selectedHouseInfoType === item.type ? FontWeight.Bold : FontWeight.Regular)
              .opacity(this.selectedHouseInfoType === item.type ? 0.9 : 0.4).fontColor($r('sys.color.black'));
          }.onClick(() => {
            this.selectedHouseInfoType = item.type;
          });
        }, (item: HouseInfoTabBarModule) => item.title);
      }.width(Constant.FULL_PERCENT);

      if (this.selectedHouseInfoType === HouseInfoType.VALUE_EVALUATION) {
        wrapBuilder(ValueBuilder).builder(this.detail);
      } else if (this.selectedHouseInfoType === HouseInfoType.BASIC_INFORMATION) {
        wrapBuilder(BasicInfoBuilder).builder(this.detail);
      } else {
        Surrounding({
          title: this.detail.house.cell, pathStack: RouterModule.stack, facilityOptions: FACILITY_TYPES,
        });
      }
    }.detailCard();
  }

  @Builder
  detailInfoBuilder() {
    Column() {
      Grid() {
        GridItem() {
          Row() {
            Text('单价：').detailText(0.4);
            Text(`${this.detail.house.unit}元/㎡`).margin({ left: 6 }).detailText(0.9);
          }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
        };

        GridItem() {
          Row() {
            Text('预算：').detailText(0.4);
            Text(`首付${(this.detail.house.total[0] * 0.3).toFixed(1)}万`)
              .margin({ left: 6 })
              .detailText(0.9);
          }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
        };

        GridItem() {
          Row() {
            Text('楼层：').detailText(0.4);
            Text(`高层（${this.detail.house.floor}）层`).margin({ left: 6 }).detailText(0.9);
          }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
        };

        GridItem() {
          Row() {
            Text('税费：').detailText(0.4);
            Text(`合计约${(this.detail.house.total[0] * 0.015).toFixed(1)}万`)
              .margin({ left: 6 })
              .detailText(0.9);
          }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
        };

        GridItem() {
          Row() {
            Text('朝向：').detailText(0.4);
            Text(`${this.detail.house.orientation}`).margin({ left: 6 }).detailText(0.9);
          }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
        };

        GridItem() {
          Row() {
            Text('小区：').detailText(0.4);
            Text(`${this.detail.house.cell}`)
              .margin({ left: 6 })
              .width(this.foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED ? 100 : 200)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .detailText(0.9);
          }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
        };

        GridItem() {
          Row() {
            Text('类型：').detailText(0.4);
            Text(`${this.detail.house.usage}`).margin({ left: 6 }).detailText(0.9);
          }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
        };

        GridItem() {
          Row() {
            Text('周边：').detailText(0.4);
            Text(`${this.detail.house.around}`).margin({ left: 6 }).detailText(0.9);
          }.justifyContent(FlexAlign.Start).width(Constant.FULL_PERCENT);
        };
      }.rowsGap(8).columnsTemplate('1fr 1fr').edgeEffect(EdgeEffect.Spring);
    }.detailCard().height(112).justifyContent(FlexAlign.Center);
  }

  @Builder
  swiperBuilder() {
    AggregatedSwiper({ swiperOptions: this.secondHouseSwiperOptions });
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Stack({ alignContent: Alignment.TopStart }) {
            Scroll() {
              Column() {
                this.swiperBuilder();
                Column({ space: 12 }) {
                  this.basicInfoBuilder();
                  this.detailInfoBuilder();
                  this.extraInfoBuilder();
                }.padding(16);
              };
            }.height('calc(100% - 60vp)').align(Alignment.Top).scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring);

            TitleBar({ title: '好房详情' });
          };

          Action({
            phone: this.detail.house.phone,
            isFavorite: this.isFavorite,
            allowFollow: this.allowFollow,
            changeFavorite: () => {
              this.isFavorite === 0 ? this.isFavorite = 1 : this.isFavorite = 0;
              this.vm.updateFavorite(this.detail.house.houseId, HouseType.SECOND);
            },
          }).padding(16).position({ bottom: AvoidAreaUtil.getBottomHeight() });
        }
        .height(Constant.FULL_PERCENT)
        .backgroundColor('#F1F3F5')
        .justifyContent(FlexAlign.SpaceBetween)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);

        if (this.isLoading) {
          FullLoadingComponent();
        }
      };
    }.hideTitleBar(true).onReady((context: NavDestinationContext) => {
      let param = context.pathInfo.param as HouseDetailRouteParam;
      let houseId = param.houseId;
      this.allowFollow = param.allowFollow;
      // 根据houseId查询详情
      https.getSecondHouseDetail(houseId).then((res) => {
        this.detail.house = res.data.house;
        this.detail.basic = res.data.basic;
        this.isFavorite = this.detail.house.favorite;
        this.secondHouseSwiperOptions = this.vm.handleSecondHouseSwiper(this.detail.house);
        this.isLoading = false;
      });
    });
  }
}