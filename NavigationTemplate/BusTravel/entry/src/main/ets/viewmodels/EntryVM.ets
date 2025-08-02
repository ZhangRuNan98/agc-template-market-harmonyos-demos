import { TabInfo, RouterModule } from 'common'
import { homeTabInfo } from '../dataModel/HomeTab'


@ObservedV2
export class EntryVM {
  @Trace currentIndex: number = 0;
  @Trace homeTabList: TabInfo[] = homeTabInfo;
  @Trace pageStack: NavPathStack = RouterModule.stack;
  private static _instance: EntryVM;

  // 获取实例
  public static get instance() {
    if (!EntryVM._instance) {
      EntryVM._instance = new EntryVM();
    }
    return EntryVM._instance;
  }
}