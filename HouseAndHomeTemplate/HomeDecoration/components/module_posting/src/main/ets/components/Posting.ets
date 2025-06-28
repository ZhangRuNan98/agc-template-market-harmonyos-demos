import { promptAction, KeyboardAvoidMode } from '@kit.ArkUI';
import { WantData, PostType } from '../http/Types';


@ComponentV2
export struct Posting {
  @BuilderParam topBuilderParam: () => void = this.topBuilder;
  @Local wantData: WantData = new WantData();
  @Local suggestion: string = '';
  @Local isWant: boolean = false;

  @Event onWantSubmit: (wantData: WantData) => void = () => {

  };

  @Event onSuggestionSubmit: (text: string) => void = () => {

  };

  @Event onCancel: (status: PostType) => void = () => {

  };

  @Builder
  topBuilder() {

  }

  isWantDataValidate(): boolean {
    if (!this.wantData.title) {
      promptAction.showToast({ message: '请填写标题！' });
      return false;
    }
    if (!this.wantData.painPoint) {
      promptAction.showToast({ message: '请填写目前的痛点！' });
      return false;
    }
    if (!this.wantData.idea) {
      promptAction.showToast({ message: '请填写你的想法！' });
      return false;
    }
    return true;
  }

  @Builder
  wantBuilder() {
    Column({ space: 12 }) {
      Row() {
        Text('如果你是设计师，你有何好主意呢？')
          .fontColor($r('sys.color.font_secondary'))
          .fontSize($r('sys.float.Body_S'))
          .fontWeight(FontWeight.Regular);
      }
      .backgroundColor('rgba(237, 111, 33, 0.18)')
      .width('100%')
      .borderRadius(16)
      .padding({
        left: 12,
        right: 12,
        top: 8,
        bottom: 8,
      });

      TextInput({ placeholder: '此处添加简短标题', text: this.wantData.title })
        .maxLength(50)
        .placeholderFont({
          size: $r('sys.float.Body_M'),
          weight: FontWeight.Regular,
        })
        .placeholderColor($r('sys.color.font_tertiary'))
        .padding({ left: 12, right: 12 })
        .height(40)
        .backgroundColor($r('sys.color.background_primary'))
        .borderRadius(16)
        .onChange((res) => {
          this.wantData.title = res;
        });


      TextArea({ placeholder: '详细说说你遇到的装修难题和具体场景', text: this.wantData.painPoint })
        .textAreaBaseExtend()
        .height(170)
        .maxLength(300)
        .onChange((res) => {
          this.wantData.painPoint = res;
        });


      TextArea({ placeholder: '详细说说你的想法', text: this.wantData.idea })
        .textAreaBaseExtend()
        .height(170)
        .maxLength(300)
        .margin({ bottom: 109 })
        .onChange((res) => {
          this.wantData.idea = res;
        });


    };

  }

  @Builder
  suggestionBuilder() {
    Column() {
      TextArea({ placeholder: '请在此提出您的宝贵建议', text: this.suggestion })
        .textAreaBaseExtend()
        .maxLength(500)
        .height(242)
        .margin({ bottom: 109 })
        .onChange((res) => {
          this.suggestion = res;
        });
    };
  }

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }

  aboutToDisappear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Column() {
          this.topBuilderParam();
        }.width('100%').margin({ bottom: 22 });

        Row({ space: 12 }) {
          Button('我建议')
            .selectBarExtend()
            .backgroundColor(!this.isWant ? $r('sys.color.alert') : $r('sys.color.comp_background_tertiary'))
            .fontColor(!this.isWant ? $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
            .onClick(() => {
              this.isWant = false;
            });
          Button('我想要')
            .selectBarExtend()
            .backgroundColor(this.isWant ? $r('sys.color.alert') : $r('sys.color.comp_background_tertiary'))
            .fontColor(this.isWant ? $r('sys.color.font_on_primary') : $r('sys.color.font_primary'))
            .onClick(() => {
              this.isWant = true;
            });

        }.width('100%').margin({ bottom: 12 });

        if (this.isWant) {
          this.wantBuilder();
        } else {
          this.suggestionBuilder();
        }
      }.width('100%').constraintSize({ minHeight: '100%' });

      Row({ space: 12 }) {
        Button('取消')
          .height(40)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .onClick(() => {
            if (this.isWant) {
              this.wantData = new WantData();
              this.onCancel(PostType.want);
            } else {
              this.suggestion = '';
              this.onCancel(PostType.suggestion);
            }
          });
        Button('发布')
          .height(40)
          .layoutWeight(1)
          .backgroundColor($r('sys.color.alert'))
          .fontColor($r('sys.color.font_on_primary'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            if (this.isWant) {
              if (this.isWantDataValidate()) {
                this.onWantSubmit(this.wantData);
                this.wantData = new WantData();
              }
            } else {
              if (this.suggestion) {
                this.onSuggestionSubmit(this.suggestion);
                this.suggestion = '';
              } else {
                promptAction.showToast({ message: '请填写您的建议！' });
              }
            }
          });
      }.width('100%').margin({ bottom: 53 });
    };
  }
}

@Extend(TextArea)
function textAreaBaseExtend() {
  .placeholderFont({
    size: $r('sys.float.Body_M'),
    weight: FontWeight.Regular,
  })
  .placeholderColor($r('sys.color.font_tertiary'))
  .padding(12)
  .backgroundColor($r('sys.color.background_primary'))
  .borderRadius(16)
  .showCounter(true)
  .minFontSize($r('sys.float.Body_M'));
}

@Extend(Button)
function selectBarExtend() {
  .width(68)
  .height(36)
  .fontSize($r('sys.float.Body_L'))
  .fontWeight(FontWeight.Medium)
  .padding(0);
}

@Extend(Column)
function itemBaseStyle() {
  .backgroundColor('#FFFFFF').borderRadius(8);
}


