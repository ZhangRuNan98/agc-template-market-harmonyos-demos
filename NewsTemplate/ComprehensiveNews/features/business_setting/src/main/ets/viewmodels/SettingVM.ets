import { promptAction } from '@kit.ArkUI';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { AppGalleryUtils, BaseViewModel, FileUtils, RouterMap, RouterUtils, SystemBarOperation } from 'lib_common';
import { AccountApi } from 'lib_account';
import { SettingItem } from '../types/Types';

@ObservedV2
export class SettingViewModel extends BaseViewModel {
  private accountInstance: AccountApi = new AccountApi();
  @Trace isLoading: boolean = false;
  @Trace cacheSize: string = '0';
  @Trace cacheSettingItem = new SettingItem({
    label: '清理缓存',
    extraLabel: this.getLocalCacheLabel(),
    onClick: () => {
      this.cacheSize = '0';
      this.cacheSettingItem.extraLabel = this.getLocalCacheLabel();
      FileUtils.clearCache();
      promptAction.showToast({ message: '清除缓存成功' });
    },
  })
  @Trace colorSettingItem = new SettingItem({
    label: '夜间模式',
    typeSwitch: true,
    switchV: this.settingInfo.darkSwitch,
    onClick: (isOn) => {
      this.settingInfo.darkSwitch = isOn as boolean;
      this.colorSettingItem.switchV = isOn as boolean
      this.setColorMode(this.settingInfo.darkSwitch);
    },
  });
  @Trace pushSettingItem = new SettingItem({
    label: '通知开关',
    typeSwitch: true,
    switchV: this.settingInfo.pushSwitch,
    onClick: (isOn) => {
      this.settingInfo.pushSwitch = isOn as boolean;
      this.pushSettingItem.switchV = isOn as boolean;
    },
  });
  @Trace list1: SettingItem[] = [
    new SettingItem({
      label: '个人信息',
      routerName: RouterMap.SETTING_PERSONAL,
      onClick: () => {
        if (this.userInfoModel.isLogin) {
          RouterUtils.pushPathByName(RouterMap.SETTING_PERSONAL);
        } else {
          promptAction.showToast({ message: '请先登录' });
        }
      },
    }),
    new SettingItem({
      label: '隐私设置',
      routerName: RouterMap.SETTING_PRIVACY,
    }),
  ];
  @Trace list2: SettingItem[] = [
    this.pushSettingItem,
    new SettingItem({
      label: '播放与网络设置',
      routerName: RouterMap.SETTING_NETWORK,
    }),
    this.cacheSettingItem,
  ];
  @Trace list3: SettingItem[] = [
    this.colorSettingItem,
    new SettingItem({
      label: '字体大小',
      routerName: RouterMap.SETTING_FONT,
    })
  ];
  @Trace list4: SettingItem[] = [
    new SettingItem({
      label: '检测版本',
      onClick: () => {
        const context = getContext(this) as common.UIAbilityContext;
        AppGalleryUtils.checkAppUpdate(context).then((resp: boolean) => {
          if (resp) {
            AppGalleryUtils.showUpdateDialog(context);
          } else {
            promptAction.showToast({ message: '已是最新版本' });
          }
        })
      },
    }),
    new SettingItem({
      label: '关于我们',
      routerName: RouterMap.SETTING_ABOUT,
    })
  ];

  setColorMode(isDark: boolean) {
    const mode =
      isDark ? ConfigurationConstant.ColorMode.COLOR_MODE_DARK : ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
    getContext().getApplicationContext().setColorMode(mode);
    SystemBarOperation.setWindowSystemBarProp({
      statusBarContentColor:isDark?'#ffffff':'#ff090909'
    })
  }

  getCache() {
    FileUtils.getCache().then((resp: number) => {
      this.cacheSize = (resp / 1024 / 1024).toFixed(2);
      this.cacheSettingItem.extraLabel = this.getLocalCacheLabel();
    })
  }

  getLocalCacheLabel() {
    return `${this.cacheSize}M`;
  }

  onSignOutBtnClick() {
    this.isLoading = true;
    this.accountInstance.signOut()
      .then(() => {
        promptAction.showToast({ message: '已退出登录' });
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  @Computed get signOutBtnLabel() {
    if(this.isLoading) {
      return '正在退出登录...'
    }
    return '退出登录'
  }

}