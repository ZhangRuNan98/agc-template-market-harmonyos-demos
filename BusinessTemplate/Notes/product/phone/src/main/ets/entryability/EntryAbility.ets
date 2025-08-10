/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Configuration, UIAbility } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { ThemeController } from '../controller/ThemeController';
import { AppUtil, WindowUtil } from '@ohos_agcit/notes_utils';
import { notificationManager } from '@kit.NotificationKit';
import { SettingController } from '../controller/SettingController';

export default class EntryAbility extends UIAbility {
  private themeController: ThemeController = ThemeController.instance;
  private settingController: SettingController = SettingController.instance;

  onCreate(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    AppUtil.init(this.context)
    this.themeController.currentColorMode = this.context.config.colorMode;
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  initWindow(windowStage: window.WindowStage) {
    let windowClass: window.Window = windowStage.getMainWindowSync();
    let size = windowClass.getWindowProperties().windowRect;

    AppStorage.setOrCreate('screenHeight', px2vp(size.height));
    AppStorage.setOrCreate('screenWidth', px2vp(size.width));

    windowClass.on('windowSizeChange', data => {
      AppStorage.setOrCreate('screenHeight', px2vp(data.height));
      AppStorage.setOrCreate('screenWidth', px2vp(data.width));
    });
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    // 一多适配-折叠屏
    WindowUtil.registerBreakPoint(windowStage);
    this.initWindow(windowStage);
    let windowClass: window.Window = windowStage.getMainWindowSync();
    // 隐藏底部导航栏
    windowClass.setSpecificSystemBarEnabled('navigationIndicator', false).then(() => {
      console.info('Succeeded in setting the navigation indicator to be invisible.');
    }).catch((err: BusinessError) => {
      console.error(`Failed to set the navigation indicator to be invisible. Code is ${err.code}, message is ${err.message}`);
    });

    windowStage.loadContent('pages/Index', (err) => {
      windowStage.getMainWindowSync().getUIContext().getKeyboardAvoidMode();
      windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);

      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // 判断是否通知授权
    let isEnabled = notificationManager.isNotificationEnabled();
    isEnabled.then(result => {
      this.settingController.isNoticeGrant =  result;
    })
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  /**
   * 夜间模式
   * @param newConfig
   */
  onConfigurationUpdate(newConfig: Configuration): void {
    if (this.themeController.currentColorMode !== newConfig.colorMode &&
      this.themeController.isFollowSystemSetting) {
      this.themeController.currentColorMode = newConfig.colorMode;
    }
  }
}