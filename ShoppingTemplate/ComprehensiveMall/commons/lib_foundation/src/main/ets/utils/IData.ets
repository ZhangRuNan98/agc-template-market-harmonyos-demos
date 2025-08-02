import { util } from '@kit.ArkTS';
import { UserInfoVM } from '../models/UserInfoVM';
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';

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

@ObservedV2
export class Persistence {
  @Trace
  public userToken: string = '';
}

@ObservedV2
class IData {
  @Trace
  public readonly global: GlobalStateMgr = AppStorageV2.connect(
    GlobalStateMgr,
    'GlobalStateMgr',
    () => new GlobalStateMgr(),
  )!;
  @Trace
  public readonly local: Persistence = PersistenceV2.connect(
    Persistence,
    'Persistence',
    () => new Persistence(),
  )!;
}

const iData: IData = new IData();

export { iData };
