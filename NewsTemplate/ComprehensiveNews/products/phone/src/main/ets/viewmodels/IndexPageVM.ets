import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { BaseViewModel, NewsEnum, RouterMap, RouterToNews, RouterUtils } from 'lib_common';
import { AccountApi } from 'lib_account';
import { CustomTransition } from 'module_swipeplayer';
import { FormCardRouterModel } from '../common/Types';
import { NEWS_DETAIL_PAGE, TabBarType } from '../common/Constants';

@ObservedV2
export class IndexPageViewModel extends BaseViewModel {
  @Trace translateY: string | number = '';
  @Trace tabPaddingBottom: Length = '';
  @Trace firstBackTime: number = 0;
  public pageId: number = -1;
  @Trace formCardRouter: FormCardRouterModel =
    AppStorageV2.connect(FormCardRouterModel, () => new FormCardRouterModel())!;

  @Monitor('tabModel.showTabBar')
  onChangeShowTabBar(monitor: IMonitor) {
    let isShowCustomTabBar = monitor.value()?.now as boolean
    if (isShowCustomTabBar) {
      this.translateY = ''
    } else {
      this.translateY = '100%'
    }
  }

  @Monitor('formCardRouter.id')
  onFormCardClick() {
    this.checkJumpNewsDetail();
  }

  refreshUserInfo() {
    new AccountApi().queryUserInfo();
  }

  checkJumpNewsDetail() {
    if (this.formCardRouter.id && this.formCardRouter.newsId && this.formCardRouter.pageUrl === NEWS_DETAIL_PAGE) {
      RouterUtils.popToName(RouterMap.INDEX_PAGE, undefined, false);
      let routerParams: Record<string, string | NewsEnum> = {
        'type': this.formCardRouter.newsType,
        'newsId': this.formCardRouter.newsId,
      }
      RouterToNews.pushToNewsDetails(routerParams)
      this.formCardRouter.id = 0;
    }
  }

  onReady(context: NavDestinationContext) {
    if (context.pathStack.getAllPathName()?.length) {
      this.pageId = context.pathStack.getAllPathName().length - 1;
    }
    // 注册自定义动画协议
    CustomTransition.getInstance().registerNavParam(this.pageId,
      (isPush: boolean, isExit: boolean, transitionProxy: NavigationTransitionProxy) => {
      }, 500);
  }

  onDisAppear() {
    CustomTransition.getInstance().unRegisterNavParam(this.pageId);
  }

  onBackPressed() {
    // 视频tab，返回前要重置showTabBar状态
    if (this.tabModel.selectedIndex === TabBarType.VIDEO) {
      this.tabModel.showTabBar = true;
    }
    let nowTime = Date.now();
    if (nowTime - this.firstBackTime < 1500) {
      return false;
    } else {
      this.firstBackTime = nowTime;
      promptAction.showToast({ message: '再按一次退出' });
      return true;
    }
  }
}