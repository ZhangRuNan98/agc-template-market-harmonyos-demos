import { PrivacyCard } from '../components/PrivacyCard';

@ComponentV2
export struct UserAgreementPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Scroll() {
        PrivacyCard({title:'用户协议',displayDate:true, ifPrivacyPolicy: false})
      }
      .align(Alignment.TopStart)
      .edgeEffect(EdgeEffect.Spring)

    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor($r('app.color.common_background'))
    .height('100%')
    .width('100%')
  }
}