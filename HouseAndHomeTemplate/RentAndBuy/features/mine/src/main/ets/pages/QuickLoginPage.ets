import { Channel, LoginService, LoginType } from 'aggregated_login';
import { AvoidAreaUtil, RouterModule } from 'foundation';

@Builder
export function QuickLoginPageBuilder() {
  QuickLoginPage();
}

@ComponentV2
export struct QuickLoginPage {
  build() {
    NavDestination() {
      Column() {
        LoginService({
          icon: $r('app.media.app_icon'),
          privacyPolicyEvent: () => {
            RouterModule.stack.pushPathByName('PrivacyPolicyPage', null);
          },
          loginBtnBgColor: '#64BB5C',
          termOfServiceEvent: () => {
            RouterModule.stack.pushPathByName('TermsOfServicePage', null);
          },
          loginTypes: [new Channel(LoginType.WECHAT, '微信登录', {
            appId: 'wxd5a474c635b8fd17',
            scope: 'snsapi_userinfo,snsapi_friend,snsapi_message,snsapi_contact',
            transaction: 'test123',
            state: 'none',
          }, $r('app.media.wechat'))],
          pathInfos: RouterModule.stack,
        });
      }.padding({ bottom: AvoidAreaUtil.getBottomHeight() });
    }.hideTitleBar(true);
  }
}