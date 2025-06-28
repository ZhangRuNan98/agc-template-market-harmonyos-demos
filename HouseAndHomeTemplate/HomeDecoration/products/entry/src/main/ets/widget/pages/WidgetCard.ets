@Entry
@Component
struct WidgetCard {
  /*
   * The action type.
   */
  readonly actionType: string = 'router';
  /*
   * The ability name.
   */
  readonly abilityName: string = 'EntryAbility';
  /*
   * The width percentage setting.
   */
  readonly fullWidthPercent: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent: string = '100%';

  build() {
    Stack() {
      Column() {
        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_widget_app')).width(20).height(20).borderRadius(4)
              Text('装修模板')
                .fontSize(14)
                .fontColor($r('sys.color.font_primary'))
                .margin({ left: 6 })
            }

            Image($r('app.media.ic_widget_home')).width(20).height(20).borderRadius(10).onClick(() => {
              postCardAction(this, {
                action: this.actionType,
                abilityName: this.abilityName,
                params: {
                  url: 'HomePage',
                },
              })
            })
          }.width(this.fullWidthPercent).justifyContent(FlexAlign.SpaceBetween)

          Text('定制专属设计').fontSize(10).fontColor($r('sys.color.font_primary')).margin({ top: 9 })
        }.alignItems(HorizontalAlign.Start)

        Row({ space: 22 }) {
          Column() {
            Image($r('app.media.ic_widget_designer')).width(32).height(32)
            Text('找设计师')
              .fontSize(12)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .margin({ top: 4 })
          }.onClick(() => {
            postCardAction(this, {
              action: this.actionType,
              abilityName: this.abilityName,
              params: {
                url: 'FindPage',
              },
            })
          })

          Column() {
            Image($r('app.media.ic_widget_custom')).width(32).height(32)
            Text('定制设计')
              .fontSize(12)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .margin({ top: 4 })
          }.onClick(() => {
            postCardAction(this, {
              action: this.actionType,
              abilityName: this.abilityName,
              params: {
                url: 'CustomPage',
              },
            })
          })
        }
      }.width(this.fullWidthPercent)
      .height(this.fullHeightPercent)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(12)

    }
    .alignContent(Alignment.BottomEnd)
    .linearGradient({
      angle:153.43,
      repeating: false, // 渐变颜色是否重复
      colors: [['#FFFAFA', 0], ['#ED6F21', 1]], // 数组末尾元素占比小于1时满足重复着色效果
    })
    .onClick(() => {
      postCardAction(this, {
        action: this.actionType,
        abilityName: this.abilityName,
      });
    })
  }
}