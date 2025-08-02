import { getColor, getMedia, getString } from '@agctemplate/resources'
import { RouterMap, RouterModule } from '@agctemplate/router_module'
import { AppStorageV2 } from '@kit.ArkUI'
import { LiveCardModel } from '../models/LiveModel'
import { SearchRecords } from '../viewmodels/SearchRecordsVM'

@ComponentV2
export struct SearchPanel {
  @Param @Require textController: TextInputController | undefined
  @Param @Require searchText: string
  @Param @Require isEdit: boolean
  @Param @Require searchResult: Array<LiveCardModel> | undefined
  @Param @Require isInput: boolean
  @Param @Require backToSearch: boolean
  @Event inputFocusEvent: Function | undefined
  @Event inputValueChangedEvent: Function | undefined
  @Event searchEvent: Function | undefined
  @Event clearText: Function
  @Event backSearch: Function
  @Local searchRecords: SearchRecords = AppStorageV2.connect(SearchRecords, () => new SearchRecords())!

  build() {
    Row() {
      Image(getMedia('app.media.arrow_back'))
        .width(40)
        .margin({ right: 8 })
        .onClick(() => {
          if (this.backToSearch) {
            this.backSearch()
          } else {
            RouterModule.pop()
          }
        })

      Column() {
        Row() {
          Column() {
            SymbolGlyph($r('sys.symbol.magnifyingglass'))
              .fontSize(16)
              .fontColor([getColor('app.color.normal_font_color')])
              .margin({
                left: 12, right: this.isInput ? 0 : 8
              })
          }
          .zIndex(this.isInput ? 10000 : 0)

          if (!this.isInput) {
            Column() {
              Text(getString('app.string.search_placeholder'))
                .height(40)
                .fontSize(16)
                .fontColor(getColor('app.color.normal_font_color'))
            }
          } else {
            Column() {
              TextInput({
                controller: this.textController,
                placeholder: getString('app.string.search_placeholder'),
                text: this.searchText
              })
                .height(40)
                .maxLines(1)
                .maxLength(13)
                .placeholderColor(getString('app.color.normal_font_color'))
                .backgroundColor(getColor('app.color.transparent_background_color'))
                .defaultFocus(true)
                .onChange((value: string) => {
                  this.inputValueChangedEvent?.(value)
                })
                .onFocus(() => {
                  this.inputFocusEvent?.()
                })
                .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
                  if (event.text.trim() !== '') {
                    this.searchRecords.records.unshift(event.text.trim())
                  }
                  this.searchEvent?.(event.text)
                })
            }
          }
          if (this.searchText) {
            Text('×')
              .textAlign(TextAlign.Center)
              .fontColor('#fff')
              .width(20)
              .height(20)
              .borderRadius(10)
              .backgroundColor('#ff888888')
              .offset({ x: -60 })
              .onClick(() => {
                this.clearText()
              })
          }
        }
        .width('100%')
        .borderRadius(24)
        .backgroundColor(getColor('app.color.component_background_color'))
        .onClick(() => {
          if (!this.isInput) {
            RouterModule.push({ url: RouterMap.SEARCH_PAGE })
          }
        })
      }
      .width(296)
      .height(37)
    }
    .width(360)
    .height(56)
    .padding({ top: 8, bottom: 8 })
  }
}