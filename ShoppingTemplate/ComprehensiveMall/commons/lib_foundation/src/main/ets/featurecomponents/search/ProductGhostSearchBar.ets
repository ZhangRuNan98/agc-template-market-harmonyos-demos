import { Style } from '../../constants/Style';

@ComponentV2
struct ProductGhostSearchBar {
  @Param
  public content: string = '';
  @Param
  public showSearchIcon: boolean = true;
  @Event
  public onSearch: () => void = () => {
  };

  build() {
    Row() {
      if (this.showSearchIcon) {
        Image($r('app.media.ic_search'))
          .width(18)
          .height(18)
          .margin({ left: 8 })
          .fillColor($r('sys.color.mask_secondary'))
          .draggable(false)
          .objectFit(ImageFit.Cover);
      }
      Text(this.content)
        .lineHeight(Style.MENU_BAR_HEIGHT)
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize(12)
        .fontColor($r('sys.color.mask_secondary'))
        .halfLeading(true)
        .margin({ left: this.showSearchIcon ? 4 : 16 });
    }
    .width('100%')
    .height(Style.MENU_BAR_HEIGHT)
    .borderWidth(Style.MENU_BAR_BORDER_WIDTH)
    .borderRadius(Style.MENU_BAR_BORDER_RADIUS)
    .backgroundColor('#0D000000')
    .borderColor(Color.Transparent)
    .clip(true)
    .onClick(() => this.onSearch());
  }
}

@Builder
export function buildProductGhostSearchBar(content: string, onSearch: () => void, showSearchIcon: boolean = true) {
  ProductGhostSearchBar({ content: content, onSearch: onSearch, showSearchIcon: showSearchIcon });
}
