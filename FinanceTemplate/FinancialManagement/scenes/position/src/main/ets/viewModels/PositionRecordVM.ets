import { https, IPositionInfo, IPositionRecord } from 'lib_foundation';
import { AccountUtil, RouterMap, RouterModule, UserInfoModel, } from 'module_base';

@ObservedV2
export class PositionRecordVM {
  private static _instance: PositionRecordVM;
  @Trace userInfo: UserInfoModel = AccountUtil.getUserInfo();
  @Trace positionRecord: IPositionRecord[] = []
  @Trace public positionInfo: IPositionInfo | undefined

  public static get instance() {
    if (!PositionRecordVM._instance) {
      PositionRecordVM._instance = new PositionRecordVM();
    }
    return PositionRecordVM._instance;
  }

  init() {
    const param = RouterModule.getNavParam<IPositionInfo>({
      url: RouterMap.POSITION_RECORD,
    });
    if (param) {
      this.positionInfo = param
      this.getPositionRecord(this.userInfo.id, this.positionInfo.id)
    }
  }

  public async getPositionRecord(userId: number, id: number) {
    const res = await https.getPositionRecord({ userId, id });
    if (res.code === 0) {
      this.positionRecord = res.data;
    }
  }
}
