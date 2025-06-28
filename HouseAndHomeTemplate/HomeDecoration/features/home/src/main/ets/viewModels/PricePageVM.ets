import { PersistenceV2, promptAction } from '@kit.ArkUI';
import { AppStorageMap, DecorationInfo, AccountUtil, RouterModule, RouterMap } from 'commonlib';
import { AccountPriceBody } from 'network';

@ObservedV2
export class PricePageVM {
  @Trace decorationInfo: DecorationInfo =
    PersistenceV2.connect(DecorationInfo, AppStorageMap.DECORATION_INFO, () => new DecorationInfo())!;
  @Trace newDecorationInfo: DecorationInfo = new DecorationInfo();
  private static _instance: PricePageVM;

  public static get instance() {
    if (!PricePageVM._instance) {
      PricePageVM._instance = new PricePageVM();
    }
    return PricePageVM._instance;
  }


  public cloneDecorationInfo() {
    if (AccountUtil.getUserInfo().isLogin) {
      this.newDecorationInfo.address = this.decorationInfo.address;
      this.newDecorationInfo.cellName = this.decorationInfo.cellName;
      this.newDecorationInfo.area = this.decorationInfo.area;
      this.newDecorationInfo.room = this.decorationInfo.room;
      this.newDecorationInfo.hall = this.decorationInfo.hall;
      this.newDecorationInfo.washroom = this.decorationInfo.washroom;
      this.newDecorationInfo.kitchen = this.decorationInfo.kitchen;
      this.newDecorationInfo.balcony = this.decorationInfo.balcony;
      this.newDecorationInfo.homeType = this.decorationInfo.homeType;
    }
  }

  public handleDecoration() {
    const data: AccountPriceBody = {
      address: this.newDecorationInfo.address.split('/')[1],
      cellName: this.newDecorationInfo.cellName,
      area: this.newDecorationInfo.area,
      room: this.newDecorationInfo.room,
      hall: this.newDecorationInfo.hall,
      washroom: this.newDecorationInfo.washroom,
      kitchen: this.newDecorationInfo.kitchen,
      balcony: this.newDecorationInfo.balcony,
      homeType: this.newDecorationInfo.homeType,
    };
    RouterModule.push(RouterMap.LIST_PAGE, data);
  }
}
