interface ImageSize {
  width: number;
  height: number;
}

@ObservedV2
class ImageInfo {
  @Trace width: number = 0;
  @Trace height: number = 0;
  @Trace scale: number = 1;
  @Trace offsetX: number = 0;
  @Trace offsetY: number = 0;
  @Trace offsetStartX: number = 0;
  @Trace offsetStartY: number = 0;
  @Trace dragOffsetX: number = 0;
  @Trace dragOffsetY: number = 0;
}

@ComponentV2
export struct SwiperPicsPreview {
  // 轮播图片数组
  @Require @Param pics: ResourceStr[] = [];
  // 初始图片索引
  @Once @Param index: number = 0;
  // 轮播高度
  @Param iHeight: number = 120;
  // 轮播图片圆角
  @Param radius: Length = 16;
  // 轮播图片间隙
  @Param space: string | number = 12;
  // 露出前后项宽度
  @Param out: Length = 50;
  // undefined时轮播居中,设置时代表首尾项的边距
  @Param pad: number | undefined = undefined;
  controller: SwiperController = new SwiperController();
  imageListSize: ImageSize[] = [];
  defaultScale: number = 1;
  @Local show: boolean = false;
  @Local containerHeight: number = 0;
  @Local containerWidth: number = 0;
  @Local disabledSwipe: boolean = false;
  @Local activeImage: ImageInfo = new ImageInfo();

  getMargin(index: number): Margin | undefined {
    if (this.pad === undefined) {
      return undefined;
    }
    if (index === 0) {
      return { left: this.pad };
    } else if (index + 1 === this.pics.length) {
      return { right: this.pad };
    }
    return undefined;
  }

  build() {
    Swiper(this.controller) {
      ForEach(this.pics, (item: ResourceStr, index: number) => {
        Image(item)
          .width('100%')
          .margin(this.getMargin(index))
          .onClick(() => {
            if (this.index !== index) {
              this.controller.changeIndex(index, true);
            } else {
              this.activeImage = new ImageInfo();
              this.disabledSwipe = false;
              this.show = true;
            }
          })
          .borderRadius(this.radius)
      }, (item: ResourceStr, index) => JSON.stringify(item) + '_' + index)
    }
    .width('100%')
    .height(this.iHeight)
    .index($$this.index)
    .autoPlay(false)
    .indicator(false)
    .loop(false)
    .nextMargin(this.out, this.pad !== undefined)
    .prevMargin(this.out, this.pad !== undefined)
    .itemSpace(this.space)
    .bindContentCover(
      $$this.show,
      this.contentCoverBuilder,
      { transition: TransitionEffect.OPACITY.animation({ duration: 0 }) },
    )
  }

  @Builder
  contentCoverBuilder() {
    Column() {
      Swiper() {
        ForEach(this.pics, (item: ResourceStr, i: number) => {
          Image(item)
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .scale(this.index === i ? { x: this.activeImage.scale, y: this.activeImage.scale } : null)
            .offset(this.index === i ? { x: this.activeImage.offsetX, y: this.activeImage.offsetY } : null)
            .onComplete(event => {
              if (event?.loadingStatus) {
                this.imageListSize[i] = {
                  width: px2vp(Number(event.contentWidth)),
                  height: px2vp(Number(event.contentHeight)),
                };
                if (this.index === i) {
                  this.activeImage.width = this.imageListSize[i].width;
                  this.activeImage.height = this.imageListSize[i].height;
                }
              }
            })
        }, (item: ResourceStr, index) => JSON.stringify(item) + '_' + index)
      }
      .width('100%')
      .height('100%')
      .disableSwipe(this.disabledSwipe)
      .index(this.index)
      .indicator(false)
      .parallelGesture(
        GestureGroup(GestureMode.Exclusive,
          // 捏合手势
          PinchGesture({ fingers: 2 })
            .onActionStart(() => {
              this.defaultScale = this.activeImage.scale;
            })
            .onActionUpdate((event) => {
              let scale = event.scale * this.defaultScale;
              if (scale <= 4 && scale >= 1) {
                this.activeImage.offsetX = this.activeImage.offsetX / (this.activeImage.scale - 1) * (scale - 1) || 0;
                this.activeImage.offsetY = this.activeImage.offsetY / (this.activeImage.scale - 1) * (scale - 1) || 0;
                this.activeImage.scale = scale;
              }
              this.disabledSwipe = this.activeImage.scale > 1;
            })
            .onActionEnd(() => {
              this.disabledSwipe = this.activeImage.scale > 1;
            })
            .onActionCancel(() => {
              this.disabledSwipe = this.activeImage.scale > 1;
            }),
          // 滑动手势
          PanGesture()
            .onActionStart(event => {
              if (!event.fingerList?.[0]) {
                return;
              }
              this.activeImage.dragOffsetX = event.fingerList[0].globalX;
              this.activeImage.dragOffsetY = event.fingerList[0].globalY;
            })
            .onActionUpdate((event) => {
              if (this.activeImage.scale === 1 || !event.fingerList?.[0]) {
                return;
              }
              let offsetX = event.fingerList[0].globalX - this.activeImage.dragOffsetX +
              this.activeImage.offsetStartX;

              let offsetY = event.fingerList[0].globalY - this.activeImage.dragOffsetY +
              this.activeImage.offsetStartY;

              if (this.activeImage.width * this.activeImage.scale > this.containerWidth &&
                (this.activeImage.width * this.activeImage.scale - this.containerWidth) / 2 >=
                Math.abs(offsetX)) {
                this.activeImage.offsetX = offsetX;
              }
              if (this.activeImage.height * this.activeImage.scale >
              this.containerHeight &&
                (this.activeImage.height * this.activeImage.scale - this.containerHeight) / 2 >=
                Math.abs(offsetY)) {
                this.activeImage.offsetY = offsetY;
              }

              if ((this.activeImage.width * this.activeImage.scale - this.containerWidth) / 2 < Math.abs(offsetX)) {
                this.disabledSwipe = false;
              }
            })
            .onActionEnd(() => {
              this.activeImage.offsetStartX = this.activeImage.offsetX;
              this.activeImage.offsetStartY = this.activeImage.offsetY;
            })
            .onActionCancel(() => {
              this.activeImage.offsetStartX = this.activeImage.offsetX;
              this.activeImage.offsetStartY = this.activeImage.offsetY;
            }),
          // 双击手势
          TapGesture({ count: 2 })
            .onAction(() => {
              if (this.activeImage.scale > 1) {
                this.activeImage.scale = 1;
                this.activeImage.offsetX = 0;
                this.activeImage.offsetY = 0;
                this.activeImage.offsetStartX = 0;
                this.activeImage.offsetStartY = 0;
                this.disabledSwipe = false;
              } else {
                this.activeImage.scale = 2;
                this.disabledSwipe = true;
              }
            }),
          // 单击手势
          TapGesture({ count: 1 })
            .onAction(() => {
              this.show = false;
            }),
        ),
      )
      .onAnimationEnd((index) => {
        if (index !== this.index) {
          this.activeImage = new ImageInfo();
        }
        this.index = index;
        this.disabledSwipe = this.activeImage.scale > 1;
        this.activeImage.width = this.imageListSize[index].width;
        this.activeImage.height = this.imageListSize[index].height;
      })
      .itemSpace(50)
      .onSizeChange((_, n) => {
        this.containerWidth = Number(n.width);
        this.containerHeight = Number(n.height);
      })
    }
    .backgroundColor(Color.Black)
    .expandSafeArea([SafeAreaType.SYSTEM])
  }
}