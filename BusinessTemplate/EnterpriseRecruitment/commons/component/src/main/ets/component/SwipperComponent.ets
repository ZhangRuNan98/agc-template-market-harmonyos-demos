@ComponentV2
export struct SwiperComponent {
  private swiperController: SwiperController = new SwiperController()

  build() {
    Swiper(this.swiperController) {
      Image($r('app.media.swiperImage'))
        .width('100%')
      Image($r('app.media.swiperImage'))
        .width('100%')
      Image($r('app.media.swiperImage'))
        .width('100%')
    }
    .borderRadius(16)
    .autoPlay(true)
    .width('100%')
  }
}