import { loginComponentManager } from '@kit.AccountKit';
import { Constants } from 'utils';
import { QuickLogin } from 'login';
import { AppStorageV2 } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';

@Builder
export function QuickLoginPageBuilder(name: string, param: Object) {
  QuickLoginPage();
}

class Sample {
  value: boolean = false;

  constructor(value: boolean) {
    this.value = value
  }
}

@ComponentV2
export struct QuickLoginPage {
  pathStack: NavPathStack = new NavPathStack();
  privacyText: loginComponentManager.PrivacyText[] = [{
    text: $r('app.string.agree'),
    type: loginComponentManager.TextType.PLAIN_TEXT
  }, {
    text: $r('app.string.shopping_user_agreement'),
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: $r('app.string.and'),
    type: loginComponentManager.TextType.PLAIN_TEXT
  }, {
    text: $r('app.string.shopping_privacy_policy'),
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: $r('app.string.end'),
    type: loginComponentManager.TextType.PLAIN_TEXT
  }];

  build() {
    NavDestination() {
      Scroll() {
        QuickLogin({
          privacyText: this.privacyText,
          clickPrivacyCallBack: (text: ResourceStr) => {
            if ((text as Resource).id === $r('app.string.shopping_user_agreement').id) {
              this.pathStack.pushPathByName('TermsOfServicePage', null);
            } else if ((text as Resource).id === $r('app.string.shopping_privacy_policy').id) {
              this.pathStack.pushPathByName('PrivacyPolicyPage', null);
            }
          },
          loginCallBack: () => {
            AppStorageV2.connect(Sample, 'isLogin', () => new Sample(true))
            emitter.emit('loginUpdate')
            this.pathStack.pop();
          }
        })
      }.backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')

    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
    .onBackPressed(() => {
      this.pathStack.pop(); // 弹出路由栈栈顶元素
      return true;
    })
    .backgroundColor(Constants.NAV_DESTINATION_BACKGROUND_COLOR);
  }
}