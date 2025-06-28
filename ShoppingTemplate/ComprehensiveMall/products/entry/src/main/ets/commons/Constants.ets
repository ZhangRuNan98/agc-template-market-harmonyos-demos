import { buildCartPage } from '@scene/shopping';
import { buildCategoryPage } from '../pages/CategoryPage';
import { buildHomePage } from '../pages/HomePage';
import { buildProfilePage } from '../pages/ProfilePage';
import { TabSwiperDataItem } from './Types';

export class IndexData {
  public static readonly STATIC_TAB_SWIPER_DATA: TabSwiperDataItem[] = [
    {
      id: 'HomePage',
      priority: 1,
      tabModel: {
        label: '首页',
        activeIcon: $r('app.media.ic_tab_active_home'),
        inactiveIcon: $r('app.media.ic_tab_inactive_home'),
      },
      contentWarpBuilder: wrapBuilder(buildHomePage),
    },
    {
      id: 'CategoryPage',
      priority: 0,
      tabModel: {
        label: '分类',
        activeIcon: $r('app.media.ic_tab_active_category'),
        inactiveIcon: $r('app.media.ic_tab_inactive_category'),
      },
      contentWarpBuilder: wrapBuilder(buildCategoryPage),
    },
    {
      id: 'CartPage',
      priority: 0,
      tabModel: {
        label: '购物车',
        activeIcon: $r('app.media.ic_tab_active_cart'),
        inactiveIcon: $r('app.media.ic_tab_inactive_cart'),
      },
      contentWarpBuilder: wrapBuilder(buildCartPage),
    },
    {
      id: 'ProfilePage',
      priority: 0,
      tabModel: {
        label: '我的',
        activeIcon: $r('app.media.ic_tab_active_profile'),
        inactiveIcon: $r('app.media.ic_tab_inactive_profile'),
      },
      contentWarpBuilder: wrapBuilder(buildProfilePage),
    },
  ];
}
