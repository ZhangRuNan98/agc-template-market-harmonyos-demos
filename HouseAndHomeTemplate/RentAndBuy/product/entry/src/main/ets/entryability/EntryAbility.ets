import { AbilityConstant, common, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AppStorageBank, AvoidAreaUtil, RouterModule } from 'foundation';
import { wXApi, wXEventHandler } from 'aggregated_login';
import { util } from '@kit.ArkTS';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    this.setColorMode(this.context);
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  getAvoidHeight(type: window.AvoidAreaType, window: window.Window) {
    return px2vp(window.getWindowAvoidArea(type).topRect.height);
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    let windowClass: window.Window = windowStage.getMainWindowSync();
    await windowClass.setWindowLayoutFullScreen(true);
    AvoidAreaUtil.setAvoidArea(this.getAvoidHeight(window.AvoidAreaType.TYPE_SYSTEM, windowClass),
      this.getAvoidHeight(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR, windowClass));

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  private setColorMode(context: common.UIAbilityContext) {
    context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onNewWant(want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    if (!want.action) {
      this.handleWeChatCallIfNeed(want);
    }
  }

  private handleWeChatCallIfNeed(want: Want) {
    wXApi.handleWant(want, wXEventHandler);
    // 模拟微信登录成功
    AppStorageBank.setUserInfo('华为用户', '', '183******12', util.generateRandomUUID());
    RouterModule.pop();
  }
};