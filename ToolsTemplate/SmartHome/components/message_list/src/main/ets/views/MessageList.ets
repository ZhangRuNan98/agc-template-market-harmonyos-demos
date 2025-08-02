import { MessageRecordViewModel } from '../../../../Index'

@ComponentV2
export struct MessageList {
  @Require @Param messageList:MessageRecordViewModel[]
  private listScroller: Scroller = new Scroller();

  build() {
    List({ space: 20, scroller: this.listScroller }) {
      ForEach(this.messageList, (item: MessageRecordViewModel) => {
          ListItem() {
            ListItemView({ item: item });
          };
        }, (item: Object, index: number) => index + '__' + JSON.stringify(item));
    }
    .scrollBar(BarState.Off);
  }
}

@ComponentV2
export struct ListItemView {
  @Require @Param item: MessageRecordViewModel;
  diameter = 10;
  radius = this.diameter / 2;
  @Local textHeight: number = 0

  @Builder
  BuildTime() {
    Row() {
      Circle()
        .width(this.diameter)
        .height(this.diameter)
        .fill('#999999')
        .opacity(0.5);
      Text(this.item.day)
        .fontColor('#999999')
        .fontSize(16)
        .margin({ left: 15 });
      Text(this.item.hourMinute)
        .fontColor('#999999')
        .fontSize(16)
        .margin({ left: 10 });
      Blank();
      Text(this.item.week)
        .fontColor('#999999')
        .fontSize(16);
    }
    .width('100%');
  }

  @Builder
  BuildEvent() {
    Row() {
      Divider()
        .vertical(true)
        .height(this.textHeight + 10)
        .strokeWidth(1)
        .margin({ left: this.radius })
        .color('#999999')
        .opacity(0.2);
      Column() {
        Text(this.item.message)
          .fontColor('#333333')
          .fontSize(18)
          .margin({ top: 16, bottom: 16 })
          .onAreaChange((_oldValue: Area, newValue: Area) => {
            this.textHeight = Number(newValue.height);
          });
        Divider()
          .width('100%')
          .strokeWidth(1)
          .color('#999999')
          .opacity(0.2)
      }
      .margin({ left: 15 + this.radius })
      .alignItems(HorizontalAlign.Start)
      .width('90%');
    }
    .width('100%');
  }

  build() {
    Column() {
      this.BuildTime();
      this.BuildEvent();
    }
  }
}