import {
  AppStorageBank,
  Constant,
  HouseCard,
  HouseType,
  HOUSE_MAP,
  https,
  IBasicHouse,
  IHouseListRequest,
  TitleBar,
} from 'foundation';

@Builder
export function HouseListBuilder() {
  HouseList();
}

@ComponentV2
export struct HouseList {
  @Local houseList: IBasicHouse[] = [];
  @Local type: HouseType = 0;

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: HOUSE_MAP.get(this.type) });
        List({ space: 12 }) {
          ForEach(this.houseList, (item: IBasicHouse) => {
            ListItem() {
              HouseCard({
                houseOptions: {
                  house: item,
                  type: this.type,
                  enableEdit: false,
                  allowFollow: true
                },
              });
            };
          }, (item: IBasicHouse) => item.houseId);
        }.padding(16).height(Constant.FULL_PERCENT);
      }.backgroundColor('#F1F3F5').expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
    }.onReady((context: NavDestinationContext) => {
      this.type = context.pathInfo.param as HouseType;
      let param: IHouseListRequest = {
        city: AppStorageBank.getCurrentCity(),
        type: this.type,
      };
      https.getHotHouseList(param).then((res) => {
        this.houseList = res.data;
      });
    }).hideTitleBar(true);
  }
}