import { Constants } from '../commons/Constants';

@ComponentV2
export struct ProductSwiper {
  @Param
  imgList: ResourceStr[] = [];
  @Local
  curIndex: number = 0;

  build() {
    Swiper() {
      ForEach(this.imgList, (item: ResourceStr) => {
        Image(item)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .draggable(false);
      }, (item: ResourceStr) => JSON.stringify(item));
    }
    .index(this.curIndex)
    .width('100%')
    .aspectRatio(1.0)
    .indicatorInteractive(true)
    .indicator(
      new DotIndicator()
        .selectedItemWidth(12)
        .selectedItemHeight(6)
        .selectedColor(Constants.THEME_COLOR)
        .itemWidth(6)
        .itemHeight(6)
        .color('#80ffffff'),
    );
  }
}