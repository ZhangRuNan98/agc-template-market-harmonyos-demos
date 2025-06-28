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

import { Course } from '../model/Course'
import { RouterModule } from 'router_module'

// 精选课程卡片组件
@ComponentV2
export struct CourseComponent {
  @Param @Require course: Course

  // 整体布局采用Column包裹两个Row实现,将卡片整体拆成垂直布局,内容为水平布局
  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_avatar'))
          .height('24vp')
          .width('24vp')
          .margin({ right: '12vp' })
        Text('华为用户')
          .fontSize($r('sys.float.Body_M'))
          .fontWeight(FontWeight.Medium)
      }
      .padding({ left: '12vp' })
      .height('24vp')
      .width('100%')

      Column() {
        Row() {
          Text(this.course.courseName)
            .width('100%')
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .margin({ top: '12vp', bottom: '2vp' })

        Row() {
          Column() {
            Text(`￥${this.course.buyMoney}`)
              .fontSize($r('sys.float.Title_S'))
              .fontColor($r('sys.color.multi_color_08'))
              .fontWeight(FontWeight.Medium)
              .textAlign(TextAlign.Start)
              .width('100%')
            Text(`已有 ${this.course.buyNumbers}人 购买`)
              .fontWeight(FontWeight.Lighter)
              .fontColor($r('sys.color.black'))
              .fontSize($r('sys.float.Body_S'))
              .textAlign(TextAlign.Start)
              .width('100%')
          }
          .justifyContent(FlexAlign.Start)
          .width('50%')

          Column() {
            Row() {
              Button('查看详情')
                .fontColor($r('app.color.system_color_background_white'))
                .fontSize($r('sys.float.Body_M'))
                .backgroundColor('#4B5CC4')
                .fontWeight(FontWeight.Bold)
                .onClick(() => {
                  RouterModule.push({ url: 'GoodCourseDetailPage', param: this.course.courseName })
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
          }
          .width('50%')
        }
        .height('auto')
        .width('100%')
      }
      .padding({ left: '24vp', right: '24vp' })
      .width('100%')
    }
    .borderRadius(16)
    .padding({ top: '16vp', bottom: '16vp' })
    .backgroundColor($r('sys.color.background_primary'))
    .height('138vp')
    .width('100%')
  }
}