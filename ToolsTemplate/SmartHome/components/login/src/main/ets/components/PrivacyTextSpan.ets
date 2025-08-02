import { loginComponentManager } from '@kit.AccountKit';

@ComponentV2
export struct PrivacyTextSpan {
  @Param privacyTexts: loginComponentManager.PrivacyText[] = []
  @Param clickPrivacyCallBack: (text: ResourceStr) => void = () => {}

  build() {
    Text() {
      ForEach(this.privacyTexts, (item: loginComponentManager.PrivacyText) => {
        Span(item.text)
          .fontSize($r('sys.float.ohos_id_text_size_body3'))
          .fontColor(item.type === loginComponentManager.TextType.PLAIN_TEXT ?
          $r('sys.color.ohos_id_color_text_secondary') : $r('sys.color.ohos_id_color_text_primary'))
          .fontFamily(item.type === loginComponentManager.TextType.PLAIN_TEXT ?
          $r('sys.string.ohos_id_text_font_family_regular') : $r('sys.string.ohos_id_text_font_family_medium'))
          .fontWeight(item.type === loginComponentManager.TextType.PLAIN_TEXT ? FontWeight.Regular :
          FontWeight.Medium)
          .onClick(() => {
            if (this.clickPrivacyCallBack && item.type === loginComponentManager.TextType.RICH_TEXT) {
              this.clickPrivacyCallBack(item.text)
            }
          })
      })
    }
    .layoutWeight(1)
    .maxLines(2)
  }
}