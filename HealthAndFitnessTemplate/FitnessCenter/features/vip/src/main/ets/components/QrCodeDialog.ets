@Component
@Preview
@CustomDialog
export struct qrCodeDialog {
  controller?: CustomDialogController;
  cancel: Function = () => {
  };
  confirm: Function = () => {
  };

  build() {
    Column() {
      Row() {
        Text('会员码')
          .fontSize(18)
          .margin({ top: 26 })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Row() {
        Image($r('app.media.qrCode'))
          .width(200)
          .margin({ top: 38 })
          .backgroundColor(Color.Black)
          .height(200)
      }
    }.width(328)
    .height(328)
    .border({ radius: 5 })
  }
}