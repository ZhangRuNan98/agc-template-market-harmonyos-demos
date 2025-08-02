import { PickerPreviewItem, PickerResourceType } from '../utils/PickerUtil';

@ComponentV2
export struct MediaPreviewSheet {
  @Param
  previewItem: PickerPreviewItem | undefined = undefined;
  @Event
  clickBackButton: () => void;
  @Local
  avoidHeight: number = 32;

  @Computed
  get title() {
    if (!this.previewItem) {
      return '';
    }
    const titleMap: Map<number, string> = new Map([
      [PickerResourceType.IMAGE, '图片预览'],
      [PickerResourceType.VIDEO, '视频预览'],
      [PickerResourceType.AUDIO, '音频播放'],
    ]);
    return titleMap.get(this.previewItem.type) ?? '';
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_arrow_left'))
          .fillColor($r('app.color.font_color_level1'))
          .height(24)
          .margin({ right: $r('app.string.space_m') })
          .onClick(() => {
            this.clickBackButton?.();
          });
        Text(this.title)
          .fontSize($r('app.string.font_size_20'))
          .fontColor($r('app.color.font_color_level1'))
          .fontWeight(FontWeight.Medium);
      }
      .width($r('app.string.size_percent_full'))
      .margin({ top: $r('app.string.space_xl'), bottom: $r('app.string.space_l') })
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .backgroundColor($r('app.color.system_color_background_white'))
      .padding({ left: $r('app.string.space_l') });

      Column() {
        if (this.previewItem?.uri) {
          if (this.previewItem.type === PickerResourceType.IMAGE) {
            Scroll() {
              Image(this.previewItem.uri)
                .width($r('app.string.size_percent_full'))
                .height($r('app.string.size_percent_full'))
                .objectFit(ImageFit.Contain)
            }
            .padding($r('app.string.space_l'))
            .layoutWeight(1);
          } else if (this.previewItem.type === PickerResourceType.VIDEO) {
            Row(){
              Video({
                src: this.previewItem.uri,
              })
                .width($r('app.string.size_percent_full'));
            }
            .padding($r('app.string.space_l'))
          }
        }
      }
      .layoutWeight(1)
    }
    .width($r('app.string.size_percent_full'))
    .height($r('app.string.size_percent_full'))
    .backgroundColor($r('app.color.system_color_background_white'));
  }
}