import { LayoutParams } from 'lib_news_api'
import { AdvertisementComponent } from 'module_advertisement'

@Builder
export function AdvertisementCard(cardData: LayoutParams) {
  NativeComponent({
    cardData: cardData,
  })
}

@ComponentV2
export struct NativeComponent {
  @Param @Require cardData: LayoutParams
  build() {
    AdvertisementComponent({
      testAd: 'testw6vs28auh3',
      adType: 8,
    })
  }
}