import { CommonHeader } from 'componentlib';
import { AtomicServiceWeb, AtomicServiceWebController } from '@kit.ArkUI';

@Builder
export function privacyPolicyPageBuilder() {
  PrivacyPolicyPage()
}

@Component
export struct PrivacyPolicyPage {
  @State controller: AtomicServiceWebController = new AtomicServiceWebController();

  build() {
    NavDestination() {
      CommonHeader({ title: '隐私政策' });
      Column() {
        AtomicServiceWeb({ src: $rawfile('privacy_policy.html'), controller: this.controller });
      }
      .padding($r('app.string.padding_s'))
      .layoutWeight(1)
    }
    .height($r('app.string.height_percent_full'))
    .hideTitleBar(true)
  }
}