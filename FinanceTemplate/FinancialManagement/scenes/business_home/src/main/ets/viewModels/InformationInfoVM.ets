import { RouterMap, RouterModule } from 'module_base';
import { INoticeItem } from 'lib_foundation';

const TAG = '[InformationInfoVM]';

@ObservedV2
export class InformationInfoVM {
  private static _instance: InformationInfoVM;
  @Trace public notice: INoticeItem | undefined

  public static get instance() {
    if (!InformationInfoVM._instance) {
      InformationInfoVM._instance = new InformationInfoVM();
    }
    return InformationInfoVM._instance;
  }

  async init() {
    const param = RouterModule.getNavParam<INoticeItem>({
      url: RouterMap.INFORMATION_INFO,
    });
    if (param) {
      this.notice = param
    }
  }
}
