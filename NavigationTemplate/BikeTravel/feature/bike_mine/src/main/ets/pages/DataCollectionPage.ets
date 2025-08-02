import { PrivacyCard } from '../components/PrivacyCard';

@ComponentV2
export struct DataCollectionPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  build() {
    NavDestination() {
      Scroll() {
        PrivacyCard({title:'个人信息收集清单',displayDate:false, ifPrivacyPolicy: false})
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