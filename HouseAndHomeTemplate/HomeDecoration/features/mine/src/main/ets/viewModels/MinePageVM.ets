import { SettingItem, ServerItem } from '../types/Index';
import { AccountUtil, RouterMap, UserInfo } from 'commonlib';
import { UrlMap } from 'module_posting';


const TAG = '[MinePageVM]';

@ObservedV2
export class MinePageVM {
  @Trace isShow: boolean = false;
  @Trace serverList: ServerItem[] =
    [
      { icon: $r('app.media.ic_book'), label: '我的装修信息' },
      { icon: $r('app.media.ic_star'), label: '我的收藏' },
      { icon: $r('app.media.ic_server'), label: '联系客服' },
      { icon: $r('app.media.ic_feedback'), label: '意见反馈' },
      { icon: $r('app.media.ic_setting'), label: '设置' }];
  @Trace pageList: (RouterMap | string)[] =
    [RouterMap.MY_DECORATION_INFO, RouterMap.MY_COLLECTION, '', UrlMap.FEEDBACK_PAGE, RouterMap.SETTINGS_PAGE];
  @Trace settingList: SettingItem[] =
    [
      { label: '隐私政策', page: RouterMap.TERMS_OF_SERVICE_PAGE },
      { label: '用户协议', page: RouterMap.PRIVACY_POLICY_PAGE },
    ];
  @Trace userInfo: UserInfo = AccountUtil.getUserInfo();
  @Trace authCode: string = '';
  private static _instance: MinePageVM;

  public static get instance() {
    if (!MinePageVM._instance) {
      MinePageVM._instance = new MinePageVM();
    }
    return MinePageVM._instance;
  }

  logout() {
    // 退出登录并清除登录信息
    this.userInfo.id = 0;
    this.userInfo.avatar = '';
    this.userInfo.name = '';
    this.userInfo.nickname = '';
    this.userInfo.sex = '';
    this.userInfo.cellphone = '';
    this.userInfo.birthday = '';
    this.userInfo.code = '';
    this.userInfo.isLogin = false;
  }
}
