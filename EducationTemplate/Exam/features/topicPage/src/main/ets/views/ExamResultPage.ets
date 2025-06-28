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

import { RouterMap, RouterModule } from 'router_module'
import { TestReportModel } from './TestReportPage'
import dayjs from 'dayjs'
import { TopicItemModel } from 'answer_questions/src/main/ets/viewModel/TopicItemModel'
import { TopBar } from 'commonlib'

@ComponentV2
export struct ExamResultIndexPage {
  // 题库数据
  private ques: TopicItemModel[] = []
  // 正确数
  private rightCont: number = 0
  // 分数
  private fraction: number = 0
  // 耗时
  practiceDurationFormat: string = '';
  // 记录时间
  submitTime: string = dayjs().format('YYYY-MM-DD HH:mm')
  // 俩种模式 1练习模式 2答题模式
  @Local quesType: number = 1

  aboutToAppear() {
    let temp: TestReportModel | undefined = RouterModule.getNavParam({ url: RouterMap.ExamResultPage_Page })
    if (temp) {
      let practiceDuration = temp.practiceDuration;
      this.practiceDurationFormat = Math.floor(practiceDuration / 60) + '分' + practiceDuration % 60 + '秒'
      this.quesType = temp.quesType
      this.ques = temp.ques
      for (let index = 0; index < this.ques.length; index++) {
        let element = this.ques[index];
        if (element.selectQues.toString() === element.rightQues.toString()) {
          this.rightCont++
        } else {
        }
      }
      this.fraction = this.rightCont * 10
    }
  }

  build() {
    Column() {
      // 顶部
      this.TopComponentBuild()
      Divider().color($r('sys.color.comp_divider'))
      Row() {
        Column() {
          Text('测评试卷：建筑工程经济')
            .fontSize($r('sys.float.Body_L'))
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Regular)
            .width('100%')
            .height($r('app.float.fp_22'))
          Row() {
            Text('提交时间：')
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Regular)
              .height($r('app.float.fp_22'))
            Text(this.submitTime)
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_primary'))
              .fontWeight(FontWeight.Regular)
              .height($r('app.float.fp_22'))
          }
          .width('100%')
          .margin({ top: $r('app.float.vp_9') })
        }
        .height('100%')
        .width('100%')
      }
      .width('100%')
      .height($r('app.float.vp_52'))
      .margin({ top: $r('app.float.vp_12') })
      .padding({ left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })

      Image(this.fraction >= 80 ? $r('app.media.pass') : $r('app.media.not_passed'))
        .height($r('app.float.vp_192'))
        .width($r('app.float.vp_244'))
        .margin({ top: $r('app.float.vp_24'), bottom: $r('app.float.vp_24') })
      if (this.fraction >= 80) {
        Text('恭喜！你通过本次测评！')
          .textAlign(TextAlign.Center)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.black'))
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: $r('app.float.vp_16') })
      } else {
        Text('很抱歉，你未通过本次测评！')
          .fontColor($r('sys.color.black'))
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .margin({ bottom: $r('app.float.vp_8') })
        Text('别灰心，迎难而上再测一下，下次一定会成功哒~~')
          .textAlign(TextAlign.Center)
          .fontSize($r('sys.float.Caption_L'))
          .fontColor($r('sys.color.font_secondary'))
          .fontWeight(FontWeight.Regular)
          .margin({ bottom: $r('app.float.vp_16') })
      }
      Column() {
        Text() {
          Span('作答分数：')
            .fontColor($r('sys.color.font_secondary'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Regular)
          Span(this.fraction + '分')
            .fontSize($r('sys.float.Title_S'))
            .fontColor(this.fraction >= 80 ? $r('sys.color.multi_color_04') : $r('sys.color.multi_color_aux_08'))
            .fontWeight(FontWeight.Medium)
        }
        .textAlign(TextAlign.Start)
        .margin({ bottom: $r('app.float.vp_8') })

        Text() {
          Span('是否通过：')
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_secondary'))
            .fontWeight(FontWeight.Regular)
          Span(this.fraction >= 80 ? '通过' : '未通过')
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_primary'))
        }
        .textAlign(TextAlign.Start)
        .margin({ bottom: $r('app.float.vp_8') })

        Text() {
          Span('正确题数：')
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_secondary'))
            .fontWeight(FontWeight.Regular)

          Span(`${this.rightCont}/${this.ques.length}`)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Regular)
        }
        .textAlign(TextAlign.Start)
        .margin({ bottom: $r('app.float.vp_8') })

        Text() {
          Span('答题用时：')
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_secondary'))
            .fontWeight(FontWeight.Regular)

          Span(this.practiceDurationFormat)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_primary'))
            .fontWeight(FontWeight.Regular)
        }
        .textAlign(TextAlign.Start)
        .margin({ bottom: $r('app.float.vp_35') })
      }
      .height($r('app.float.vp_192'))
      .width($r('app.float.vp_244'))
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 60 })

      Column({ space: 8 }) {
        Button('再测一下', { type: ButtonType.Normal, stateEffect: true })
          .fontColor($r('sys.color.multi_color_08'))
          .width('100%')
          .height($r('app.float.vp_40'))
          .borderRadius($r('app.float.vp_20'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            RouterModule.popToName('MainPage')
          })
        Button('查看结果', { type: ButtonType.Normal, stateEffect: true })
          .width('100%')
          .height($r('app.float.vp_40'))
          .borderRadius($r('app.float.vp_20'))
          .backgroundColor($r('sys.color.multi_color_08'))
          .onClick(() => {
            // 交卷评分页面
            let testReport: TestReportModel = new TestReportModel();
            testReport.ques = this.ques;
            testReport.quesType = this.quesType;
            RouterModule.replace({ url: RouterMap.TestReportPage, param: testReport });
          })
      }
      .padding({ left: $r('app.float.vp_24'), right: $r('app.float.vp_24') })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  TopComponentBuild() {
    Row() {
      // 测评结果
      TopBar({
        onClickBack: () => {
          RouterModule.pop()
        },
        title: $r('app.string.exam_result')
      })
    }
    .width('100%')
    .height($r('app.float.vp_56'))
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })
  }
}

@Builder
export function ExamResultPageBuilder() {
  ExamResultIndexPage()
}