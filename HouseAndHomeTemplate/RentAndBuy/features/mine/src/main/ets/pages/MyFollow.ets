import {
  AppStorageBank,
  Constant,
  DETAIL_MAP,
  FullLoadingComponent,
  HouseCard,
  HouseTabBarModule,
  HOUSE_TAB,
  https,
  IBasicHouse,
  IHouseListRequest,
  Logger,
  TitleBar,
} from 'foundation';

@Builder
export function MyFollowBuilder() {
  MyFollow();
}

@ComponentV2
export struct MyFollow {
  @Local followHouseList: IBasicHouse[] = [];
  @Local houseTypeIndex: number = 0;
  @Local loading: boolean = false;

  @Computed
  get navPathName() {
    let pathName = DETAIL_MAP.get(this.houseTypeIndex);
    return pathName;
  }

  getFollowList() {
    let param: IHouseListRequest = {
      city: AppStorageBank.getCurrentCity(),
      type: this.houseTypeIndex + 1,
    };
    https.getHotHouseList(param).then((res) => {
      this.followHouseList = res.data.filter(item => item.favorite === 1) ?? [];
      this.loading = false;
      Logger.info(`follow count is ${this.followHouseList.length} with type ${this.houseTypeIndex}`);
    });
  }

  @Builder
  EmptyBuilder() {
    Column() {
      Image($r('app.media.follow_empty')).size({ height: 120, width: 120 });
      Text('您尚未关注，\n请前往浏览并关注您喜欢的房子吧')
        .fontSize(14)
        .opacity(0.4)
        .width(Constant.FULL_PERCENT)
        .textAlign(TextAlign.Center);
    }.margin({ top: 120 });
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: '我的关注' });
        if (this.loading) {
          FullLoadingComponent();
        } else {
          Column({ space: 12 }) {
            Row({ space: 24 }) {
              ForEach(HOUSE_TAB, (item: HouseTabBarModule, index: number) => {
                Stack() {
                  if (this.houseTypeIndex === index) {
                    Image($r('app.media.oval')).size({ width: 12, height: 12 });
                  }
                  Text(item.title)
                    .fontColor($r('sys.color.black'))
                    .fontSize(14)
                    .fontWeight(this.houseTypeIndex === index ? FontWeight.Bold : FontWeight.Regular)
                    .opacity(this.houseTypeIndex === index ? 0.9 : 0.6).onClick(() => {
                    // 切换先清空
                    this.loading = true;
                    this.followHouseList = [];
                    this.houseTypeIndex = index;
                    this.getFollowList();
                  });
                };
              }, (item: HouseTabBarModule, index: number) => item.title.toString());
            }.width(Constant.FULL_PERCENT).justifyContent(FlexAlign.Start);

            if (this.followHouseList.length) {
              List({ space: 12 }) {
                ForEach(this.followHouseList, (item: IBasicHouse) => {
                  ListItem() {
                    HouseCard({
                      houseOptions: {
                        house: item,
                        type: this.houseTypeIndex + 1,
                        enableEdit: false,
                        allowFollow: false
                      },
                    });
                  };
                }, (item: IBasicHouse) => item.houseId);
              };
            } else {
              this.EmptyBuilder();
            }
          }.padding(16);
        }
      }
      .height('100%')
      .backgroundColor('#F1F3F5')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
    }.hideTitleBar(true).onReady(() => {
      this.loading = true;
      this.getFollowList();
    });
  }
}