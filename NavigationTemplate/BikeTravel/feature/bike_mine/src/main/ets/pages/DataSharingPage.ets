import { PrivacyCard } from '../components/PrivacyCard';

@ComponentV2
export struct DataSharingPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Scroll() {
        PrivacyCard({title:'第三方信息共享清单',displayDate:false, ifPrivacyPolicy: false})
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