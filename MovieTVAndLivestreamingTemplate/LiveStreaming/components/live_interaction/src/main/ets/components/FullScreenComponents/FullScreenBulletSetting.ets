import { BulletVM } from '../../viewModels/BulletVM';
import { AppStorageV2 } from '@kit.ArkUI';
import { BulletSettingItem } from '../../models/BulletSettingData';

@ComponentV2
export struct FullScreenBulletSetting {

  @Local rowsNum: number = 2;
  @Local notOpacity: number = 80;
  @Local danMuSpeed: string = '适中';
  @Local danMuSize: string = '适中';
  @Local bulletVM: BulletVM = AppStorageV2.connect(BulletVM, 'bulletVM', () => new BulletVM())!
  @Event setHide: () => void
  @Event closeAll: () => void

  aboutToAppear(): void {
    if (!this.bulletVM.storage.setting.has('setting')) {
      this.bulletVM.storage.setting.set('setting', new BulletSettingItem())
    }
    this.rowsNum = this.bulletVM.storage.setting.get('setting')?.rowsNum!
    this.notOpacity = this.bulletVM.storage.setting.get('setting')?.notOpacity!
    this.danMuSpeed = this.bulletVM.storage.setting.get('setting')?.danMuSpeed!
    this.danMuSize = this.bulletVM.storage.setting.get('setting')?.danMuSize!
  }

  saveSettings() {
    if (this.bulletVM.storage.setting.get('setting')?.rowsNum! === this.rowsNum) {
      this.bulletVM.bulletComments.forEach((item) => {
        item.opacity = this.notOpacity / 100
        item.size = this.danMuSize === '小' ? 12 : (this.danMuSize === '适中' ? 16 : 20)
        item.speed = this.danMuSpeed === '慢' ? 3 : (this.danMuSpeed === '适中' ? 6 : 12)
      })
    } else {
      this.bulletVM.bulletComments = []
      this.bulletVM.xTrans = []
    }
    let bulletSettingItem: BulletSettingItem = new BulletSettingItem()
    bulletSettingItem.rowsNum = this.rowsNum
    bulletSettingItem.notOpacity = this.notOpacity
    bulletSettingItem.danMuSpeed = this.danMuSpeed
    bulletSettingItem.danMuSize = this.danMuSize
    this.bulletVM.storage.setting.set('setting', bulletSettingItem)
  }


  build() {
    Row() {
      Column()
        .height('100%')
        .layoutWeight(1)
        .onClick(() => {
          this.closeAll()
        })
      Column() {
        Row() {
          Image($r('app.media.back'))
            .width(40)
            .height(40)
            .borderRadius(20)
            .margin({ left: 24 })
            .onClick(() => {
              this.setHide()
            })
          Text('弹幕设置')
            .height(27)
            .fontSize(20)
            .fontWeight(700)
            .fontColor('#fff')
            .margin({ left: 8 })
        }
        .width('100%')
        .height(56)
        .margin({ top: 22 })

        Column({ space: 16 }) {
          // 显示行数
          Row() {
            Text('显示行数')
              .width(56)
              .height(19)
              .fontSize(14)
              .fontColor('#fff')
              .fontWeight(FontWeight.Regular)
            Row() {
              ForEach(
                [1, 2, 3, 4, 5, 6],
                (item: number) => {
                  Text(`${item}`)
                    .width(43)
                    .height(36)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .borderRadius(18)
                    .textAlign(TextAlign.Center)
                    .fontColor(this.rowsNum === item ? '#E5FFFFFF' : '#99FFFFFF')
                    .backgroundColor(this.rowsNum === item ? '#666666' : 'transparent')
                    .shadow(this.rowsNum === item ? { color: '#3000', radius: 3 } : { color: 'transparent', radius: 0 })
                    .onClick(() => {
                      this.rowsNum = item
                      this.saveSettings()
                    })
                }
              )
            }
            .width(260)
            .height(36)
            .padding({ left: 1, right: 1 })
            .margin({ left: 12 })
            .borderRadius(18)
            .backgroundColor('#333333')
          }
          .width(328)
          .height(48)

          // 不透明度
          Row() {
            Text('不透明度')
              .width(56)
              .height(19)
              .fontSize(14)
              .fontColor('#fff')
              .fontWeight(FontWeight.Regular)
            Row() {
              ForEach(
                [20, 40, 60, 80, 100],
                (item: number) => {
                  Text(item === 0 ? '' : `${item}%`)
                    .width(52)
                    .height(36)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .borderRadius(18)
                    .textAlign(TextAlign.Center)
                    .fontColor(this.notOpacity === item ? '#E5FFFFFF' : '#99FFFFFF')
                    .backgroundColor(this.notOpacity === item ? '#666666' : 'transparent')
                    .shadow(this.notOpacity === item ? { color: '#3000', radius: 3 } : { color: 'transparent', radius: 0 })
                    .onClick(() => {
                      this.notOpacity = item
                      this.saveSettings()
                    })
                }
              )
            }
            .width(260)
            .height(36)
            .padding({ left: 1, right: 1 })
            .margin({ left: 12 })
            .borderRadius(18)
            .backgroundColor('#333333')
          }
          .width(328)
          .height(48)

          // 弹幕速度
          Row() {
            Text('弹幕速度')
              .width(56)
              .height(19)
              .fontSize(14)
              .fontColor('#fff')
              .fontWeight(FontWeight.Regular)
            Row() {
              ForEach(
                ['慢', '', '适中', '', '快'],
                (item: string) => {
                  Text(item)
                    .width(52)
                    .height(36)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .borderRadius(18)
                    .textAlign(TextAlign.Center)
                    .fontColor(this.danMuSpeed === item ? '#E5FFFFFF' : '#99FFFFFF')
                    .backgroundColor(this.danMuSpeed === item ? '#666666' : 'transparent')
                    .shadow(this.danMuSpeed === item ? { color: '#3000', radius: 3 } : { color: 'transparent', radius: 0 })
                    .onClick(() => {
                      if (item) {
                        this.danMuSpeed = item
                        this.saveSettings()
                      }
                    })
                }
              )
            }
            .width(260)
            .height(36)
            .padding({ left: 1, right: 1 })
            .margin({ left: 12 })
            .borderRadius(18)
            .backgroundColor('#333333')
          }
          .width(328)
          .height(48)

          // 弹幕字号
          Row() {
            Text('弹幕字号')
              .width(56)
              .height(19)
              .fontSize(14)
              .fontColor('#fff')
              .fontWeight(FontWeight.Regular)
            Row() {
              ForEach(
                ['小', '', '适中', '', '大'],
                (item: string) => {
                  Text(item)
                    .width(52)
                    .height(36)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .borderRadius(18)
                    .textAlign(TextAlign.Center)
                    .fontColor(this.danMuSize === item ? '#E5FFFFFF' : '#99FFFFFF')
                    .backgroundColor(this.danMuSize === item ? '#666666' : 'transparent')
                    .shadow(this.danMuSize === item ? { color: '#3000', radius: 3 } : { color: 'transparent', radius: 0 })
                    .onClick(() => {
                      if (item) {
                        this.danMuSize = item
                        this.saveSettings()
                      }
                    })
                }
              )
            }
            .width(260)
            .height(36)
            .padding({ left: 1, right: 1 })
            .margin({ left: 12 })
            .borderRadius(18)
            .backgroundColor('#333333')
          }
          .width(328)
          .height(48)
        }
      }
      .width(368)
      .height('100%')
      .backgroundColor($r('app.color.normal_font_color'))
      .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
    }
    .width('100%')
    .height('100%')
  }
}