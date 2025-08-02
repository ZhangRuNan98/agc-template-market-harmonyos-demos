import { LengthMetrics, PromptAction } from '@kit.ArkUI';

@ObservedV2
class FeedbackType {
  text: string;
  @Trace selected: boolean;

  constructor(text: string) {
    this.text = text;
    this.selected = false;
  }
}


@ComponentV2
export struct FeedbackPage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Local message: string = 'Hello World';
  @Local feedbackTypeList: FeedbackType[] = [new FeedbackType('APP界面改进'),
    new FeedbackType('还车点太少'),
    new FeedbackType('扣款描述不清'),
    new FeedbackType('客服电话失效'),
    new FeedbackType('车辆太少'),
    new FeedbackType('其他'),]
  @Local suggestions: string = ''
  controller: TextAreaController = new TextAreaController()
  private suggestionsMax: number = 100
  // 至少输入的问题字数
  private suggestionsMin = 4

  build() {
    NavDestination() {
      Column({ space: 14 }) {
        Text('请选择反馈的类型')
          .fontColor($r('app.color.tab_font_color'))
          .fontSize(12)

        Flex({ wrap: FlexWrap.Wrap, space: { main: new LengthMetrics(14), cross: new LengthMetrics(12) } }) {
          ForEach(this.feedbackTypeList, (item: FeedbackType, index: number) => {
            ListItem() {
              Row() {
                Text(item.text)
                  .fontSize(12)
                  .fontWeight('medium')
                  .fontColor(item.selected ? $r('app.color.pure_white') : $r('app.color.contentColor'))
                  .textAlign(TextAlign.Center)
              }
              .onClick(() => {
                item.selected = !item.selected
              })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .padding({ top: 6, bottom: 6 })
              .width('30%')
              .borderRadius(14)
              .backgroundColor(item.selected ? $r('app.color.orange') : $r('app.color.item_gray'))
            }
          })
        }

        Text('请输入您的意见或建议')
          .fontColor($r('app.color.tab_font_color'))
          .fontSize(12)

        TextArea({
          text: this.suggestions,
          placeholder: `请输入您的意见或建议，最少${this.suggestionsMin}个字，最多${this.suggestionsMax}字`,
          controller: this.controller
        })
          .fontSize(14)
          .placeholderColor($r('app.color.tab_font_color'))
          .height(100)
          .borderRadius(16)
          .textAlign(TextAlign.Start)
          .onChange((value: string) => {
            this.suggestions = value
          })
          .showCounter(true, { thresholdPercentage: 1, highlightBorder: true })
          .maxLength(this.suggestionsMax)
          .backgroundColor($r('app.color.pure_white'))


        Button('提交')
          .onClick(() => {
            this.suggestionsReporting()
          })
          .backgroundColor($r('app.color.orange'))
          .fontColor($r('app.color.pure_white'))
          .fontSize(16)
          .fontWeight('medium')
          .position({ bottom: 0, left: 0 })
          .width('100%')
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 16, right: 16 })
    }
    .title('意见反馈')
    .backgroundColor($r('app.color.common_background'))
    .height('100%')
  }

  suggestionsReporting() {
    if (this.suggestions.length < this.suggestionsMin) {
      this.showDialog()
      return
    }
    let feedbacks = this.feedbackTypeList.filter((item) => item.selected);
    console.log('majiajia 建议类型：' + JSON.stringify(feedbacks))
    console.log('majiajia 意见建议：' + this.suggestions)

    this.thankForReport()
  }

  showDialog() {
    let uiContext = this.getUIContext();
    let promptAction: PromptAction = uiContext.getPromptAction();
    try {
      promptAction.showDialog({
        message: `至少输入${this.suggestionsMin}个字`,
      }, (err, data) => {
        if (err) {
          console.error('showDialog err: ' + err);
          return;
        }
        console.info('showDialog success callback, click button: ' + data.index);
      });
    } catch (error) {
      console.info('showDialog exception:' + JSON.stringify(error))
    }
  }

  thankForReport() {
    let uiContext = this.getUIContext();
    let promptAction: PromptAction = uiContext.getPromptAction();
    try {
      promptAction.showDialog({
        title: '非常感谢您的反馈',
        message: '单车出行有您更优秀，研发团队正在拼命优化中',
        buttons: [
          {
            text: '确定',
            color: Color.Blue.toString()
          }
        ]
      }, (err, data) => {
        if (err) {
          console.error('showDialog err: ' + err);
        } else {
          console.info('showDialog success callback, click button: ' + data.index);
        }
        // 返回到上一层
        this.pageInfos.pop()
      });
    } catch (error) {
      console.info('showDialog exception:' + JSON.stringify(error))
    }
  }
}