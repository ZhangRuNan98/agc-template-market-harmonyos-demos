import util from '@ohos.util';
import { UserInfoVM } from '../../models/UserInfoVM';

@ObservedV2
export class GlobalStateMgr {
  @Trace
  public rootPageActiveTabId: string = '';

  @Trace
  public isNavPathStackEmpty: boolean = true;

  @Trace
  public cartVersion: string = util.generateRandomUUID(false);

  @Trace
  public cartTotal: number = 0;

  @Trace
  public isLogin: boolean = false;

  @Trace
  public userInfo: UserInfoVM = new UserInfoVM();

  @Trace
  public nickname: string = '';

  @Trace
  public phone: string = '';

  @Trace
  public avatar: string = '';
}
