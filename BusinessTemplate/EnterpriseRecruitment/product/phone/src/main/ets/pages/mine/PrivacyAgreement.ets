import { webview } from '@kit.ArkWeb';
import { CommonModel, ObjectUtil } from '@ohos_agcit/common_component';
import { router } from '@kit.ArkUI';

@Builder
export function PrivacyAgreementBuilder() {
  PrivacyAgreement();
}

@Entry
@ComponentV2
export struct PrivacyAgreement {
  topRectHeight: number = 0;
  vm: CommonModel = CommonModel.instance;
  controller: webview.WebviewController = new webview.WebviewController();
  privacyAgreementPath : string = getContext(this).resourceManager.getStringSync($r('app.string.privacyAgreementPath'));

  build() {
    NavDestination() {
      Web({ src: this.privacyAgreementPath, controller: this.controller })
        .verticalScrollBarAccess(false)
        .fileAccess(false)
        .geolocationAccess(false)
    }
    .hideTitleBar(true)
    .margin({
      top: px2vp(this.topRectHeight)
    })
    .onReady((cxt: NavDestinationContext) => {
      let param = cxt.pathInfo.param as Record<string, Object>;
      if (ObjectUtil.isNotNull(param)) {
        this.privacyAgreementPath = param.protocolUrl as string;
      }
    })
    .onBackPressed(() => {
      router.back();
      return true;
    })
  }
}