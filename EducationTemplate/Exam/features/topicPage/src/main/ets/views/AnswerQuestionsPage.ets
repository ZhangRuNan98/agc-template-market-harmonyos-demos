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

import { examPrefer, ExamPreferences, Logger, PreferConstant, QuestionsRoterModel } from 'commonlib';
import { AnswerItemType, TopicItemType } from 'commonlib';
import { TestReportModel } from './TestReportPage';
import { RouterMap, RouterModule } from 'router_module';
import {
  AnswerItemPreference,
  TopicItemModel,
  TopicItemModelPreference
} from 'answer_questions/src/main/ets/viewModel/TopicItemModel';
import { AnswerQuestionsComponent } from 'answer_questions';
import { AlertDialog } from '@kit.ArkUI';

const TAG = 'AnswerQuestionsPage';

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

  // 返回弹框
  backDialogController: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: '温馨提示',
      content: '您的练习计划还没有完成！确定需要退出本次练习训练吗？',
      primaryButton: {
        value: '结束练习',
        fontColor: $r('sys.color.font_tertiary'),
        action: () => {
          RouterModule.pop()
        },
      },
      secondaryButton: {
        value: '继续练习',
        action: () => {
        }
      },
    }),
  })

  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear')
    let temp: QuestionsRoterModel =
      RouterModule.getNavParam({ url: RouterMap.AnswerQuestions_Page }) as QuestionsRoterModel
    this.sourceRoterModel = temp
    Logger.info(JSON.stringify(temp))
  }

  aboutToDisappear(): void {
  }

  build() {
    AnswerQuestionsComponent({
      isCollectionEvent: () => {
        this.isCollectionEvent()
      },
      confirmAddNote: (note: string) => {
        this.confirmAddNote(note)
      },
      storageWrongClick: () => {
        this.storageWrongClick()
      },
      storageCollectClick: () => {
        this.storageCollectClick()
      },
      viewReport: () => {
        this.viewReport()
      },
      onClickBack: () => {
        if (this.sourceRoterModel?.sourceType === '我的错题' || this.sourceRoterModel?.sourceType === '我的收藏') {
          RouterModule.pop()
        } else {
          this.backDialogController.open();
        }
      }
    })
  }

  async isCollectionEvent() {
    let itemTypeArr: TopicItemType[] =
      await examPrefer.getPreferenceValue(PreferConstant.EXAMPREFER_COLLECT, []) as TopicItemType[];
    let arr: string[] = []
    itemTypeArr.forEach((model: TopicItemType) => {
      arr.push(model.keyID)
    })
    let array = arr.filter(() => arr.includes(this.currentModel!.keyID))
    if (array.length === 0) {
      this.isCollection = false
    } else {
      this.isCollection = true
    }
  }

  viewReport() {
    // 跳转到测试报告页面
    let testReport: TestReportModel = new TestReportModel();
    testReport.ques = this.ques;
    testReport.quesType = 1;
    testReport.practiceDuration = this.practiceDuration;
    RouterModule.replace({ url: RouterMap.TestReportPage, param: testReport });
  }

  /**
   * 添加笔记
   * @param note 笔记
   */
  confirmAddNote(note: string) {
    this.currentModel!.note = note
    console.info(`note is ${note}`);
    if (ExamPreferences.notesPreferences && this.currentModel) {
      if (note && note !== '') {
        this.topicItemModelPref.type = this.currentModel.type
        this.topicItemModelPref.title = this.currentModel.title
        this.topicItemModelPref.keyID = this.currentModel.keyID
        this.topicItemModelPref.isAnswer = this.currentModel.isAnswer
        this.topicItemModelPref.rightQues = this.currentModel.rightQues
        this.topicItemModelPref.parse = this.currentModel.parse
        this.topicItemModelPref.note = this.currentModel.note
        this.topicItemModelPref.addNoteTime = new Date().getTime();
        let ans: AnswerItemPreference[] = []
        for (let index = 0; index < this.currentModel.ques.length; index++) {
          let objItem = this.currentModel.ques[index]
          let it: AnswerItemPreference = new AnswerItemPreference()
          it.ansTitle = objItem.ansTitle
          it.ans = objItem.ans
          it.ansID = objItem.ansID
          it.isSelect = objItem.isSelect
          it.showState = objItem.showState
          ans.push(it)
        }
        this.topicItemModelPref.ques = ans
        // 将笔记数据存入持久层
        ExamPreferences.notesPreferences.put(this.topicItemModelPref.keyID, this.topicItemModelPref);
        // 写入文件
        ExamPreferences.notesPreferences.flush();
      } else {
        let isExist: boolean = ExamPreferences.notesPreferences.hasSync(this.topicItemModelPref.keyID);
        if (isExist) {
          // 删除持久层笔记数据
          ExamPreferences.notesPreferences.deleteSync(this.topicItemModelPref.keyID);
          // 写入文件
          ExamPreferences.notesPreferences.flush();
        }
      }
    }
  }

  // 错题记录
  async storageWrongClick() {
    if (this.sourceRoterModel?.sourceType === '我的错题') {
    } else if (this.sourceRoterModel?.sourceType === '我的收藏') {
    } else if (this.sourceRoterModel?.sourceType === '错题练习') {
    } else {
      if (this.currentModel) {
        if (this.currentModel.selectQues.toString() !== this.currentModel.rightQues.toString()) {
          let currentItem: TopicItemType = {} as TopicItemType
          currentItem.type = this.currentModel.type;
          currentItem.title = this.currentModel.title;
          currentItem.keyID = this.currentModel.keyID;
          currentItem.rightQues = this.currentModel.rightQues;
          currentItem.parse = this.currentModel.parse;
          currentItem.note = '';
          currentItem.selectQues = [];
          currentItem.isAnswer = false;
          let it: AnswerItemType[] = []
          for (let index = 0; index < this.currentModel.ques.length; index++) {
            let answerItem: AnswerItemType = {} as AnswerItemType
            let element = this.currentModel.ques[index];
            answerItem.ansTitle = element.ansTitle
            answerItem.ans = element.ans
            answerItem.ansID = element.ansID
            it.push(answerItem)
          }
          currentItem.ques = it
          currentItem.jlStamp = Date.now()
          let arr: TopicItemType[] =
            await examPrefer.getPreferenceValue(PreferConstant.EXAMPREFER_CTJL, []) as TopicItemType[]
          if (arr.length === 0) {
            arr.push(currentItem)
          } else {
            let isExit = false
            arr.forEach((itemType: TopicItemType, idx: number) => {
              if (itemType.keyID === currentItem.keyID) {
                arr[idx] = currentItem
                isExit = true
              }
            })
            if (!isExit) {
              arr.push(currentItem)
            }
          }
          examPrefer.putPreferenceValue(PreferConstant.EXAMPREFER_CTJL, arr)
          Logger.info(TAG, JSON.stringify(currentItem))
        }
      }
    }
  }

  // 收藏记录
  async storageCollectClick() {
    if (this.sourceRoterModel?.sourceType === '我的错题') {
    } else if (this.sourceRoterModel?.sourceType === '我的收藏') {
    } else {
      if (this.currentModel) {
        let currentItem: TopicItemType = {} as TopicItemType
        currentItem.type = this.currentModel.type;
        currentItem.title = this.currentModel.title;
        currentItem.keyID = this.currentModel.keyID;
        currentItem.rightQues = this.currentModel.rightQues;
        currentItem.parse = this.currentModel.parse;
        currentItem.note = '';
        currentItem.selectQues = [];
        currentItem.isAnswer = false;
        let it: AnswerItemType[] = []
        for (let index = 0; index < this.currentModel.ques.length; index++) {
          let answerItem: AnswerItemType = {} as AnswerItemType
          let element = this.currentModel.ques[index];
          answerItem.ansTitle = element.ansTitle
          answerItem.ans = element.ans
          answerItem.ansID = element.ansID
          it.push(answerItem)
        }
        currentItem.ques = it
        currentItem.jlStamp = Date.now()
        let arr: TopicItemType[] =
          await examPrefer.getPreferenceValue(PreferConstant.EXAMPREFER_COLLECT, []) as TopicItemType[]
        if (arr.length === 0) {
          arr.push(currentItem)
        } else {
          let isExit = false
          let idx: number = 0
          arr.forEach((itemType: TopicItemType, idx: number) => {
            if (itemType.keyID === this.currentModel!.keyID) {
              arr.splice(idx, 1)
              isExit = true
            }
          })
          if (isExit) {
          } else {
            arr.push(currentItem)
          }
        }
        examPrefer.putPreferenceValue(PreferConstant.EXAMPREFER_COLLECT, arr)
        Logger.info(TAG, JSON.stringify(currentItem))
        this.isCollectionEvent()
      }
    }
  }
}

@Builder
export function AnswerQuestionsPageBuilder() {
  AnswerQuestionsPage()
}

