import { PrivacyCard } from '../components/PrivacyCard';

@ComponentV2
export struct PrivacyPolicyPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Scroll() {
        PrivacyCard({title:'隐私政策',displayDate:true, ifPrivacyPolicy: true})
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