import { AccountUtil } from 'commonlib';
import { router, promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct EmptyPage {
  aboutToAppear(): void {
    AccountUtil.authSignIn()
      .catch(() => {
        promptAction.showToast({ message: '华为账号登录失败，请检查工程签名配置~' });
      })
      .finally(() => {
        router.replaceUrl({
          url: 'pages/MainEntry',
        });
      });
  }

  build() {
    RelativeContainer() {

    }
    .height('100%')
    .width('100%');
  }
}