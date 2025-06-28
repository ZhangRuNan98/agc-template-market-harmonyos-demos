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

import { examPrefer, PreferConstant, QuestionsRoterModel, TopicItemType, TopTabsBuilder } from 'commonlib'
import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { PracticeDataSource, PRACTICE_LIST_DATA, PracticeView } from '../model/PracticeMode';
import { CourseQuestions } from '../model/CourseQuestions';
import { RouterMap, RouterModule } from 'router_module'
import { Sample } from '../model/Course'
import { UserInfo } from 'login_info/src/main/ets/model/UserInfo';

@ComponentV2
export struct HomePage {
  private listData: PracticeView[] = PRACTICE_LIST_DATA;
  private dataSource: PracticeDataSource = new PracticeDataSource(this.listData);
  // 核心功能图标数组
  @Local functions: CourseCoreBar[] = [new CourseCoreBar($r('app.media.ic_practice_camera'), '搜题'),
    new CourseCoreBar($r('app.media.ic__practice_wrong_question')
      , '错题'), new CourseCoreBar($r('app.media.ic_practice_star'), '收藏'),
    new CourseCoreBar($r('app.media.ic_practice_notes'), '笔记')];
  // 核心功能图标数组
  @Local coursePractice: CourseQuestions[] =
    [new CourseQuestions('建筑工程经济', 120, 300), new CourseQuestions('建筑工程项目管理', 1024, 3411),
      new CourseQuestions('建筑工程项目管理', 1024, 3411)];
  // 在AppStorageV2中创建一个key为Sample的键值对（如果存在，则返回AppStorageV2中的数据），并且和prop关联
  @Local prop: Sample = AppStorageV2.connect(Sample, () => new Sample())!;
  @Local logoUser: UserInfo = AppStorageV2.connect(UserInfo, () => new UserInfo())!

  aboutToAppear(): void {
    // 获取存储在AppStorageV2中创建一个key为Sample的数据）
    this.prop = AppStorageV2.connect(Sample, 'Sample', () => new Sample())!;
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        TopTabsBuilder({ title: '练习', type: this.prop.title }).margin({ bottom: 12 })
        Scroll() {
          Column({ space: 10 }) {
            Swiper() {
              Image($r('app.media.ic_questionDetail_banner'))
                .interpolation(ImageInterpolation.High)
                .objectFit(ImageFit.Fill)
                .width('100%')
                .height($r('app.float.vp_184'))
              Image($r('app.media.ic_questionDetail_banner'))
                .interpolation(ImageInterpolation.High)
                .objectFit(ImageFit.Fill)
                .width('100%')
                .height($r('app.float.vp_184'))
            }
            .loop(true)
            .autoPlay(true)
            .interval(2000)

            Row({ space: 8 }) {
              ForEach(this.functions, (item: CourseCoreBar) => {
                CourseCoreBuilder(item)
              }, (item: CourseCoreBar, index: number) => item.description + index)
            }
            .height($r('app.float.vp_72'))
            .width('100%')
            .borderRadius($r('app.float.vp_16'))
            .backgroundColor($r('sys.color.background_primary'))
            .justifyContent(FlexAlign.Center)

            Column() {
              Text('练习模式')
                .fontSize($r('sys.float.Subtitle_L'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ bottom: $r('app.float.vp_12') })
              Grid() {
                LazyForEach(this.dataSource, (practiceItem: PracticeView) => {
                  GridItem() {
                    ReusableFlowItem({ item: practiceItem })
                  }.width('100%')
                  .height($r('app.float.vp_40'))
                  .backgroundColor(Color.White)
                  .onClick(() => {
                    if (!this.logoUser.isLogin) {
                      RouterModule.push({ url: RouterMap.QuickLoginPage, param: false })
                      return
                    }
                    if (practiceItem.name === '每日一练') {
                      RouterModule.push({ url: RouterMap.AnswerQuestions_Page });
                    } else if (practiceItem.name === '模拟考试') {
                      RouterModule.push({ url: RouterMap.MockTestPage, param: 1 });
                    } else if (practiceItem.name === '全真试卷') {
                      RouterModule.push({ url: RouterMap.MockTestPage, param: 2 });
                    } else {
                      // 错题练习
                      this.myWrongPracticeEvent()
                    }
                  })

                }, (practiceItem: PracticeView, index: number) => practiceItem.name + index)
              }
              .cachedCount(2)
              .padding($r('app.float.vp_12'))
              .backgroundColor($r('sys.color.background_primary'))
              .columnsTemplate('1fr 1fr')
              .columnsGap($r('app.float.vp_8'))
              .rowsGap($r('app.float.vp_8'))
              .height($r('app.float.vp_112'))
              .width('100%')
              .borderRadius($r('app.float.vp_16'))

              Text('科目练习')
                .fontSize($r('sys.float.Subtitle_L'))
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'))
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin($r('app.float.vp_12'))

              if (!this.logoUser.isLogin) {
                Column() {
                  Column() {
                    Image($r('app.media.ic_noLogin'))
                      .interpolation(ImageInterpolation.High)
                      .objectFit(ImageFit.Fill)
                      .width($r('app.float.vp_120'))
                      .height($r('app.float.vp_120'))
                      .clip(true)
                    Text('登录后享受更多服务')
                      .fontSize($r('sys.float.Body_M'))
                      .fontColor($r('sys.color.font_tertiary'))
                      .fontWeight(FontWeight.Regular)
                  }
                  .margin($r('app.float.vp_16'))
                }
                .width('100%')
                .justifyContent(FlexAlign.Center)
              } else {
                ForEach(this.coursePractice, (item: CourseQuestions) => {
                  Row() {
                    CoursePracticeBuilder(item)
                  }
                  .margin({ bottom: $r('app.float.vp_8') })
                }, (item: CourseQuestions, index: number) => item.courseName + index)
              }
            }
            .margin({ bottom: $r('app.float.vp_12') })
          }
          .justifyContent(FlexAlign.Center)
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
      }
    }
    .padding({ left: 16, right: 16 })
    .backgroundColor($r('sys.color.background_secondary'))
    .width('100%')
    .height('100%')
  }

  // 错题练习点击事件
  async myWrongPracticeEvent() {

    let arr: TopicItemType[] =
      await examPrefer.getPreferenceValue(PreferConstant.EXAMPREFER_CTJL, []) as TopicItemType[];
    if (arr.length <= 0) {
      promptAction.showToast({ message: '无错题数据' })
      return
    }
    arr.sort((a, b) => b.jlStamp - a.jlStamp)
    let roterModel: QuestionsRoterModel = new QuestionsRoterModel()
    roterModel.sourceType = '错题练习'
    roterModel.datalist = arr
    RouterModule.push({ url: RouterMap.AnswerQuestions_Page, param: roterModel })
  }
}

@ComponentV2
struct ReusableFlowItem {
  @Param item: PracticeView = new PracticeView($r('app.media.ic_home'), '顺序练习', '1、3256')

  build() {
    Row() {
      Column() {
        Text(this.item.name)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.Body_S'))
          .fontColor($r('sys.color.font_primary'))
        Text(this.item.describe)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize($r('sys.float.Caption_M'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_secondary'))
          .margin({ top: $r('app.float.vp_2') })
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      // 存在对应的jpg文件才会显示图片
      Image(this.item.imageUri)
        .interpolation(ImageInterpolation.High)
        .objectFit(ImageFit.Fill)
        .width('32vp')
        .height('32vp')
        .clip(true)
        .margin({ left: $r('app.float.vp_4'), right: $r('app.float.vp_4') })
    }
    .backgroundColor('#F1F3F5')
    .justifyContent(FlexAlign.SpaceBetween)
    .height($r('app.float.vp_40'))
    .width('100%')
    .padding({ left: $r('app.float.vp_12'), right: $r('app.float.vp_16') })
    .borderRadius($r('app.float.vp_12'))
  }
}

@Builder
export function HomePageBuilder() {
  HomePage()
}

// 核心功能组件builder
@Builder
export function CourseCoreBuilder(mainFunctionItem: CourseCoreBar) {
  Column() {
    Image(mainFunctionItem.showIcon)
      .height($r('app.float.vp_24'))
      .width($r('app.float.vp_24'))
      .margin({ bottom: $r('app.float.vp_2') })
    Text(mainFunctionItem.description).fontSize($r('sys.float.Caption_M'))
  }
  .width(64)
  .height(48)
  .justifyContent(FlexAlign.Center)
  .alignItems(HorizontalAlign.Center)
  .onClick(() => {
    let userInfo: UserInfo = AppStorageV2.connect(UserInfo, () => new UserInfo())!
    if (!userInfo.isLogin) {
      RouterModule.push({ url: RouterMap.QuickLoginPage, param: false })
      return
    }
    if (mainFunctionItem.description === '搜题') {
      RouterModule.push({ url: 'SearchQuestionPage' })
    } else if (mainFunctionItem.description === '笔记') {
      RouterModule.push({ url: RouterMap.MyNotesPage })
    } else if (mainFunctionItem.description === '错题') {
      RouterModule.push({ url: RouterMap.MyWrongPage })
    } else if (mainFunctionItem.description === '收藏') {
      RouterModule.push({ url: RouterMap.MyCollectionPage })
    }
  })
}

// 封装核心功能class
@ObservedV2
export class CourseCoreBar {
  @Trace showIcon: ResourceStr = ''
  @Trace description: string = ''

  constructor(showIcon: ResourceStr, description: string) {
    this.showIcon = showIcon
    this.description = description
  }
}

// 核心功能组件builder
@Builder
export function CoursePracticeBuilder(questions: CourseQuestions) {
  Column() {
    Row() {
      Row() {
        Text(questions.courseName)
          .fontSize($r('sys.float.Subtitle_S'))
          .fontWeight(FontWeight.Medium)
      }

      Row() {
        Text('章节练习')
          .fontSize($r('sys.float.Caption_L'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('sys.color.font_secondary'))
        Image($r('app.media.icon_right'))
          .width($r('app.float.vp_16'))
          .height($r('app.float.vp_16'))
          .margin({ left: $r('app.float.vp_5') })
      }.layoutWeight(1)
      .justifyContent(FlexAlign.End)
      .onClick(() => {
        // 跳转章节练习页面
        RouterModule.push({ url: RouterMap.ChapterPractice })
      })
    }
    .margin({ bottom: $r('app.float.vp_11') })

    Row() {
      Text('进度')
        .margin({ right: 8 })
        .fontSize($r('sys.float.Body_S'))
      Text() {
        Span(questions.completeNumber + '')
          .fontColor($r('sys.color.multi_color_09'))
        Span(' / ' + questions.questionsNumber + '')
      }
      .fontSize($r('sys.float.Body_S'))
    }
    .width('100%')
    .margin({ bottom: $r('app.float.vp_10') })

    Row() {
      Progress({ value: questions.completeNumber, total: questions.questionsNumber, type: ProgressType.Linear })
        .color($r('sys.color.multi_color_09'))
        .value(questions.completeNumber)
        .width($r('app.float.vp_266'))
    }
    .width('100%')
  }
  .borderRadius($r('app.float.vp_16'))
  .height($r('app.float.vp_82'))
  .width('100%')
  .padding({
    top: $r('app.float.vp_12'),
    bottom: $r('app.float.vp_10'),
    left: $r('app.float.vp_12'),
    right: $r('app.float.vp_12')
  })
  .backgroundColor($r('sys.color.background_primary'))
  .onClick(() => {
    RouterModule.push({ url: RouterMap.ChapterPractice })
  })
}