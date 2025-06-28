/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { speechRecognizer } from '@kit.CoreSpeechKit';
import { BusinessError, pasteboard } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { camera, cameraPicker as picker } from '@kit.CameraKit'
import { fileIo } from '@kit.CoreFileKit'
import { image } from '@kit.ImageKit';
import { textRecognition } from '@kit.CoreVisionKit';

const TAG = '语音识别'

@ComponentV2
export struct SearchQuestionPage {
  @Local textInput: string = ''
  textInputPre: string = ''
  private context: Context = getContext(this) as common.UIAbilityContext
  @Local sessionId: string = '123456';
  asrEngine: speechRecognizer.SpeechRecognitionEngine | null = null
  private atManager = abilityAccessCtrl.createAtManager();
  @Event search: (data: string) => void = () => {
  }
  // 回退
  @Event back: () => void = () => {
  }
  @Local isFocus: boolean = false;
  @Local selectionStart: number = 0;
  controller: TextAreaController = new TextAreaController()

  aboutToDisappear(): void {
    this.asrEngine?.shutdown()
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.ic_backward')).height('40vp').width('40vp').margin({ right: '8vp' })
            .onClick(() => {
              this.back()
            })
          Text('一键搜题')
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .height(56)
      .width('100%')
      .margin({ bottom: '8vp' })
      .padding({ left: 16, right: 16 })

      Divider().margin({ bottom: '12vp' })
      Column() {
        // 搜索文本框
        TextArea({
          text: $$this.textInput,
          placeholder: '请输入关键字进行搜索',
          controller: this.controller
        })
          .height('154vp')
          .width('100%')
          .backgroundColor($r('sys.color.background_primary'))
          .borderWidth(1)
          .margin({ bottom: '12vp' })
          .onChange((value) => {
            if (value === '') {
              this.textInputPre = ''
            }
          })
          .onFocus(() => {
            this.isFocus = true
          })
          .onBlur(() => {
            this.isFocus = false
          })// 所选文本的起始位置和结束位置。
          .onTextSelectionChange((selectionStart: number, selectionEnd: number) => {
            this.selectionStart = selectionStart
            console.log(selectionEnd.toString())
          })
        // 语音,拍照,清除并粘贴，清除功能按钮
        Row() {
          Button({ type: ButtonType.Capsule, stateEffect: true }) {
            Row() {
              Image($r('app.media.ic_mic'))
                .height('16vp')
                .width('16vp')
                .margin({ right: '4vp' })
              Text('语音')
                .height(19)
                .lineHeight(19)
                .fontSize($r('sys.float.Body_M'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
            }
            .alignItems(VerticalAlign.Center)
            .width(64)
            .height(27)
            .padding({ left: '8vp', right: '8vp' })
            .onTouch(async (event) => {
              if (event.type === TouchType.Down) {
                this.atManager.requestPermissionsFromUser(this.context, ['ohos.permission.MICROPHONE'])
                  .then(async (data) => {
                    if (data.authResults[0] === 0) {
                      await this.createSREngine()
                      this.startListener()
                    }
                  })
                  .catch((err: BusinessError) => {
                    console.log(err.message)
                  });
              } else if (event.type === TouchType.Up) {
                this.finishListener(this.sessionId)
              }
            })
          }
          .backgroundColor($r('sys.color.background_secondary'))
          .margin({ left: '28vp', right: '8vp' })

          Button({ type: ButtonType.Capsule, stateEffect: true }) {
            Row() {
              Image($r('app.media.ic_camera'))
                .height('16vp')
                .width('16vp')
                .margin({ right: '4vp' })
              Text('拍照')
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
                .height(19)
                .lineHeight(19)
            }
            .alignItems(VerticalAlign.Center)
            .width(64)
            .height(27)
            .padding({ left: '8vp', right: '8vp' })
            .onClick(() => {
              this.startCameraPicker()
            })
          }
          .backgroundColor($r('sys.color.background_secondary'))
          .margin({ right: '30vp' })

          Row() {
            PasteButton({ text: PasteDescription.PASTE })
              .onClick((event: ClickEvent, result: PasteButtonOnClickResult) => {
                console.log(JSON.stringify(event))
                if (PasteButtonOnClickResult.SUCCESS === result) {
                  pasteboard.getSystemPasteboard().getData((err: BusinessError, pasteData: pasteboard.PasteData) => {
                    if (err) {
                      console.error(`Failed to get paste data. Code is ${err.code}, message is ${err.message}`);
                      return;
                    }
                    if (this.isFocus) {
                      if (this.textInput.length !== this.selectionStart && this.textInput.length !== 0) {
                        let str1 = this.textInput.slice(0, this.selectionStart)
                        let str2 = this.textInput.slice(this.selectionStart, this.textInput.length);
                        this.textInput = str1 + pasteData.getPrimaryText() + str2
                      } else {
                        if (this.selectionStart === this.textInput.length) {
                          this.textInput += pasteData.getPrimaryText();
                        } else {
                          this.textInput = pasteData.getPrimaryText();
                        }
                      }
                    } else {
                      this.textInput = pasteData.getPrimaryText();
                    }
                  });
                }
              })
              .width(44)
              .height(27)
              .backgroundColor($r('sys.color.background_secondary'))
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
          }
          .width(44)
          .height(27)
          .margin({ right: '8vp' })

          Button({ type: ButtonType.Capsule, stateEffect: true }) {
            Row() {
              Text('清除')
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
                .height(19)
                .lineHeight(19)
            }
            .alignItems(VerticalAlign.Center)
            .width(44)
            .height(27)
            .padding({ left: '8vp', right: '8vp' })
            .onClick(() => {
              this.textInput = ''
            })
          }
          .backgroundColor($r('sys.color.background_secondary'))
        }
        .width('100%')

        Button({ type: ButtonType.Capsule, stateEffect: true }) {
          Row() {
            Text('搜索')
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor(this.textInput ? $r('sys.color.font_primary') : $r('sys.color.font_tertiary'))
              .textAlign(TextAlign.Center)
          }
          .justifyContent(FlexAlign.Center)
          .width(304)
          .height(40)
          .padding({ left: 'vp', right: '8vp' })
          .onClick(() => {
            if (this.textInput) {
              this.search(this.textInput)
            }
          })
        }
        .backgroundColor($r('sys.color.background_secondary'))
        .margin({ top: '24vp' })
      }
      .padding({ left: 16, right: 16 })

    }
    .onClick(() => {
      this.controller.stopEditing()
    })
    .width('100%')
    .height('100%')
  }

  async createSREngine() {
    const extraParams: Record<string, Object> = {
      'locate': 'CN',
      'recognizerMode': 'short'
    }
    const initParamsInfo: speechRecognizer.CreateEngineParams = {
      language: 'zh-CN',
      online: 1,
      extraParams
    }
    try {
      this.asrEngine = await speechRecognizer.createEngine(initParamsInfo)
      hilog.info(0x0000, TAG, `获取语音转文字示例成功`)
      this.setListener()
    } catch (e) {
      hilog.error(0x0000, TAG, `获取语音转文字实例失败 ${e.code} ${e.message}`)
    }
  }

  // 麦克风语音转文本
  async startRecording(sessionId: string) {
    const audioParam: speechRecognizer.AudioInfo = {
      audioType: 'pcm',
      sampleRate: 16000,
      soundChannel: 1,
      sampleBit: 16
    };
    const extraParam: Record<string, Object> = { 'maxAudioDuration': 40000, 'recognitionMode': 0 };
    sessionId = new Date().getTime().toString()
    const recognizerParams: speechRecognizer.StartParams = {
      sessionId: sessionId,
      audioInfo: audioParam,
      extraParams: extraParam
    };
    this.asrEngine?.startListening(recognizerParams)
    hilog.info(0x0000, TAG, `已触发 startListening`)
  };

  // 设置回调
  setListener() {
    let that = this
    // 创建回调对象
    let setListener: speechRecognizer.RecognitionListener = {
      // 开始识别成功回调
      onStart(sessionId: string, eventMessage: string) {
        hilog.info(0x0000, TAG, `onStart, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
      },
      // 事件回调
      onEvent(sessionId: string, eventCode: number, eventMessage: string) {
        hilog.info(0x0000, TAG,
          `onEvent, sessionId: ${sessionId} eventCode: ${eventCode} eventMessage: ${eventMessage}`);
      },
      // 识别结果回调，包括中间结果和最终结果
      onResult(sessionId: string, result: speechRecognizer.SpeechRecognitionResult) {
        that.textInput = that.textInputPre + result.result
        hilog.info(0x0000, TAG, `onResult, sessionId: ${sessionId} sessionId: ${JSON.stringify(result)}`);
      },
      // 识别完成回调
      onComplete(sessionId: string, eventMessage: string) {
        that.textInputPre = that.textInput
        hilog.info(0x0000, TAG, `onComplete, sessionId: ${sessionId} eventMessage: ${eventMessage}`);
      },
      // 错误回调，错误码通过本方法返回
      // 返回错误码1002200002，开始识别失败，重复启动startListening方法时触发
      // 更多错误码请参考错误码参考
      onError(sessionId: string, errorCode: number, errorMessage: string) {
        hilog.error(0x0000, TAG,
          `onError, sessionId: ${sessionId} errorCode: ${errorCode} errorMessage: ${errorMessage}`);
      },
    }
    // 设置回调
    this.asrEngine?.setListener(setListener);
  };

  startListener() {
    const audioParam: speechRecognizer.AudioInfo = {
      audioType: 'pcm',
      sampleRate: 16000,
      soundChannel: 1,
      sampleBit: 16
    };
    const extraParam: Record<string, Object> = { 'maxAudioDuration': 40000, 'recognitionMode': 0 };
    this.sessionId = new Date().getTime().toString()
    const recognizerParams: speechRecognizer.StartParams = {
      sessionId: this.sessionId,
      audioInfo: audioParam,
      extraParams: extraParam
    };
    this.asrEngine?.startListening(recognizerParams)
    hilog.info(0x0000, TAG, `已触发 startListening`)
  }

  finishListener(sessionId: string) {
    this.asrEngine?.finish(sessionId)
  }

  // 拍照识别
  async startCameraPicker() {
    let pickerProfile: picker.PickerProfile = {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
    };
    let result: picker.PickerResult =
      await picker.pick(getContext(), [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO],
        pickerProfile);
    let uri = result.resultUri;
    let imageSource: image.ImageSource | undefined = undefined;
    let chooseImage: PixelMap | undefined = undefined;
    setTimeout(async () => {
      let fileSource = await fileIo.open(uri, fileIo.OpenMode.READ_ONLY);
      imageSource = image.createImageSource(fileSource.fd);
      chooseImage = await imageSource.createPixelMap();
      hilog.info(0x0000, 'OCRDemo', `chooseImage：${chooseImage.toString()}`);
      if (!chooseImage) {
        return;
      }
      // 调用文本识别接口
      let visionInfo: textRecognition.VisionInfo = {
        pixelMap: chooseImage
      };
      let textConfiguration: textRecognition.TextRecognitionConfiguration = {
        isDirectionDetectionSupported: true
      };
      await textRecognition.recognizeText(visionInfo, textConfiguration).then((textRecognitionResult) => {
        if (textRecognitionResult.value !== '') {
          this.search(textRecognitionResult.value)
        }
      })
    }, 100)
  }
}
