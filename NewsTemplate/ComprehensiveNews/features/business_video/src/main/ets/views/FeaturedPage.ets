import { VideoSwiperPage } from './VideoSwiperPage';

@ComponentV2
export struct FeaturedPage {
  // tab页面的index
  @Param index: number = 1
  // 视频页里面的头部tabIndex
  @Param currentTabIndex: number = 1;

  build() {
    Column() {
      VideoSwiperPage({
        index: this.index,
        currentTabIndex: this.currentTabIndex,
      })
    }
    .width('100%')
    .layoutWeight(1)
  }
}