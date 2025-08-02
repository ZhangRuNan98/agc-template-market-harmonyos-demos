import { MapComponent } from '@kit.MapKit';
import { AggregatedSwiper } from 'aggregated_swiper';
import {
  AvoidAreaUtil,
  Constant,
  FullLoadingComponent,
  HouseDetailRouteParam,
  HouseType,
  https,
  RentHouseInfo,
  SwiperOption,
  TitleBar,
} from 'foundation';
import { MapUtil } from 'module_base';
import { Action } from '../components/Action';
import { HomeVM } from '../viewmodel/HomeVM';

@Builder
export function RentDetailBuilder() {
  RentDetail();
}

@Extend(Text)
function detailText(opa: number) {
  .fontSize(12).opacity(opa).fontColor($r('sys.color.black'));
}

@Extend(Column)
function detailCard() {
  .backgroundColor($r('sys.color.white')).padding(12).borderRadius(16);
}

@ComponentV2
export struct RentDetail {
  vm: HomeVM = HomeVM.instance;
  mu: MapUtil = MapUtil.instance;
  @Local isLoading: boolean = true;
  @Local rentHouseSwiperOptions: SwiperOption[] = [];
  @Local detail: RentHouseInfo = new RentHouseInfo();
  @Local isFavorite: number = 0;
  @Local isShow: boolean = false;
  @Local allowFollow: boolean = true;
  @Local title: string = '';

  @Builder
  mapInfoBuilder() {
    Column({ space: 8 }) {
      Text(this.detail.house.cell)
        .fontSize(14)
        .opacity(0.9)
        .width(Constant.FULL_PERCENT)
        .textAlign(TextAlign.Start)
        .fontColor($r('sys.color.black'));
      MapComponent({
        mapOptions: this.mu.mapOptions,
        mapCallback: this.mu.callback,
      }).height(135);
    }.detailCard().height(182);
  }

  @Builder
  facilityInfoBuilder() {
    Column({ space: 12 }) {
      Row() {
        Text('看房时间：').detailText(0.4);
        Text(this.detail.house.viewTime).detailText(0.9);
      }.width(Constant.FULL_PERCENT).justifyContent(FlexAlign.Start);

      Row() {
        Text('入住要求：').detailText(0.4);
        Text(this.detail.house.requirement).detailText(0.9);
      }.width(Constant.FULL_PERCENT).justifyContent(FlexAlign.Start);

      Column() {
        Grid() {
          ForEach(this.detail.house.supplement, (item: string) => {
            GridItem() {
              Text(`${item}√`).detailText(0.9).width(Constant.FULL_PERCENT).textAlign(TextAlign.Start);
            };
          }, (item: string) => item);
        }.rowsGap(8).columnsTemplate('1fr 1fr 1fr 1fr');
      };
    }.height('auto').detailCard();
  }

  @Builder
  basicInfoBuilder() {
    Column({ space: 12 }) {
      Text(this.detail.house.title)
        .width('100%')
        .textAlign(TextAlign.Start)
        .fontColor($r('sys.color.black'))
        .fontSize(14)
        .opacity(0.9)
        .fontWeight(500)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis });

      Row({ space: 4 }) {
        Text(`${this.detail.house.unit}/月`).fontSize(14).fontWeight(FontWeight.Bold).fontColor('#E84026');
        Text(this.detail.house.payMethod).fontSize(10).opacity(0.4).fontColor($r('sys.color.black'));
      }.width(Constant.FULL_PERCENT).justifyContent(FlexAlign.Start);

      Row() {
        Row() {
          Text('户型：').detailText(0.4);
          Text(`${this.detail.house.bedroom}室${this.detail.house.lounge}厅`)
            .margin({ left: 6 })
            .detailText(0.9);
        };

        Row() {
          Text('面积：').detailText(0.4);
          Text(`${this.detail.house.space[0]}㎡`).margin({ left: 6 }).detailText(0.9);
        }.width(100);
      }.width(Constant.FULL_PERCENT).justifyContent(FlexAlign.SpaceBetween);

      Row() {
        Row() {
          Text('楼层：').detailText(0.4);
          Text(`低/${this.detail.house.floor}层`).margin({ left: 6 }).detailText(0.4);
        };

        Row() {
          Text('朝向：').detailText(0.4);
          Text(`${this.detail.house.orientation}`).margin({ left: 6 }).detailText(0.9);
        }.width(100);
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
  swiperBuilder() {
    AggregatedSwiper({ swiperOptions: this.rentHouseSwiperOptions });
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
                  this.mapInfoBuilder();
                  this.facilityInfoBuilder();
                }.padding(16);
              };
            }.height('calc(100% - 60vp)').align(Alignment.Top).scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring);

            TitleBar({ title: this.title });
          };

          Action({
            phone: this.detail.house.phone,
            isFavorite: this.isFavorite,
            allowFollow: this.allowFollow,
            changeFavorite: () => {
              this.isFavorite === 0 ? this.isFavorite = 1 : this.isFavorite = 0;
              this.vm.updateFavorite(this.detail.house.houseId, HouseType.RENT);
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
      https.getRentHouseDetail(houseId).then((res) => {
        this.detail.house = res.data.house;
        this.title = this.detail.house.title;
        this.isFavorite = this.detail.house.favorite;
        this.rentHouseSwiperOptions = this.vm.handleRentHouseSwiper(this.detail.house);
        this.mu.drawHousePoint(this.detail.house.cell);
        this.isLoading = false;
      });
    });
  }
}