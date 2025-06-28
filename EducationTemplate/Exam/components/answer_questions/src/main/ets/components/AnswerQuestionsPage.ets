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

import { QuestionsRoterModel, QUESTION_DATA, TopicItemType, AnswerItemType } from '../viewModel/TopicPageModel';
import { AnswerItem, TopicItemModel, TopicItemModelPreference } from '../viewModel/TopicItemModel';
import { AnswerSheetDialog } from '../dialog/AnswerSheetDialog';
import { AddNoteDialog } from '../dialog/AddNoteDialog';
import { promptAction } from '@kit.ArkUI';

@ComponentV2
export struct AnswerQuestionsPage {
  @Provider() ques: TopicItemModel[] = [];
  @Provider() practiceDuration: number = 0;
  @Provider() topicItemModelPref: TopicItemModelPreference = new TopicItemModelPreference();
  @Provider() currentIndex: number = 0
  @Provider() currentModel: TopicItemModel | undefined = undefined
  @Provider() rightCont: number = 0
  @Provider() errCont: number = 0
  @Provider() isCollection: boolean = false
  // 错题 历史 收藏
  @Provider() sourceRoterModel: QuestionsRoterModel | undefined = undefined

  @Monitor('rightCont', 'errCont')
  onStrChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      console.info(`${path} changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    });
  }

  build() {
    AnswerQuestionsComponent({
      isCloseAnswerSheet: false,
      isCollectionEvent: () => {
      },
      confirmAddNote: (note: string) => {
        this.confirmAddNote(note)
      },
      storageWrongClick: () => {

      },
      storageCollectClick: () => {
        promptAction.showToast({
          message: '仅演示，可自行实现业务功能'
        })
      },
      viewReport: () => {
        promptAction.showToast({
          message: '仅演示，可自行实现业务功能'
        })
      },
      onClickBack: () => {
        promptAction.showToast({
          message: '仅演示，可自行实现业务功能'
        })
      }
    })
  }

  confirmAddNote(note: string) {
    this.currentModel!.note = note
    console.info(`note is ${note}`);
  }
}

@Builder
export function AnswerQuestionsPageBuilder() {
  AnswerQuestionsPage()
}

@ComponentV2
export struct AnswerQuestionsComponent {
  @Consumer() ques: TopicItemModel[] = [];
  @Consumer() practiceDuration: number = 0;
  @Consumer() currentIndex: number = 0
  @Consumer() currentModel: TopicItemModel | undefined = undefined
  @Consumer() rightCont: number = 0
  @Consumer() errCont: number = 0
  @Consumer() isCollection: boolean = false
  offsetX: number = 0;
  positionX: number = 0;
  panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right })
  textTimerController: TextTimerController = new TextTimerController();
  format: string = 'HH:mm:ss';
  scroller: Scroller = new Scroller();
  // 错题 历史 收藏
  @Consumer() sourceRoterModel: QuestionsRoterModel | undefined = undefined

  @Monitor('rightCont', 'errCont')
  onStrChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      console.info(`${path} changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    });
  }

  // 是否关闭答题卡
  @Param isCloseAnswerSheet: boolean = true;
  // 是否收藏
  @Param isCollectionEvent: () => void = () => {
  };
  // 提交添加笔记
  @Param confirmAddNote: (note: string) => void = () => {
  };
  // 错题记录
  @Param storageWrongClick: () => void = () => {
  };
  // 收藏记录
  @Param storageCollectClick: () => void = () => {
  };
  // 查看报告
  @Param viewReport: () => void = () => {
  };
  // 点击返回上一级
  @Param onClickBack: () => void = () => {
  };
  // 添加笔记弹框
  addNoteDialogController: CustomDialogController | null = new CustomDialogController({
    builder: AddNoteDialog({
      note: this.currentModel?.note,
      confirmAddNote: (note) => {
        this.confirmAddNote(note)
      }
    }),
    cancel: () => {
      this.addNoteDialogController?.close();
    },
    isModal: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    keyboardAvoidMode: KeyboardAvoidMode.NONE
  });
  // 答题卡弹框
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: AnswerSheetDialog({
      practiceDuration: this.practiceDuration,
      textTimerController: this.textTimerController,
      quesType: 1,
      ques: this.ques,
      selectIndex: (index) => {
        this.onSelectIndex(index)
      },
      viewReport: () => {
        if (this.isCloseAnswerSheet === true) {
          // 关闭答题卡弹框
          this.dialogController?.close();
        }
        this.viewReport()
      }
    }),
    cancel: () => {
      this.dialogController?.close();
      this.textTimerController.start();
    },
    isModal: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  });

  aboutToAppear(): void {
    // 初始化数据
    this.currentIndex = 0
    this.initCurrentModel()
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          this.topBuilder()
          Divider().color($r('sys.color.comp_divider'))
          if (this.sourceRoterModel?.sourceType === '我的错题') {
          } else if (this.sourceRoterModel?.sourceType === '我的收藏') {
          } else {
            // 收藏、答对、答错
            this.collectBuilder()
            Divider().color($r('sys.color.comp_divider'))
          }
          Scroll(this.scroller) {
            Column() {
              Column() {
                Row() {
                  Text($r('app.string.single_choice'))
                    .width($r('app.float.vp_72'))
                    .height($r('app.float.vp_28'))
                    .fontSize($r('sys.float.Body_M'))
                    .fontWeight(FontWeight.Regular)
                    .fontColor($r('sys.color.font_on_primary'))
                    .textAlign(TextAlign.Center)
                    .backgroundColor($r('app.color.view_report_btn'))
                    .borderRadius($r('app.float.vp_8'))
                }
                .width('100%')
                .margin({ top: $r('app.float.vp_12'), bottom: $r('app.float.vp_12') })

                Text(`${this.currentIndex + 1}` + '、' + this.currentModel!.title)
                  .width('100%')
                  .fontSize($r('sys.float.Body_M'))
                  .fontWeight(FontWeight.Regular)
                  .fontColor($r('sys.color.font_primary'))
                  .margin({ bottom: $r('app.float.vp_15') })

                Column() {
                  ForEach(this.currentModel!.ques, ((item: AnswerItem) => {
                    Row() {
                      Image(item.showState === 1 ? $r('app.media.icon_wrong') :
                        (item.showState === 2 ? $r('app.media.icon_true') : $r('app.media.icon_anscommon')))
                        .height($r('app.float.vp_20'))
                        .width($r('app.float.vp_20'))

                      Text(`${item.ans}` + '：' + `${item.ansTitle}`)
                        .fontSize($r('sys.float.Body_M'))
                        .fontWeight(FontWeight.Regular)
                        .fontColor($r('sys.color.font_primary'))
                        .margin({ left: $r('app.float.vp_14') })
                    }
                    .justifyContent(FlexAlign.Start)
                    .alignItems(VerticalAlign.Top)
                    .margin({ top: $r('app.float.vp_16') })
                    .padding({ right: $r('app.float.vp_12') })
                    .onClick(() => {
                      this.answerEvent(item)
                    })
                  }), (item: AnswerItem, index: number) => item.ansID + index)
                }
                .alignItems(HorizontalAlign.Start)
                .width('100%')

              }
              .width('100%')
              .padding({ left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })

              if (this.currentModel?.isAnswer) {
                Column() {
                  // 正确答案
                  this.correctAnswerBuilder()

                  Divider()
                    .color($r('sys.color.background_secondary'))
                    .strokeWidth(8)
                    .margin({ top: $r('app.float.vp_24'), bottom: $r('app.float.vp_24') })

                  // 解析
                  this.parseBuilder()

                  Divider()
                    .color($r('sys.color.background_secondary'))
                    .strokeWidth(8)
                    .margin({ top: $r('app.float.vp_24'), bottom: $r('app.float.vp_24') })

                  // 笔记
                  this.noteBuilder()
                }
                .width('100%')
              }
              Blank(130)
            }
          }
          .scrollBar(BarState.Off)
        }
        // 左右滑动触发该手势事件
        .gesture(
          PanGesture(this.panOption)
            .onActionStart(() => {
              console.info('Pan start')
            })
            .onActionUpdate((event: GestureEvent) => {
              if (event) {
                this.offsetX = this.positionX + event.offsetX
              }
            })
            .onActionEnd(() => {
              if (this.offsetX > this.positionX) {
                // 向右滑
                this.currentIndex -= 1
                this.currentIndex = Math.max(this.currentIndex, 0)
              } else {
                // 向左滑
                this.currentIndex += 1
                this.currentIndex = Math.min(this.currentIndex, this.ques.length - 1)
              }
              this.currentModel = this.ques[this.currentIndex]
              this.positionX = this.offsetX
              this.isCollectionEvent()
              console.info('Pan end')
            })
        )
        .width('100%')
        .height('100%')

      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)

      if (this.sourceRoterModel?.sourceType === '我的错题') {
      } else if (this.sourceRoterModel?.sourceType === '我的收藏') {
      } else {
        // 底部操作栏
        this.bottomOperateBuilder()
      }

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 底部操作栏
  @Builder
  bottomOperateBuilder() {
    Row() {
      Column() {
        Image($r('app.media.icon_answer_sheet'))
          .width($r('app.float.vp_24'))
          .height($r('app.float.vp_24'))
        Text($r('app.string.answer_sheet'))
          .fontSize($r('sys.float.Caption_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.icon_primary'))
          .margin({ top: $r('app.float.vp_2') })
      }
      .width($r('app.float.vp_38'))
      .height($r('app.float.vp_48'))
      .margin({ left: $r('app.float.vp_28'), right: $r('app.float.vp_26') })
      .padding($r('app.float.vp_4'))
      .onClick(() => {
        this.dialogController?.open();
      })

      // 上一题
      Row({ space: 12 }) {
        Button($r('app.string.pre_question'), { type: ButtonType.Normal, stateEffect: true })
          .backgroundColor(this.currentIndex === 0 ? $r('sys.color.comp_background_tertiary') :
          $r('app.color.view_report_btn'))
          .stateEffect(this.currentIndex === 0 ? false : true)
          .fontColor($r('sys.color.font_on_primary'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .width($r('app.float.vp_120'))
          .height($r('app.float.vp_40'))
          .borderRadius($r('app.float.vp_20'))
          .onClick(() => {
            if (this.currentIndex === 0) {
              console.log('currentIndex is 0');
            } else {
              this.currentIndex -= 1
              this.currentIndex = Math.max(this.currentIndex, 0)
              this.currentModel = this.ques[this.currentIndex]
              this.isCollectionEvent()
            }
          })

        // 下一题/查看报告
        Button(this.currentIndex === this.ques.length - 1 ? $r('app.string.view_report_btn') :
        $r('app.string.next_question'),
          { type: ButtonType.Normal, stateEffect: true })
          .backgroundColor($r('app.color.view_report_btn'))
          .fontColor($r('sys.color.font_on_primary'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .width($r('app.float.vp_120'))
          .height($r('app.float.vp_40'))
          .borderRadius(20)
          .onClick(() => {
            if (this.currentIndex >= this.ques.length - 1) {
              this.viewReport()
            } else {
              this.currentIndex += 1
              this.currentIndex = Math.min(this.currentIndex, this.ques.length - 1)
              this.currentModel = this.ques[this.currentIndex]
            }
            this.isCollectionEvent()
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ right: $r('app.float.vp_16') })
      .layoutWeight(1)
    }
    .width('100%')
    .height($r('app.float.vp_48'))
    .shadow({
      radius: 10,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetY: -10
    })
  }

  /**
   * 笔记
   */
  @Builder
  noteBuilder() {
    Column() {
      Row() {
        Text($r('app.string.note'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.icon_primary'))

        Row() {
          Text('+')
            .width($r('app.float.vp_16'))
            .height($r('app.float.vp_16'))
            .fontColor($r('sys.color.font_on_primary'))
            .textAlign(TextAlign.Center)
            .backgroundColor($r('app.color.view_report_btn'))
            .borderRadius($r('app.float.vp_8'))
          Text($r('app.string.add_note'))
            .fontColor($r('app.color.view_report_btn'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
            .margin({ left: $r('app.float.vp_4') })
        }
        .width($r('app.float.vp_92'))
        .height($r('app.float.vp_28'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .borderRadius($r('app.float.vp_14'))
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.addNoteDialogController?.open();
        })
      }
      .width('100%')
      .margin({ bottom: $r('app.float.vp_12') })
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        if (this.currentModel?.note) {
          Text(this.currentModel?.note)
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.icon_primary'))
        } else {
          Text($r('app.string.note_desc'))
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.icon_secondary'))
        }

      }
      .width('100%')
    }
    .padding({ left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })
    .width('100%')
  }

  // 正确答案
  @Builder
  correctAnswerBuilder() {
    Column() {
      Row() {
        Text($r('app.string.correct_answer'))
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.icon_primary'))
        Text(this.currentModel?.rightQues.toString())
          .fontColor($r('sys.color.multi_color_04'))
          .fontSize($r('sys.float.Body_M'))
          .width($r('app.float.vp_28'))
          .height($r('app.float.vp_20'))
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height($r('app.float.vp_48'))
      .padding({ left: $r('app.float.vp_12') })
      .backgroundColor($r('sys.color.background_secondary'))
      .justifyContent(FlexAlign.Start)
      .borderRadius($r('app.float.vp_12'))
    }
    .width('100%')
    .padding({ left: $r('app.float.vp_16'), right: $r('app.float.vp_16'), top: $r('app.float.vp_12') })

  }

  // 解析
  @Builder
  parseBuilder() {
    Column() {
      Row() {
        Text($r('app.string.parse'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.icon_primary'))
      }
      .width('100%')
      .margin({ bottom: $r('app.float.vp_12') })

      Row() {
        Text(`答案解析：${this.currentModel?.parse}`)
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.icon_primary'))
      }
      .width('100%')
    }
    .padding({ left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })
    .width('100%')

  }

  // 顶部
  @Builder
  topBuilder() {
    Row() {
      // 答题
      Row() {
        Row() {
          Image($r('app.media.chevron_backward'))
            .height($r('app.float.vp_24'))
            .width($r('app.float.vp_24'))
            .onClick(() => {
              this.onClickBack()
            })
        }
        .height($r('app.float.vp_40'))
        .width($r('app.float.vp_40'))
        .backgroundColor($r('sys.color.background_secondary'))
        .borderRadius($r('app.float.vp_40'))
        .padding($r('app.float.vp_8'))

        Text($r('app.string.answer_questions'))
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .margin({ left: $r('app.float.vp_8') })
      }

      if (this.sourceRoterModel?.sourceType === '我的错题') {
      } else if (this.sourceRoterModel?.sourceType === '我的收藏') {
      } else {
        Row() {
          Image($r('app.media.ic_public_alarm_clock'))
            .width($r('app.float.vp_24'))
            .height($r('app.float.vp_24'))

          // 计时器
          TextTimer({ controller: this.textTimerController })
            .format(this.format)
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Body_L'))
            .margin({ left: $r('app.float.vp_4') })
            .onTimer((utc: number, elapsedTime: number) => {
              console.info('textTimer notCountDown utc is：' + utc + ', elapsedTime: ' + elapsedTime);
              this.practiceDuration = elapsedTime;
            })
            .onAppear(() => {
              this.textTimerController.start();
            })
            .onDisAppear(() => {
              this.textTimerController.reset();
            })
        }
      }
    }
    .width('100%')
    .height($r('app.float.vp_56'))
    .padding({ left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })
    .justifyContent(FlexAlign.SpaceBetween)

  }

  // 收藏、答对、答错
  @Builder
  collectBuilder() {
    Row() {
      Row() {
        Image(this.isCollection ? $r('app.media.ic_star') : $r('app.media.icon_star'))
          .width($r('app.float.vp_24'))
          .height($r('app.float.vp_24'))
        Text($r('app.string.collect'))
          .fontSize($r('sys.float.Caption_M'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.icon_primary'))
          .margin({ left: $r('app.float.vp_4') })
      }
      .padding($r('app.float.vp_4'))
      .onClick(() => {
        this.storageCollectClick()
      })

      Row() {
        Row() {
          Image($r('app.media.icon_true'))
            .width($r('app.float.vp_24'))
            .height($r('app.float.vp_24'))
            .padding($r('app.float.vp_2'))
          Text(`${this.rightCont}`)
            .fontSize($r('sys.float.Caption_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.icon_primary'))
            .margin({ left: $r('app.float.vp_4') })
        }
        .padding($r('app.float.vp_4'))

        Row() {
          Image($r('app.media.icon_wrong'))
            .width($r('app.float.vp_24'))
            .height($r('app.float.vp_24'))
            .padding($r('app.float.vp_2'))
          Text(`${this.errCont}`)
            .fontSize($r('sys.float.Caption_L'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.icon_primary'))
            .margin({ left: $r('app.float.vp_4') })
        }
        .margin({ left: $r('app.float.vp_12') })
        .padding($r('app.float.vp_4'))
      }
    }
    .width('100%')
    .height($r('app.float.vp_56'))
    .padding({ left: $r('app.float.vp_24'), right: $r('app.float.vp_24') })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  /**
   * 数据初始化
   */
  initCurrentModel() {

    let data: TopicItemType[] = QUESTION_DATA
    if (this.sourceRoterModel?.sourceType === '我的错题') {
      data = this.sourceRoterModel.datalist
    } else if (this.sourceRoterModel?.sourceType === '我的收藏') {
      data = this.sourceRoterModel.datalist
    } else if (this.sourceRoterModel?.sourceType === '错题练习') {
      data = this.sourceRoterModel.datalist
    }
    if (data && data.length > 0) {
      data.forEach((obj: TopicItemType) => {
        let topicItem: TopicItemModel = new TopicItemModel('001', '1', '行业模板规范可以可以从以下哪个渠道获取？',
          [new AnswerItem('对', '', 'A', false, 0), new AnswerItem('错', '', 'B', false, 0),
            new AnswerItem('以上都对', '', 'C', false, 0), new AnswerItem('以上都错', '', 'D', false, 0)],
          ['A'], [], false, '', '')
        topicItem.type = obj.type
        topicItem.title = obj.title
        topicItem.keyID = obj.keyID
        topicItem.isAnswer = false
        topicItem.rightQues = obj.rightQues
        topicItem.parse = obj.parse
        topicItem.note = ''
        topicItem.selectQues = []
        let ans: AnswerItem[] = []
        obj.ques.forEach((objItem: AnswerItemType) => {
          let it: AnswerItem = new AnswerItem('', '', 'B', false, 0)
          it.ansTitle = objItem.ansTitle
          it.ans = objItem.ans
          it.ansID = objItem.ansID
          ans.push(it)
        });
        topicItem.ques = ans
        this.ques.push(topicItem)
      });
      this.currentModel = this.ques[this.currentIndex]
      this.isCollectionEvent()
    }
  }

  /**
   * 答题逻辑处理
   */
  answerEvent(item: AnswerItem) {
    if (!this.currentModel!.isAnswer) {
      // 单选类型
      this.currentModel!.isAnswer = true;
      item.isSelect = true;
      this.currentModel?.selectQues.push(item.ans)
      for (let index = 0; index < this.currentModel!.ques.length; index++) {
        let element = this.currentModel!.ques[index];
        if (element.isSelect) {
          // 选中项
          if (!this.currentModel!.rightQues.includes(element.ans)) {
            element.showState = 1
            this.currentModel!.showState = 1
            this.errCont++
          } else {
            element.showState = 2
            this.currentModel!.showState = 2
            this.rightCont++
          }
        } else {
          // 未选中的列表项
          if (this.currentModel!.rightQues.includes(element.ans)) {
            element.showState = 2
          } else {
            element.showState = 0
          }
        }
      }
      this.storageWrongClick()
    }
  }

  onSelectIndex(index: number) {
    this.currentIndex = index
    this.currentModel = this.ques[this.currentIndex]
    console.info('Callback when the second button is clicked');
  }
}