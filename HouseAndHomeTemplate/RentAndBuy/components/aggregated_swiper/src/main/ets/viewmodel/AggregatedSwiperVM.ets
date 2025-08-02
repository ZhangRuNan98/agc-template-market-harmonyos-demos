import { SwiperContent, SwiperOption, SwiperType } from '../model/Index';

@ObservedV2
export class AggregatedSwiperVM {
  @Trace swiperTypes: SwiperType[] = [];
  @Trace contents: SwiperContent[] = [];
  @Trace swiperTypeIndex: number = 0;
  private static _instance: AggregatedSwiperVM;
  swiperController: SwiperController = new SwiperController();
  swiperAnimateIndex: number = 0;

  public static get instance() {
    if (!AggregatedSwiperVM._instance) {
      AggregatedSwiperVM._instance = new AggregatedSwiperVM();
    }
    return AggregatedSwiperVM._instance;
  }

  initOptions(options: SwiperOption[]) {
    this.contents = options[this.swiperTypeIndex]?.contents ?? [];
    this.swiperTypes = options.filter((item: SwiperOption) => item.contents.length).map((item: SwiperOption) => {
      return item.swiperType;
    });
  }

  handleSwiperEvent(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) {
    // 左滑且当前元素索引为0且不为最左tab
    if (extraInfo.currentOffset > 0 && this.swiperTypeIndex > 0 && index === 0) {
      this.swiperAnimateIndex = targetIndex;
      this.swiperTypeIndex -= 1;
      this.swiperController.changeIndex(0, SwiperAnimationMode.NO_ANIMATION);
      // 右滑且当前元素索引为最大长度-1且不为最右tab
    } else if (extraInfo.currentOffset < 0 && this.swiperTypeIndex < this.swiperTypes.length - 1 &&
      index === this.contents.length - 1) {
      this.swiperAnimateIndex = targetIndex;
      this.swiperTypeIndex += 1;
      this.swiperController.changeIndex(0, SwiperAnimationMode.NO_ANIMATION);
    } else {
      this.swiperAnimateIndex = targetIndex;
    }
  }
}