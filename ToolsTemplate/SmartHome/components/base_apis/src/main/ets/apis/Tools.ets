import { promptAction } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';

export function prompt(str: ResourceStr) {
  promptAction.showToast({
    message: str,
    duration: 2000
  });
}

export function jumpToAppSettings(context: common.UIAbilityContext) {
  let want: Want = {
    bundleName: 'com.huawei.hmos.settings',
    abilityName: 'com.huawei.hmos.settings.MainAbility',
    uri: 'application_info_entry',
    parameters: {
      bundleName: context.abilityInfo.bundleName, // 拉起方应用包名
      pushParams: context.abilityInfo.bundleName, // 拉起方应用包名
    }
  };
  context.startAbility(want);
}