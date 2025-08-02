import { AppStorageMap, CommonHeader, RouterMap, RouterModule } from 'common';

@Component
export struct TopPart {
  @StorageLink(AppStorageMap.SELECTED_ADDRESS) query: string = '';

  build() {
    Column() {
      CommonHeader({ title: '找车位', showBackButton: false })

      Stack({ alignContent: Alignment.End }) {
        Search({ value: $$this.query, placeholder: '输入地址' })
          .backgroundColor($r('sys.color.white'))
          .shadow({
            radius: 4,
            offsetY: 4,
            offsetX: 0,
            color: 'rgba(0,0,0,0.25)',
          })
          .searchButton('搜索')
          .focusable(false)
          .onClick(() => {
            RouterModule.push({ url: RouterMap.SEARCH_LIST, param: this.query });
          })

        if (this.query) {
          Row()
            .width(24)
            .height(24)
            .margin({ right: 72 })
            .onClick(() => {
              this.query = '';
            })
        }
      }
      .padding({ left: $r('app.string.padding_16'), right: $r('app.string.padding_16') })
    }
  }
}