import { AbilityConstant, common, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { AppStorageV2, PersistenceV2, ThemeControl, window } from '@kit.ArkUI';
import { cloudResPrefetch } from '@kit.CloudFoundationKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import {
  BundleUtils,
  CloudRecommendListResult,
  Logger,
  NetworkUtil,
  PushActionParams,
  PushUtils,
  RouterToNews,
  SettingModel,
  SystemBarOperation,
  WindowModel,
} from 'lib_common';
import { WXApi, WXEventHandler } from 'lib_account';
import { HomeServiceApi, RequestListData } from 'lib_news_api';
import { gAppTheme } from '../common/AppTheme';
import { SOURCE_FORM_CARD } from '../common/Constants';
import { FormCardRouterModel } from '../common/Types';

const TAG = '[PhoneAbility]';

export default class PhoneAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info(TAG, 'Ability onCreate');
    this.handlePushCall(want);
    this.handleWeChatCallIfNeed(want);
    this.handleFormCardCall(want);
    // 预加载：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/cloudfoundation-prefetch-overview
    this.functionPreload();
    // 网络解析
    this.initNetwork()
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
    this.offAvoidAreaChange();
    // 取消网络监听
    this.unRegisterNetwork()
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'Ability onWindowStageCreate');
    this.setWinConfig(windowStage);
    this.setAppTheme();
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause: ' + JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
      this.setColorMode(this.context);
      BundleUtils.getBundleInfo()
    });
  }

  onWindowStageDestroy(): void {
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onNewWant(want: Want): void {
    this.handlePushWant(want);
    this.handleWeChatCallIfNeed(want);
    this.handleFormCardCall(want);
  }

  onForeground(): void {
    Logger.info(TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    Logger.info(TAG, '%{public}s', 'Ability onBackground');
  }

  private setAppTheme() {
    ThemeControl.setDefaultTheme(gAppTheme);
  }

  private async setWinConfig(windowStage: window.WindowStage) {
    AppStorage.setOrCreate('windowStage', windowStage);
    let windowClass: window.Window = windowStage.getMainWindowSync();
    await windowClass.setWindowLayoutFullScreen(true);
    this.setAvoidArea(windowClass);
    this.onAvoidAreaChange(windowStage);
    this.setWindowSize(windowStage)
  }

  private setAvoidArea(windowClass: window.Window) {
    let windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
    let type = window.AvoidAreaType.TYPE_SYSTEM;
    let avoidArea = windowClass.getWindowAvoidArea(type);
    windowModel.windowTopPadding = px2vp(avoidArea.topRect.height);
    type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
    avoidArea = windowClass.getWindowAvoidArea(type);
    windowModel.windowBottomPadding = px2vp(avoidArea.bottomRect.height);
  }

  private functionPreload() {
    // 获取安装预加载数据
    try {
      cloudResPrefetch.getPrefetchResult(cloudResPrefetch.PrefetchMode.INSTALL_PREFETCH)
        .then((data: cloudResPrefetch.PrefetchResult) => {
          let result: RequestListData[] =
            (data.result as CloudRecommendListResult<RequestListData[]>).recommendList as RequestListData[]
          AppStorage.setOrCreate('recommendList', result)
          Logger.info('preloadTag',
            `Succeeded in getting install prefetch data, result: ${JSON.stringify(data.result)}`);
        }).catch(async (err: BusinessError) => {
        Logger.error('preloadTag', `Failed to get install prefetch data, code: ${err.code}, message: ${err.message}`);
        // 使用原有方式获取应用数据
        let recommendList = await HomeServiceApi.queryHomeRecommendList('recommend');
        AppStorage.setOrCreate('recommendList', recommendList)
      })
    } catch (err) {
      Logger.error('preloadTag', `Failed to get install prefetch data, code: ${err.code}, message: ${err.message}`);
    }
  }


  private onAvoidAreaChange(windowStage: window.WindowStage) {
    try {
      let windowClass: window.Window = windowStage.getMainWindowSync();
      windowClass.on('avoidAreaChange', () => {
        this.setAvoidArea(windowClass);
      });
    } catch (e) {
      Logger.error(TAG, 'Failed to onAvoidAreaChange. Cause: ' + JSON.stringify(e));
    }
  }

  private offAvoidAreaChange() {
    try {
      let windowStage = AppStorage.get('windowStage') as window.WindowStage;
      if (windowStage) {
        windowStage.getMainWindowSync().off('avoidAreaChange');
      }
    } catch (e) {
      Logger.error(TAG, 'Failed to offAvoidAreaChange. Cause: ' + JSON.stringify(e));
    }
  }

  private setWindowSize(windowStage: window.WindowStage) {
    let windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
    let windowClass: window.Window = windowStage.getMainWindowSync();
    windowModel.windowWidth = windowClass.getWindowProperties().windowRect.width;
    windowModel.windowHeight = windowClass.getWindowProperties().windowRect.height;
  }

  private handlePushWant(want: Want) {
    /*
    * 获取push卡片点击进入携带参数
    * */
    const articleInfo = want.parameters?.articleInfo as PushActionParams;
    if (articleInfo) {
      let articleId = articleInfo?.articleId
      let authorId = articleInfo?.authorId
      RouterToNews.routerToNewsById(articleId)
    }
  }

  private handleWeChatCallIfNeed(want: Want) {
    WXApi.handleWant(want, WXEventHandler);
  }

  private handleFormCardCall(want: Want) {
    if (want?.parameters?.source === SOURCE_FORM_CARD) {
      const formCardRouter: FormCardRouterModel =
        AppStorageV2.connect(FormCardRouterModel, () => new FormCardRouterModel())!;
      formCardRouter.id = new Date().getTime();
      formCardRouter.pageUrl = want?.parameters?.pageUrl as string ?? '';
      formCardRouter.newsId = want?.parameters?.newsId as string ?? '';
      formCardRouter.newsType = want?.parameters?.newsType as number ?? 0;
    }
  }

  private setColorMode(context: common.UIAbilityContext) {
    Logger.info('setColorMode PersistenceV2 keys: ' + JSON.stringify(PersistenceV2.keys()));
    const settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;
    const mode = settingInfo.darkSwitch ? ConfigurationConstant.ColorMode.COLOR_MODE_DARK :
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
    context.getApplicationContext().setColorMode(mode);
    SystemBarOperation.setWindowSystemBarProp({
      statusBarContentColor: settingInfo.darkSwitch ? '#ffffff' : '#ff090909',
    })
  }

  private async handlePushCall(want: Want) {
    let pushToken: string = await PushUtils.getTokenSyn()
    AppStorage.setOrCreate('pushToken', pushToken)
    const articleInfo = want.parameters?.articleInfo;
    AppStorage.setOrCreate('pushCardEntry', articleInfo)
  }

  private initNetwork() {
    let networkInstance = NetworkUtil.getInstance();
    networkInstance.init()
  }

  private unRegisterNetwork() {
    let networkInstance = NetworkUtil.getInstance();
    networkInstance.unregister()
  }
}