import { UIContext, PromptAction } from '@ohos.arkui.UIContext';
import { ComponentContent } from '@kit.ArkUI';

export class SimpleDialog {

  private uiContext: UIContext;

  private promptAction: PromptAction;

  private dialogContent: DialogContentVM = new DialogContentVM();

  private node: ComponentContent<DialogContentVM> | null = null;

  private _close: () => void = () => {
    if (this.node) {
      this.promptAction.closeCustomDialog(this.node);
      this.node = null;
    }
  };

  private confirm: () => void = () => this._close();

  private cancel: () => void = () => this._close();

  private willDismiss: () => boolean = () => true;

  public setTitle(value: string): SimpleDialog {
    this.dialogContent.title = value;
    return this;
  }

  public setMessage(value: string): SimpleDialog {
    this.dialogContent.message = value;
    return this;
  }

  public setConfirmButtonText(value: string): SimpleDialog {
    this.dialogContent.confirmButtonText = value;
    return this;
  }

  public setCancelButtonText(value: string): SimpleDialog {
    this.dialogContent.cancelButtonText = value;
    return this;
  }

  public onWillDismiss(callback: () => boolean): SimpleDialog {
    this.willDismiss = callback;
    return this;
  }

  public onConfirm(callback: () => void): SimpleDialog {
    this.confirm = () => {
      this._close();
      callback();
    };
    this.dialogContent.confirm = this.confirm;
    return this;
  }

  public onCancel(callback: () => void): SimpleDialog {
    this.cancel = () => {
      this._close();
      callback();
    };
    this.dialogContent.cancel = this.cancel;
    return this;
  }

  public open(): void {
    if (this.node) {
      return;
    }
    this.node = new ComponentContent(this.uiContext, wrapBuilder(buildSimpleDialog), this.dialogContent);
    this.promptAction
      .openCustomDialog(this.node, {
        onWillDismiss: () => {
          if (this.willDismiss()) {
            this._close();
          }
        },
      })
      .catch(() => this.node = null);
  }

  public close(): void {
    this._close();
  }

  constructor(uiContext: UIContext) {
    this.uiContext = uiContext;
    this.promptAction = uiContext.getPromptAction();
    this.dialogContent.confirm = this.confirm;
    this.dialogContent.cancel = this.cancel;
  }
}

@ObservedV2
class DialogContentVM {

  @Trace
  public title: string = '';

  @Trace
  public message: string = '';

  @Trace
  public confirmButtonText: string = '确定';

  @Trace
  public cancelButtonText: string = '取消';

  @Trace
  public confirm: () => void = () => {};

  @Trace
  public cancel: () => void = () => {};

}

@Builder
function buildSimpleDialog(content: DialogContentVM): void {
  Column() {
    Column() {
      Text(content.title)
        .fontSize($r('sys.float.Title_S'))
        .fontWeight(FontWeight.Bold)
      Text(content.message)
        .fontSize($r('sys.float.Body_M'))
        .margin({ top: 16 })
      Row() {
        Button() {
          Text(content.cancelButtonText)
            .fontColor($r('sys.color.font_emphasize'))
            .fontWeight(FontWeight.Bold)
            .padding({ top: 10, bottom: 10 })
        }
        .width('50%')
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .onClick(() => content.cancel())
        Button() {
          Text(content.confirmButtonText)
            .fontColor($r('sys.color.font_emphasize'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .padding({ top: 10, bottom: 10 })
        }
        .width('50%')
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .onClick(() => content.confirm())
      }
      .margin({ top: 8 })
    }
    .width('100%')
    .padding(16)
    .borderRadius(24)
    .backgroundColor(Color.White)
  }
  .width('100%')
  .padding({ left: 16, right: 16 })
}
