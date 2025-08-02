import { https, IUserAccount, MockStorageMap } from 'lib_foundation';
import { AccountUtil, RouterModule, UserInfoModel, } from 'module_base';
import { emitter } from '@kit.BasicServicesKit';

@ObservedV2
export class OtherVM {
  private static _instance: OtherVM;
  @Trace userInfo: UserInfoModel = AccountUtil.getUserInfo();
  @Trace public account: IUserAccount = {
    id: 0,
    userId: 0,
    bankName: '',
    bankCardNo: '',
    bankAmount: 0,
    positionAmount: 0,
    accumulatedEarnings: 0,
  }
  @Trace public isOn: boolean = false

  public static get instance() {
    if (!OtherVM._instance) {
      OtherVM._instance = new OtherVM();
    }
    return OtherVM._instance;
  }

  init() {
    const userAccountMockData = AppStorage.get<IUserAccount>(MockStorageMap.USER_ACCOUNT);
    if (userAccountMockData) {
      this.account = userAccountMockData
      this.isOn = true
    }
  }

  public async getUserAccount(userId: number) {
    const res = await https.getUserAccount(userId);
    if (res.code === 0) {
      this.account = res.data;
    }
  }

  public cancelRelated() {
    this.isOn = false
    const account: IUserAccount = {
      id: 0,
      userId: 0,
      bankName: '',
      bankCardNo: '',
      bankAmount: 0,
      positionAmount: 0,
      accumulatedEarnings: 0,
    }
    AppStorage.setOrCreate<IUserAccount>(MockStorageMap.USER_ACCOUNT, account);
  }

  public async logout() {
    await https.userLogout();
    AppStorage.set<boolean>('isLogin', false)
    let data: emitter.EventData = {
      data: {
        isLogin: false,
      }
    };
    emitter.emit('isLogin', data);
    RouterModule.pop()
  }
}
