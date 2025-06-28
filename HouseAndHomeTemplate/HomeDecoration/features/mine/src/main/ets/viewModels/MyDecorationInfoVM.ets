import { PersistenceV2, promptAction } from '@kit.ArkUI';
import { AppStorageMap, DecorationInfo } from 'commonlib';


@ObservedV2
export class MyDecorationInfoVM {
  @Trace decorationInfo: DecorationInfo =
    PersistenceV2.connect(DecorationInfo, AppStorageMap.DECORATION_INFO, () => new DecorationInfo())!;
  @Trace newDecorationInfo: DecorationInfo = new DecorationInfo();
  private static _instance: MyDecorationInfoVM;

  public static get instance() {
    if (!MyDecorationInfoVM._instance) {
      MyDecorationInfoVM._instance = new MyDecorationInfoVM();
    }
    return MyDecorationInfoVM._instance;
  }

  public cloneDecorationInfo() {
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


  public upDateDecorationInfo() {
    this.decorationInfo.upDateInfo(this.newDecorationInfo);
    promptAction.showToast({ message: '保存成功！' });
  }
}