import { AccountModel, AccountUtil, FullLoading, RouterModule, UserInfo, UserInfoModel, WindowUtil } from 'common';
import { AppStorageV2, UIContext } from '@kit.ArkUI';
import { FormModel, TabListItem } from '../types/Types';
import { GetUserInfoResp, Https, UserLoginResp } from 'network';
import { TAB_CONFIG } from '../constants/Constatns';

@ObservedV2
export class MainEntryVM {
  // 页签索引
  @Trace curIndex: number = 0;
  // 用户信息
  @Trace userInfo: UserInfoModel = AccountUtil.getUserInfo();
  // 账号信息
  @Trace accountInfo: AccountModel = AccountUtil.getAccountInfo();
  // 卡片模型
  @Trace formInfo: FormModel = AppStorageV2.connect(FormModel, () => new FormModel())!;

  @Monitor('formInfo.url')
  public pageJump() {
    if (this.formInfo.url) {
      if (RouterModule.popToName(this.formInfo.url) !== -1) {
        RouterModule.replace({ url: this.formInfo.url, param: this.formInfo.license }, false);
      } else {
        RouterModule.push({ url: this.formInfo.url, param: this.formInfo.license }, false);
      }
      this.formInfo.url = '';
      this.formInfo.license = '';
    }
  }

  public controller: TabsController = new TabsController();
  public tabList: TabListItem[] = TAB_CONFIG;
  private static _instance: MainEntryVM;

  public static get instance() {
    if (!MainEntryVM._instance) {
      MainEntryVM._instance = new MainEntryVM();
    }
    return MainEntryVM._instance;
  }

  /**
   * 全局弹窗初始化(network模块依赖)
   * 开启沉浸式布局
   * 静默登录、获取用户信息
   */
  public async init(context: UIContext) {
    FullLoading.init(context);
    WindowUtil.initWindowUtil().then(() => {
      WindowUtil.setFullWindow();
    });
    AccountUtil.silentLogin().then(() => {
      this._getLoginUserInfo();
    });
  }

  /** 获取登录用户信息 **/
  private async _getLoginUserInfo() {
    const loginToken = this.accountInfo.loginToken;
    if (!loginToken) {
      const res = await Https.userLogin();
      if (res.code === 0) {
        this.accountInfo.loginToken = res.data.loginToken;
        this._initUserInfo(res.data);
      }
    } else {
      const res = await Https.getUserInfo();
      if (res.code === 0) {
        this._initUserInfo(res.data);
      }
    }
  }

  /** 更新用户信息 **/
  private _initUserInfo(data: UserLoginResp | GetUserInfoResp) {
    const info: UserInfo = {
      avatar: data.avatar,
      nickname: data.nickname,
      cellphone: data.cellphone,
    };
    AccountUtil.updateUserInfo(info);
  }
}