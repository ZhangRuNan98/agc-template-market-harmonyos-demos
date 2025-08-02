import { AggregatedSwiper } from 'aggregated_swiper';
import {
  AvoidAreaUtil,
  CommonUtils,
  FullLoadingComponent,
  HouseDetailRouteParam,
  HouseInfoTabBarModule,
  HouseInfoType,
  HouseType,
  https,
  NewHouseInfo,
  RouterModule,
  SwiperOption,
  TitleBar,
} from 'foundation';
import { Surrounding } from 'surround_facility';
import { Action } from '../components/Action';
import { BasicInfoBuilder } from '../components/BasicInfo';
import { Layouts } from '../components/Layouts';
import { NEW_HOUSE_INFO_CONTENT, FACILITY_TYPES } from '../constant/Constant';
import { HomeVM } from '../viewmodel/HomeVM';

@Builder
export function NewDetailBuilder() {
  NewDetail();
}

@Extend(Column)
function houseInfoCard() {
  .backgroundColor($r('sys.color.white')).padding(12).alignItems(HorizontalAlign.Start).borderRadius(16);
}

@Extend(Text)
function detailText(opa: number) {
  .fontSize(12).opacity(opa).fontColor($r('sys.color.black'));
}

@ComponentV2
export struct NewDetail {
  vm: HomeVM = HomeVM.instance;
  @Local newHouseSwiperOptions: SwiperOption[] = [];
  @Local detail: NewHouseInfo = new NewHouseInfo();
  @Local basicInfoTabIndex: number = 0;
  @Local isShow: boolean = false;
  @Local isFavorite: number = 0;
  @Local isLoading: boolean = true;
  @Local allowFollow: boolean = true;
  @Local selectedHouseInfoType: HouseInfoType = HouseInfoType.LAYOUT_INTRODUCTION;

  @Computed
  get totalPrice() {
    let startPrice = (this.detail.house.unit * this.detail.house.space[0]) / 10000;
    let endPrice = (this.detail.house.unit * this.detail.house.space[1]) / 10000;
    return [startPrice, endPrice];
  }

  @Computed
  get openTime() {
    let year = this.detail.house.open.getFullYear();
    let month = CommonUtils.padZero(this.detail.house.open.getMonth() + 1);
    let day = CommonUtils.padZero(this.detail.house.open.getDate());
    return [year, month, day];
  }

  @Builder
  buildTextItem(item: string, content: string) {
    Row() {
      Text(item).detailText(0.4);
      Text(content).detailText(0.9);
    };
  }

  @Builder
  swiperBuilder() {
    AggregatedSwiper({ swiperOptions: this.newHouseSwiperOptions });
  }

  @Builder
  basicInfoBuilder() {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        Text(this.detail.house.cell).fontSize(14).fontWeight(500).opacity(0.9).fontColor($r('sys.color.black'));
        Text(`${this.detail.house.status}`)
          .fontColor($r('sys.color.white'))
          .fontSize(8)
          .backgroundColor('#64BB5C')
          .borderRadius(16)
          .padding({
            left: 8,
            right: 8,
            top: 4,
            bottom: 4,
          });
      }.margin({ bottom: 6 });

      Row() {
        Text('参考价格：').detailText(0.4);
        Text(`${this.detail.house.unit}元/㎡`)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 6 })
          .fontColor($r('sys.color.black'))
          .fontColor('#E84026');
        Text(`${this.totalPrice[0].toFixed(1)}-${this.totalPrice[1].toFixed(1)}万/套`).fontColor($r('sys.color.black'))
          .margin({ left: 16 })
          .fontSize(10);
        Text(`${this.detail.house.space[0]}-${this.detail.house.space[1]}㎡`)
          .margin({ left: 6 })
          .fontSize(10)
          .fontColor($r('sys.color.black'));
      };

      this.buildTextItem('开盘时间：',
        `${this.openTime[0]}-${this.openTime[1]}-${this.openTime[2]}`);
      this.buildTextItem('用途：',
        this.detail.house.usage);
      this.buildTextItem('产权：',
        `${this.detail.house.property}年`);
      Row() {
        Text('地址：').detailText(0.4);
        Text(this.detail.house.address).detailText(0.9);
      };

      Row() {
        Text('区块：').detailText(0.4);
        Text(this.detail.house.area).margin({ left: 6 }).detailText(0.9);
      };
    }.width('100%').houseInfoCard();
  }

  @Builder
  detailInfoBuilder() {
    Column({ space: 12 }) {
      Row({ space: 24 }) {
        ForEach(NEW_HOUSE_INFO_CONTENT, (item: HouseInfoTabBarModule, index: number) => {
          Stack({ alignContent: Alignment.Center }) {
            if (this.selectedHouseInfoType === index) {
              Image($r('app.media.oval')).size({ width: 12, height: 12 });
            }
            Text(item.title)
              .fontSize(14)
              .fontWeight(this.selectedHouseInfoType === index ? FontWeight.Bold : FontWeight.Regular)
              .opacity(this.selectedHouseInfoType === index ? 0.9 : 0.4)
              .fontColor($r('sys.color.black'))
              .onClick(() => {
                this.selectedHouseInfoType = item.type;
              });
          };
        }, (item: HouseInfoTabBarModule, index: number) => item.title);
      };

      if (this.selectedHouseInfoType === HouseInfoType.LAYOUT_INTRODUCTION && this.detail.layout.length) {
        Layouts({ layouts: this.detail.layout });
      } else if (this.selectedHouseInfoType === HouseInfoType.BASIC_INFORMATION) {
        wrapBuilder(BasicInfoBuilder).builder(this.detail);
      } else {
        Surrounding({
          title: this.detail.house.cell,
          pathStack: RouterModule.stack,
          facilityOptions: FACILITY_TYPES,
        });
      }
    }.width('100%').houseInfoCard();
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
                }.padding(16);
              };
            }.height('calc(100% - 60vp)').align(Alignment.Top).edgeEffect(EdgeEffect.Spring);

            TitleBar({ title: '新房详情' });
          };

          Action({
            phone: this.detail.house.phone,
            isFavorite: this.isFavorite,
            allowFollow: this.allowFollow,
            changeFavorite: () => {
              this.isFavorite === 0 ? this.isFavorite = 1 : this.isFavorite = 0;
              this.vm.updateFavorite(this.detail.house.houseId, HouseType.NEW);
            },
          }).padding(16).position({ bottom: AvoidAreaUtil.getBottomHeight() });
        }
        .height('100%')
        .backgroundColor('#F1F3F5')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .justifyContent(FlexAlign.SpaceBetween);

        if (this.isLoading) {
          FullLoadingComponent();
        }
      };
    }.hideTitleBar(true).onReady((context: NavDestinationContext) => {
      let param = context.pathInfo.param as HouseDetailRouteParam;
      let houseId = param.houseId;
      this.allowFollow = param.allowFollow;
      // 根据houseId查询详情
      https.getNewHouseDetail(houseId).then((res) => {
        this.detail.basic = res.data.basic;
        this.detail.house = res.data.house;
        this.detail.layout = res.data.layout;
        this.isFavorite = this.detail.house.favorite;
        this.newHouseSwiperOptions = this.vm.handleNewHouseSwiper(this.detail.house);
        this.isLoading = false;
      });
    });
  }
}