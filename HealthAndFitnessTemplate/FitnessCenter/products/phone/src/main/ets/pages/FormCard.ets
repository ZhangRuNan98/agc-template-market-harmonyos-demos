@Entry
@Component
struct OrderingCard {
  build() {
    FormLink({
      action: 'router',
      abilityName: 'EntryAbility',
      params: {
        jumpBooking:true
      }
    }) {
      Column() {
        Row() {
          Image($r('app.media.app_icon'))
            .width(24)
            .height(24)
          Text('预约办卡')
            .fontSize(18)
            .fontColor('#FF9019')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .padding(16)
      .height('100%')
    }
    .height('100%')
  }
}