import { QuickLogin } from 'login_info';
import { RouterMap, RouterModule } from 'router_module';

@ComponentV2
export struct LoginPage {
  // 半模态or全模态
  isBindContentCover: boolean = false

  aboutToAppear(): void {
    let temp = RouterModule.getNavParam({ url: RouterMap.LOGIN_PAGE })
    if (temp) {
      this.isBindContentCover = temp as boolean
    }
  }

  build() {
    Column() {
      QuickLogin({
        isBindContentCover: this.isBindContentCover,
        icon: $r('app.media.exam_icon_login'),
        loginBtnBgColor: '#4B5CC4',
        appName: '备考',
        // 登录回调方法
        onLoginWithHuaweiID: () => {
          RouterModule.pop(false)
          this.getUIContext().getPromptAction().showToast({ message: '登陆成功', duration: 2000 });
        },
        // 备考隐私协议方法
        onPrivacyPolicy: () => {
          RouterModule.replace({ url: RouterMap.PRIVACY_PAGE })
        },
        // 用户服务协议方法
        onServicePolicy: () => {
          RouterModule.replace({ url: RouterMap.TERMS_SERVICE_PAGE })
        },
        // 华为账号用户认证协议
        onHYAccountRouter: () => {
          RouterModule.replace({ url: RouterMap.AUTHENTICATION_PAGE })
        },
        // 模态消失回调
        shouldDismiss: () => {
          let paths: string[] = RouterModule.stack.getAllPathName()
          let isExit = paths.includes(RouterMap.LOGIN_PAGE)
          if (isExit) {
            RouterModule.pop()
          }
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}

@Builder
export function LoginPageBuilder() {
  LoginPage()
}