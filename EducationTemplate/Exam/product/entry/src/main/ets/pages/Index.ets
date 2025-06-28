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

import { RouterMap, RouterModule } from 'router_module';
import { CommonConstants } from '../common/CommonConstants';
import { TabStyle } from '../common/TabConstants';
import { TabListItem } from '../model/TabListItem'
import { MainVM } from '../viewmodels/MainVM';
import {
  SecondListPageBuilder,
  ThirdListPageBuilder,
  AnswerQuestionsPageBuilder,
  TestReportPageBuilder,
  AnswerQuestionsTwoPageBuilder,
  GoodCourseDetailPageBuilder,
  ExamResultPageBuilder,
  MyNotesPageBuilder,
  ViewNotePageBuilder,
  CourseIntroductionBuilder,
  MyWrongPageBuilder,
  MyCollectionPageBuilder,
  MockTestPageBuilder,
  CourseHomePageBuilder
} from 'topicpage'

import {
  HomePageBuilder,
  FeaturedCoursesBuilder,
  MaterialDownloadBuilder,
  ChapterPracticeBuilder,
  PrivacyPageBuilder,
  AuthenticationPageBuilder,
  TermsOfServicePageBuilder
} from 'homepage'
import { QuickLogin } from 'login_info';
import {
  SetupPageBuilder,
  FeedbackPageBuilder,
  EditPersonalCenterBuilder,
  OrderDetailPageBuilder,
  MyOrderPageBuilder,
  PrivacyStatementPageBuilder,
  PrivacyAgreementPageBuilder,
  OneDayPracticeRecordsPageBuilder,
  PracticeRecordsPageBuilder,
  PracticeDetailsPageBuilder,
  BrowsingHistoryPageBuilder,
  MessageCenterPageBuilder,
  FeedbackRecordPageBuilder,
  MinePageBuilder,
  AboutPageBuilder,
  CollectionPageBuilder,
  CoursePageBuilder,
  DialogPageBuilder
} from 'minepage';
import { TopicHomePageBuilder } from 'topicpage/src/main/ets/views/TopicHomePage';
import { promptAction } from '@kit.ArkUI';
import { SearchQuestionPage } from 'search_question';
import { SearchPage } from 'search';
import { AlertDialog } from '@kit.ArkUI';
import { examPrefer, PreferConstant, QuestionsRoterModel } from 'commonlib';

@Entry
@ComponentV2
struct Index {
  backPageDialogController: CustomDialogController | undefined = undefined;
  @Local isFirstType: boolean = false
  @Local searchValue: string = ''
  @Local searchSourceData: string[] =
    ['2023初级会计-初级会计实务题库', '初级会计实务', '初级会计实务真题', '初级会计实务真题', '2024初级会计经济法冲刺']
  present: string[] = ['DialogPage', 'QuickLoginPage']

  @Builder
  pageMap(name: string, param: ESObject) {
    if (this.present.includes(name)) {
      NavDestination() {
        if (name === 'QuickLoginPage') {
          QuickLogin({
            isBindContentCover: param,
            icon: $r('app.media.ic_pre_exam_01'),
            loginBtnBgColor: '#4B5CC4',
            appName: '备考',
            // 登录回调方法
            onLoginWithHuaweiID: () => {
              RouterModule.pop(false)
              promptAction.showToast({ message: '登陆成功', duration: 2000 });
            },
            // 备考隐私协议方法
            onPrivacyPolicy: () => {
              RouterModule.replace({ url: 'PrivacyPage' })
            },
            // 用户服务协议方法
            onServicePolicy: () => {
              RouterModule.replace({ url: 'TermsOfServicePage' })
            },
            // 华为账号用户认证协议
            onHYAccountRouter: () => {
              RouterModule.replace({ url: 'AuthenticationPage' })
            },
            // 模态消失回调
            shouldDismiss: () => {
              let paths: string[] = RouterModule.stack.getAllPathName()
              let isExit = paths.includes(name)
              if (isExit) {
                RouterModule.pop()
              }
            }
          })
        } else if (name === 'DialogPage') {
          DialogPageBuilder()
        }
      }
      .mode(NavDestinationMode.DIALOG)
      .hideTitleBar(true)
    } else {
      NavDestination() {
        if (name === 'TopicHomePage') {
          TopicHomePageBuilder()
        } else if (name === 'CourseHomePage') {
          CourseHomePageBuilder()
        } else if (name === 'SecondListPage') {
          SecondListPageBuilder()
        } else if (name === 'ThirdListPage') {
          ThirdListPageBuilder()
        } else if (name === 'homePage') {
          HomePageBuilder()
        } else if (name === 'TestReportPage') {
          TestReportPageBuilder()
        } else if (name === 'AnswerQuestionsPage') {
          AnswerQuestionsPageBuilder()
        } else if (name === 'EditPersonalCenter') {
          EditPersonalCenterBuilder()
        } else if (name === 'AnswerQuestionsTwoPage') {
          AnswerQuestionsTwoPageBuilder()
        } else if (name === 'MyNotesPage') {
          MyNotesPageBuilder()
        } else if (name === 'ViewNotePage') {
          ViewNotePageBuilder()
        } else if (name === 'PracticeRecordsPage') {
          PracticeRecordsPageBuilder()
        } else if (name === 'PracticeDetailsPage') {
          PracticeDetailsPageBuilder()
        } else if (name === 'OneDayPracticeRecordsPage') {
          OneDayPracticeRecordsPageBuilder()
        } else if (name === 'BrowsingHistoryPage') {
          BrowsingHistoryPageBuilder()
        } else if (name === 'ExamResultPage') {
          ExamResultPageBuilder()
        } else if (name === 'GoodCourseDetailPage') {
          GoodCourseDetailPageBuilder()
        } else if (name === RouterMap.CourseIntroductionPage) {
          CourseIntroductionBuilder()
        } else if (name === 'SetupPage') {
          SetupPageBuilder()
        } else if (name === 'CollectionPage') {
          CollectionPageBuilder()
        } else if (name === 'CoursePage') {
          CoursePageBuilder()
        } else if (name === 'FeedbackPage') {
          FeedbackPageBuilder()
        } else if (name === 'SearchQuestionPage') {
          SearchQuestionPage({
            search: (data) => {
              RouterModule.push({ url: 'SearchPage', param: data })
            },
            back: () => {
              this.searchValue = ''
              RouterModule.pop()
            },
          })
        } else if (name === 'FeaturedCourses') {
          FeaturedCoursesBuilder()
        } else if (name === 'MaterialDownload') {
          MaterialDownloadBuilder()
        } else if (name === 'SearchPage') {
          SearchPage({
            mockSearchValue: param ? param : '',
            searchSourceData: this.searchSourceData,
            initParam: () => {

            },
            clickSearchItem: (data) => {
              RouterModule.push({ url: 'GoodCourseDetailPage', param: data })
            },
            back: () => {
              RouterModule.pop()
            },
          })
        } else if (name === RouterMap.MyWrongPage) {
          MyWrongPageBuilder()
        } else if (name === RouterMap.MyCollectionPage) {
          MyCollectionPageBuilder()
        } else if (name === 'MockTestPage') {
          MockTestPageBuilder()
        } else if (name === 'MyOrderPage') {
          MyOrderPageBuilder()
        } else if (name === 'OrderDetailPage') {
          OrderDetailPageBuilder()
        } else if (name === 'PrivacyStatementPage') {
          PrivacyStatementPageBuilder()
        } else if (name === 'PrivacyAgreementPage') {
          PrivacyAgreementPageBuilder()
        } else if (name === 'MessageCenterPage') {
          MessageCenterPageBuilder()
        } else if (name === 'FeedbackRecordPage') {
          FeedbackRecordPageBuilder()
        } else if (name === RouterMap.ChapterPractice) {
          ChapterPracticeBuilder()
        } else if (name === 'MinePage') {
          MinePageBuilder()
        } else if (name === 'AboutPage') {
          AboutPageBuilder()
        } else if (name === 'MainPage') {
          MainPageBuilder()
        } else if (name === 'PrivacyPage') {
          PrivacyPageBuilder()
        } else if (name === 'AuthenticationPage') {
          AuthenticationPageBuilder()
        } else if (name === 'TermsOfServicePage') {
          TermsOfServicePageBuilder()
        }
      }
      .mode(NavDestinationMode.STANDARD)
      .hideTitleBar(true)
      .onBackPressed(() => {
        if (name === 'AnswerQuestionsTwoPage') {
          this.backPageDialogOpen(
            '您还有题目没有作答是否直接交卷结束考试！',
            '结束考试',
            '继续考试',
          )
          return true
        } else if (name === 'AnswerQuestionsPage') {
          let sourceRoterModel: QuestionsRoterModel | undefined =
            RouterModule.getNavParam({ url: RouterMap.AnswerQuestions_Page })
          if (sourceRoterModel !== undefined && (
            sourceRoterModel.sourceType === '我的错题' || sourceRoterModel.sourceType === '我的收藏'
          )) {
            return false
          }
          this.backPageDialogOpen(
            '您的练习计划还没有完成！确定需要退出本次练习训练吗？',
            '结束练习',
            '继续练习',
          )
          return true
        } else {
          return false
        }
      })
    }

  }

  backPageDialogOpen(content: string, leftButtonText: string, rightButtonText: string) {
    this.backPageDialogController = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: '温馨提示',
        content: content,
        secondaryButton: {
          value: rightButtonText,
          action: () => {
          }
        },
        primaryButton: {
          value: leftButtonText,
          fontColor: $r('sys.color.font_tertiary'),
          action: () => {
            RouterModule.pop()
          },
        },
      }),
    })
    this.backPageDialogController.open()
  }

  async aboutToAppear() {
    //读取状态值，如果为空设置为true
    this.isFirstType = await examPrefer.getPreferenceValue(PreferConstant.IS_FIRST, true) as boolean

    if (this.isFirstType) {
      //隐私政策
      RouterModule.push({ url: 'PrivacyAgreementPage' })
    } else {
      //首页
      RouterModule.replace({ url: 'MainPage' })
    }
  }

  build() {
    Column() {
      Navigation(RouterModule.stack) {
      }
      .hideNavBar(true)
      .hideToolBar(true)
      .hideTitleBar(true)
      .hideBackButton(true)
      .mode(NavigationMode.Stack)
      .navDestination(this.pageMap)
    }
  }
}


@Builder
export function MainPageBuilder() {
  MainPage()
}

@ComponentV2
struct MainPage {
  vm: MainVM = MainVM.instance;

  @Builder
  tabBarBuilder(item: TabListItem, index: number) {
    Column({ space: 2 }) {
      Image(this.vm.curIndex === index ? item.iconChecked : item.icon)
        .width(TabStyle.ICON_SIZE)
        .height(TabStyle.ICON_SIZE)
      Text(item.label)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Caption_M'))
        .fontColor(this.vm.curIndex === index ?
        $r('app.color.icon_bg_blue') : $r('sys.color.icon_secondary'))
    }
    .justifyContent(FlexAlign.Center)
    .width(CommonConstants.FULL_WIDTH)
    .height(TabStyle.BAR_HEIGHT)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: $$this.vm.curIndex, controller: this.vm.controller }) {
        ForEach(this.vm.tabList, (item: TabListItem, index: number) => {
          TabContent() {
            item.component.builder();
          }
          .tabBar(this.tabBarBuilder(item, index))
        }, (item: TabListItem, index) => JSON.stringify(item) + '_' + index)
      }
      .scrollable(false)
      .barMode(BarMode.Fixed)
      .barHeight(TabStyle.BAR_HEIGHT)
      .height(CommonConstants.FULL_HEIGHT)
      .animationDuration(TabStyle.ANIMATION_DURATION)
    }
    .backgroundColor($r('app.color.system_color_background_white'))
  }
}
