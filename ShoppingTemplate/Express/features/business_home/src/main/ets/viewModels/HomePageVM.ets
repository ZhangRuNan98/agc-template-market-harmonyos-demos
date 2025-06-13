import { UserInfo } from 'lib_foundation';
import { AppStorageV2 } from '@kit.ArkUI';

const TAG = '[HomePageVM]';

@ObservedV2
export class HomePageVM {
  private static _instance: HomePageVM;
  @Trace public isLogin: boolean = false
  @Trace userInfo: UserInfo = AppStorageV2.connect(UserInfo, () => new UserInfo())!;

  @Monitor('userInfo.id')
  onChange(monitor: IMonitor) {
    const id = monitor.value()?.now as number;
    if (id === 0) {
      this.isLogin = false
    } else {
      this.isLogin = true
    }
  }

  public static get instance() {
    if (!HomePageVM._instance) {
      HomePageVM._instance = new HomePageVM();
    }
    return HomePageVM._instance;
  }
}
