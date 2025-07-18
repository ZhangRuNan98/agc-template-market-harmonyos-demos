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

import { AppStorageV2, window } from '@kit.ArkUI';
import { Header } from '../components/Header';
import { fileSelect } from 'feed_back';
import { UserInfo } from 'login_info';

@Builder
export function EditPersonalCenterBuilder() {
  EditPersonalCenter();
}

@ComponentV2
export struct EditPersonalCenter {
  @Local textName: string = '';
  @Param message: string = 'Hello World';
  @Param iconSheetHeight: number = 287;
  @Param nicknameSheetHeight: number = 744;
  @Local isShowIcon: boolean = false;
  @Local isShowNickname: boolean = false;
  @Local keyboardHeight: number = 0;
  @Local logoUser: UserInfo = AppStorageV2.connect(UserInfo, () => new UserInfo())!
  @Local imageUri: Array<string> = [];

  aboutToAppear(): void {
    window.getLastWindow(getContext(this)).then(currentWindow => {
      // 监视软键盘的弹出和收起
      currentWindow.on('avoidAreaChange', async data => {
        if (data.type !== window.AvoidAreaType.TYPE_KEYBOARD) {
          return;
        }
        this.keyboardHeight = px2vp(data.area.bottomRect.height);
      })
    })
  }

  @Builder
  myBuilder() {
    Column() {
      Row() {
        Image($r('app.media.close_btn')).size({ width: $r('app.float.vp_40'), height: $r('app.float.vp_40') })
          .onClick(() => {
            this.isShowIcon = false
          })
      }.size({ width: '100%', height: $r('app.float.vp_56') })
      .padding({ top: $r('app.float.vp_8'), bottom: $r('app.float.vp_8') })
      .justifyContent(FlexAlign.End)

      Column() {
        Row() {
          Image($r('app.media.Mask')).size({ width: $r('app.float.vp_40'), height: $r('app.float.vp_40') })
            .margin({ right: $r('app.float.vp_12') })
          Text('使用华为账号头像').height('app.float.vp_21').width('app.float.vp_128')
          Blank()
          Image($r('app.media.iconRight')).size({ width: $r('app.float.vp_24'), height: $r('app.float.vp_24') })

        }.size({ width: 304, height: $r('app.float.vp_40') })
        .padding({ left: $r('app.float.vp_12'), right: $r('app.float.vp_12') })
        .onClick(() => {
          this.logoUser.avatar = $r('app.media.Mask')
          this.isShowIcon = false
          this.showToast('头像修改成功');
        })

        Divider()
          .strokeWidth(0.5)
          .color($r('sys.color.comp_divider'))
          .margin({ top: $r('app.float.vp_13'), bottom: $r('app.float.vp_13') })
        Row() {
          Image($r('app.media.ic_public_image_bg'))
            .size({ width: $r('app.float.vp_40'), height: $r('app.float.vp_40') })
            .margin({ right: $r('app.float.vp_12') })
          Text('从图库选择').height('app.float.vp_21').width('app.float.vp_128')
          Blank()
          Image($r('app.media.iconRight')).size({ width: $r('app.float.vp_24'), height: $r('app.float.vp_24') })
        }.width(304).height('app.float.vp_40')
        .padding({ left: $r('app.float.vp_12'), right: $r('app.float.vp_12') })
        .onClick(async () => {
          let arr = await fileSelect(this.imageUri, 1)
          if (arr.length === 1) {
            this.logoUser.avatar = arr[arr.length-1]
            this.isShowIcon = false
            this.showToast('头像修改成功');
          }
        })

        Divider()
          .strokeWidth(0.5)
          .color($r('sys.color.comp_divider'))
          .margin({ top: $r('app.float.vp_13'), bottom: $r('app.float.vp_13') })
        Row() {
          Image($r('app.media.ic_public_camera_bg'))
            .size({ width: $r('app.float.vp_40'), height: $r('app.float.vp_40') })
            .margin({ right: $r('app.float.vp_12') })
          Text('拍照').size({ width: 128, height: 21 })
          Blank()
          Image($r('app.media.iconRight')).size({ width: $r('app.float.vp_24'), height: $r('app.float.vp_24') })
        }.size({ width: 304, height: $r('app.float.vp_40') })
        .padding({ left: $r('app.float.vp_12'), right: $r('app.float.vp_12') })
      }
      .borderRadius(16)
      .padding({ top: $r('app.float.vp_16'), left: $r('app.float.vp_12'), right: $r('app.float.vp_12') })
      .borderRadius(16)
      .backgroundColor($r('sys.color.background_primary'))
      .size({ width: 328, height: 202 })
    }.backgroundColor($r('sys.color.background_secondary'))
    .height('100%').width('100%')
    .padding({ top: $r('app.float.vp_8'), left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })
  }

  @Builder
  myBuilder2() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.close_btn')).size({ width: $r('app.float.vp_40'), height: $r('app.float.vp_40') })
            .onClick(() => {
              this.isShowNickname = false
            })
        }.size({ width: '100%', height: $r('app.float.vp_56') })
        .padding({ top: $r('app.float.vp_8'), bottom: $r('app.float.vp_8') })
        .justifyContent(FlexAlign.End)

        Row() {
          Text('设置昵称')
            .width($r('app.float.vp_80'))
            .height($r('app.float.vp_27'))
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_primary'))
            .margin({ top: $r('app.float.vp_16'), bottom: $r('app.float.vp_16') })
        }

        TextInput({ placeholder: '请输入不超过12位的新昵称' },)
          .backgroundColor($r('sys.color.comp_background_primary'))
          .type(InputType.Normal)
          .cancelButton({
            style: CancelButtonStyle.CONSTANT,
            icon: { size: $r('app.float.vp_18'), color: $r('sys.color.icon_primary') }
          })
          .onChange((value: string) => {
            this.textName = value;
          })
      }

      Button('确定')
        .borderRadius($r('app.float.vp_20'))
        .fontColor($r('sys.color.font_on_primary'))
        .backgroundColor('#4c5dc4')
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Medium)
        .width(304)
        .height($r('app.float.vp_40'))
        .padding({ top: $r('app.float.vp_12'), bottom: $r('app.float.vp_12') })
        .margin({ top: this.keyboardHeight ? 208 : 480 })
        .onClick(() => {
          if (this.textName.trim() !== '' && this.textName.length <= 12) {
            this.logoUser.name = this.textName
            this.showToast('昵称修改成功');
            this.isShowNickname = false
          } else if (this.textName.trim() === '') {
            this.showToast('您还未填写');
          } else {
            this.showToast('昵称禁止超过12位');
          }
        })
    }
    .height('100%')
    .padding({ top: $r('app.float.vp_8'), left: $r('app.float.vp_16'), right: $r('app.float.vp_16') })
  }

  showToast(message: string) {
    try {
      this.getUIContext().getPromptAction().showToast({
        message: message,
        duration: 2000
      });
    } catch (error) {
    }
  }

  build() {
    Column() {
      Header({ title: '个人信息' })
      Column() {
        Row() {
          Text('头像').size({ width: $r('app.float.vp_120'), height: 21 })
          Blank()
          Image(this.logoUser.isLogin ?
            this.logoUser.avatar !== '' ? this.logoUser.avatar : $r('app.media.path2x') :
          $r('app.media.person'))
            .size({ width: $r('app.float.vp_40'), height: $r('app.float.vp_40') })
            .borderRadius(40)
          Image($r('app.media.iconRight'))
            .size({ width: $r('app.float.vp_24'), height: $r('app.float.vp_24') })
        }
        .onClick(() => {
          this.isShowIcon = true;
        })
        .size({ width: 328, height: 64 })
        .margin({ top: '8vp' })
        .backgroundColor($r('sys.color.font_on_primary'))
        .padding($r('app.float.vp_12'))
        .borderRadius(16)
        .bindSheet($$this.isShowIcon, this.myBuilder(), {
          height: this.iconSheetHeight,
          backgroundColor: $r('sys.color.background_secondary'),
          showClose: false,
          maskColor: $r('sys.color.mask_fourth'),
          blurStyle: BlurStyle.Thick,
        })

        Column() {
          Row() {
            Text('昵称').height(21)
            Blank()
            Text(this.logoUser.name).height(19)
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Regular)
              .fontColor($r('sys.color.font_secondary'))
            Image($r('app.media.ic_public_brush')).size({ width: $r('app.float.vp_24'), height: $r('app.float.vp_24') })
              .margin({ left: 4 })
              .fillColor($r('sys.color.icon_primary'))

          }.size({ width: 328, height: 58 })
          .padding({ left: $r('app.float.vp_12'), right: $r('app.float.vp_12') })
          .onClick(() => {
            this.isShowNickname = true;
          })
          .bindSheet($$this.isShowNickname, this.myBuilder2(), {
            height: this.nicknameSheetHeight,
            backgroundColor: $r('sys.color.background_secondary'),
            showClose: false,
            maskColor: $r('sys.color.mask_fourth'),
          })

          Divider().strokeWidth(0.5).width(304).color($r('sys.color.comp_divider'))
          Row() {
            Text('电话').size({ width: $r('app.float.vp_120'), height: 21 })
            Blank()
            Text(this.logoUser.cellphone).size({ width: 80, height: 19 })
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Regular)
              .fontColor($r('sys.color.font_secondary'))
            Image($r('app.media.iconRight'))
              .size({ width: $r('app.float.vp_24'), height: $r('app.float.vp_24') })
              .margin({ left: 4 })
          }.size({ width: 328, height: 58 })
          .padding({ left: $r('app.float.vp_12'), right: $r('app.float.vp_12') })
        }
        .borderRadius(16)
        .margin({ top: $r('app.float.vp_12') })
        .borderRadius(16)
        .backgroundColor($r('sys.color.background_primary'))
      }.backgroundColor($r('sys.color.comp_background_gray')).width('100%').height('100%')
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .width('100%').height('100%')
  }
}


