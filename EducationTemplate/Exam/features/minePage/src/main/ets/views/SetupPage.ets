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

import { SetupItem } from '../viewModel/setUpModel';
import { RouterMap, RouterModule } from 'router_module';
import { JSON } from '@kit.ArkTS';
import { AppStorageV2, promptAction, window } from '@kit.ArkUI';
import { fileIo, storageStatistics } from '@kit.CoreFileKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { examPrefer } from 'commonlib';
import { application, common, contextConstant } from '@kit.AbilityKit';
import { Header } from '../components/Header';
import { UserInfo } from 'login_info/src/main/ets/model/UserInfo';

@ComponentV2
struct SetupComponent {
  @Param @Require setupItem: SetupItem

  build() {
    Row() {
      Text(this.setupItem.msg)
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Regular)
      Row() {
        if (this.setupItem.cache) {
          Text(this.setupItem.cache)
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
            .margin({ right: 4 })
        }
        Image(this.setupItem.icon).height($r('app.float.vp_24')).width($r('app.float.vp_24'))
      }
    }
    .padding(12)
    .margin({ bottom: 12 })
    .borderRadius($r('app.float.vp_16'))
    .padding($r('app.float.vp_12'))
    .margin({ bottom: $r('app.float.vp_12') })
    .borderRadius($r('app.float.vp_16'))
    .width('100%')
    .backgroundColor($r('sys.color.background_primary'))
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }
}

@ComponentV2
export struct SetupPage {
  @Local bottomHeight: number = 0;
  @Local logoUser: UserInfo = AppStorageV2.connect(UserInfo, () => new UserInfo())!
  @Local setupList: SetupItem[] = [
    new SetupItem('个人信息', $r('app.media.iconRight'), '', 'EditPersonalCenter'),
    new SetupItem('意见反馈', $r('app.media.iconRight'), '', 'FeedbackPage'),
    new SetupItem('反馈记录', $r('app.media.iconRight'), '', 'FeedbackRecordPage'),
    new SetupItem('隐私协议', $r('app.media.iconRight'), '', 'PrivacyStatementPage'),
    new SetupItem('关于', $r('app.media.iconRight'), '', 'AboutPage'),
    new SetupItem('清除缓存', $r('app.media.iconRight'), '0.0M', ''),
  ]

  aboutToAppear(): void {
    this.getClearSize()
    window.getLastWindow(getContext(), (_err, data) => {
      const avoidAreaBottom = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.bottomHeight = avoidAreaBottom.bottomRect.height;
    })
  }

  build() {
    Column() {
      Header({ title: '设置' })
      Column() {
        Column() {
          ForEach(this.setupList, (item: SetupItem) => {
            SetupComponent({ setupItem: item })
              .onClick(() => {
                if (item.msg === '清除缓存') {
                  this.showAlert()
                } else if (item.msg === '个人信息') {
                  if (item.url && this.logoUser.isLogin) {
                    RouterModule.push({ url: item.url })
                  } else {
                    RouterModule.push({ url: RouterMap.QuickLoginPage, param: false })
                  }
                } else {
                  if (item.url) {
                    RouterModule.push({ url: item.url })
                  }
                }
              })
          }, (item: SetupItem) => JSON.stringify(item))
        }

        Button('退出登录')
          .borderRadius(20)
          .fontColor($r('sys.color.font_on_primary'))
          .backgroundColor('#4c5dc4')
          .fontSize($r('sys.float.Body_L'))
          .fontWeight(FontWeight.Medium)
          .width(312)
          .height(40)
          .padding({ top: $r('app.float.vp_12'), bottom: $r('app.float.vp_12') })
          .onClick(() => {
            if (this.logoUser.isLogin) {
              this.logoUser.isLogin = false
              promptAction.showToast({ message: '退出成功', duration: 2000 });
              RouterModule.pop()
            } else {
              promptAction.showToast({ message: '您还未登录', duration: 2000 });
            }
            emitter.emit('MinePageShown')
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height('100%')
      .padding({
        left: $r('app.float.vp_16'),
        right: $r('app.float.vp_16'),
        top: $r('app.float.vp_12'),
        bottom: this.bottomHeight
      })
      .backgroundColor($r('sys.color.comp_background_gray'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.background_primary'))
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }

  getClearSize() {
    storageStatistics.getCurrentBundleStats((error: BusinessError, bundleStats: storageStatistics.BundleStats) => {
      if (error) {
        console.error('getCurrentBundleStats failed with error:' + JSON.stringify(error));
      } else {
        console.info('getCurrentBundleStats successfully:' + JSON.stringify(bundleStats));
        this.setupList.forEach(async (eme) => {
          // 模拟缓存cache
          if (eme.msg === '清除缓存') {
            let isClean = examPrefer.isClean()
            if (isClean) {
              eme.cache = 0 + 'KB'
            } else {
              eme.cache = (bundleStats.dataSize / 1024).toFixed(2) + 'KB'
            }
          }
        })
      }
    });
  }

  showAlert() {
    this.getUIContext().showAlertDialog({
      message: '请确认是否清楚缓存',
      autoCancel: false,
      alignment: DialogAlignment.Center,
      showInSubWindow: true,
      isModal: true,
      buttonDirection: DialogButtonDirection.HORIZONTAL,
      buttons: [
        {
          value: '取消',
          action: () => {
          }
        },
        {
          value: '确定',
          action: () => {
            this.clean()
          }
        }
      ]
    })
  }

  async clean() {
    let paths: Array<string> = []
    let moduleContext: common.Context;
    let context = getContext()
    moduleContext = await application.createModuleContext(getContext(), 'entry');
    console.log('111moduleContext + el2: ' + moduleContext.cacheDir);
    console.log('111UIAbilityContext + el2: ' + context.cacheDir);
    paths.push(moduleContext.cacheDir)
    paths.push(context.cacheDir)
    moduleContext.area = contextConstant.AreaMode.EL1;
    console.log('111moduleContext + el1: ' + moduleContext.cacheDir);
    context.area = contextConstant.AreaMode.EL1;
    console.log('111UIAbilityContext + el1: ' + context.cacheDir)
    paths.push(moduleContext.cacheDir)
    paths.push(context.cacheDir)
    paths.push(moduleContext.preferencesDir)
    examPrefer.clear()
    for (let i = 0; i < paths.length; i++) {
      let path = paths[i]
      fileIo.listFile(path).then((filenames) => {
        for (let i = 0; i < filenames.length; i++) {
          let dirPath = path + '/' + filenames[i];
          console.log(dirPath);
          // 判断是否为文件夹
          let isDirectory: boolean = false;
          try {
            isDirectory = fileIo.statSync(dirPath).isDirectory();
          } catch (e) {
            console.error(JSON.stringify(e));
          }
          if (isDirectory) {
            fileIo.rmdirSync(dirPath);
          } else {
            fileIo.unlink(dirPath).then(() => {
              console.info('remove file succeed');
            }).catch((err: Error) => {
              console.error('remove file failed with error message: ' + err.message);
            });
          }
        }
      })
    }
    this.getClearSize()
  }
}

@Builder
export function SetupPageBuilder() {
  SetupPage()
}
