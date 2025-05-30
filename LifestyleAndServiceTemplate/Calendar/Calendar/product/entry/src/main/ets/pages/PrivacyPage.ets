import { NavigationTitle, WebView } from 'common';
import { webview } from '@kit.ArkWeb';


@Entry
@ComponentV2
struct PrivacyPage {
  @Local webViewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      NavigationTitle({
        title:$r('app.string.privacy_statement')
      })
      WebView({
        url: $rawfile('privacy-statement-zh-cn.htm'),
        webViewController: this.webViewController,
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .padding({ top: AppStorage.get<number>('statusBarHeight'), bottom: 24 })
  }
}