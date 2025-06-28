import { AppStorageV2 } from '@kit.ArkUI';
import { RouterModule } from 'commonlib';
import { HomePageBuilder } from 'home';
import { MinePageBuilder } from 'mine';
import { FindPageBuilder } from 'find';
import { CustomPageBuilder } from 'custom';
import { FormCardJump, TabListItem } from '../types/Index';


const TAG: string = 'MainEntryVM';

@ObservedV2
export class MainEntryVM {
  @Trace curIndex: number = 0;
  public tabList: TabListItem[] = [
    {
      label: '首页',
      icon: $r('app.media.ic_home_off'),
      iconChecked: $r('app.media.ic_home_on'),
      component: wrapBuilder(HomePageBuilder),
    },
    {
      label: '找设计师',
      icon: $r('app.media.ic_designer_off'),
      iconChecked: $r('app.media.ic_designer_on'),
      component: wrapBuilder(FindPageBuilder),
    },
    {
      label: '定制设计',
      icon: $r('app.media.ic_custom_off'),
      iconChecked: $r('app.media.ic_custom_on'),
      component: wrapBuilder(CustomPageBuilder),
    },
    {
      label: '我的',
      icon: $r('app.media.ic_mine_off'),
      iconChecked: $r('app.media.ic_mine_on'),
      component: wrapBuilder(MinePageBuilder),
    },
  ];
  @Trace formCardJump: FormCardJump = AppStorageV2.connect(FormCardJump, () => new FormCardJump())!;
  @Trace navStack: NavPathStack = RouterModule.getStack();
  private static _instance: MainEntryVM;

  public static get instance() {
    if (!MainEntryVM._instance) {
      MainEntryVM._instance = new MainEntryVM();
    }
    return MainEntryVM._instance;
  }
}
