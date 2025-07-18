import { window } from '@kit.ArkUI';
import { Channel, LoginService, LoginType } from 'module_login';
import { AccountUtil, RouterMap, RouterModule, UserInfo, WindowUtil } from 'commonlib';


@Builder
export function QuickLoginPageBuilder() {
  QuickLoginPage();
}

@ComponentV2
export struct QuickLoginPage {
  @Local nextRouter: string = '';

  aboutToAppear(): void {
    this.getRouterParams();
    let systemBarProperties: window.SystemBarProperties = {
      statusBarContentColor: '#000000',
    };
    WindowUtil.currentWindow.setWindowSystemBarProperties(systemBarProperties);
  }

  getRouterParams() {
    const params: Record<string, string> | undefined = RouterModule.getNavParam(RouterMap.QUICK_LOGIN_PAGE);
    if (params?.url) {
      this.nextRouter = params.url;
    }
  }

  build() {
    NavDestination() {
      Scroll() {
        LoginService({
          icon: $r('app.media.ic_app'),
          privacyPolicyEvent: () => {
            RouterModule.push(RouterMap.PRIVACY_POLICY_PAGE);
          },
          loginBtnBgColor: $r('sys.color.alert'),
          termOfServiceEvent: () => {
            RouterModule.push(RouterMap.TERMS_OF_SERVICE_PAGE);
          },
          // todo: 替换微信登录配置信息
          loginTypes: [new Channel(LoginType.WECHAT, '微信登录', {
            appId: 'wxd5a474c635b8fd17',
            scope: 'snsapi_userinfo,snsapi_friend,snsapi_message,snsapi_contact',
            transaction: 'test123',
            state: 'none',
          }, $r('app.media.wechat'))],
          loginFinishedCb: (flag: boolean, unionID?: string) => {
            // 模板忽略登录失败场景
            this.loginSuccess(unionID || '0');
          },
        });
      }.backgroundColor($r('sys.color.background_secondary')).height('100%').scrollBar(BarState.Off)
    }
    .hideTitleBar(true)
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });
  }

  loginSuccess(unionID: string) {
    // 模拟登录
    let data: UserInfo = {
      id: 0,
      avatar: 'default_avatar',
      name: '华为用户',
      nickname: '华为用户',
      sex: '',
      cellphone: '130****0000',
      birthday: '',
      code: unionID,
      isLogin: true,
    };
    AccountUtil.updateUserInfo(data);
    if (this.nextRouter) {
      RouterModule.replace(this.nextRouter);
    } else {
      RouterModule.pop();
    }
  }
}