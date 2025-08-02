@ComponentV2
export struct LeftReturnComponent {
  build() {
    Row(){
      SymbolGlyph($r('sys.symbol.chevron_left'))
        .fontSize(30)
    }
    .padding({left: 12})
    .width(40)
    .height(40)
    .borderRadius(100)
    .backgroundColor('#E6E8E9')
    .margin({ right: 10 })
  }
}