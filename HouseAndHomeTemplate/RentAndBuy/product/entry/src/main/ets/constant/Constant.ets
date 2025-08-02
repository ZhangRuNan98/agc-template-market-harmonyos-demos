import { TabBarModule, TabBarType } from 'foundation';
import { HomeBuilder } from 'home';
import { MineBuilder } from 'mine';

export const TABS_INFO: TabBarModule[] = [
  {
    id: TabBarType.HOME,
    title: '首页',
    activeIcon: $r('app.media.home_active'),
    defaultIcon: $r('app.media.home_inactive'),
    component: wrapBuilder(HomeBuilder),
  },
  {
    id: TabBarType.MINE,
    title: '我的',
    activeIcon: $r('app.media.mine_active'),
    defaultIcon: $r('app.media.mine_inactive'),
    component: wrapBuilder(MineBuilder),
  },
];