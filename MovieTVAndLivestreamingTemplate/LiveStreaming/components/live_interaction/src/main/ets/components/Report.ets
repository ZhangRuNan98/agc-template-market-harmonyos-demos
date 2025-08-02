import { ReportData, ReportItem } from '../models/ReportData'
import { promptAction } from '@kit.ArkUI'

@ComponentV2
export struct Report {

  @Local reportData: ReportData = new ReportData()
  @Local inputLength: number = 0
  @Local isEditing: boolean = false
  @Local reasons: Array<string> = []
  @Event setDisappear: () => void
  @Event onReport: Function = () => {
  }
  reportText:string = ''
  build() {
    Column() {
      Row() {
        Image($r('app.media.handle'))
          .width(48)
          .height(4)
          .margin({ top: 8, left: 24 })
          .onClick(() => {
            this.setDisappear()
          })
      }
      .width(96)
      .height(16)

      Row() {
        Image($r('app.media.arrow_back'))
          .width(40)
          .height(40)
          .borderRadius(20)
          .onClick(() => {
            this.setDisappear()
          })
        Text('选择举报原因')
          .width(232)
          .height(27)
          .fontSize(20)
          .fontWeight(700)
          .margin({ left: 8, right: 8 })
        Image($r('app.media.close_btn'))
          .width(40)
          .height(40)
          .borderRadius(20)
          .onClick(() => {
            this.setDisappear()
          })
      }
      .width(328)
      .height(56)
      .margin({ bottom: 16 })

      Row() {
        Image($r('app.media.cover_1'))
          .width(176)
          .height(100)
      }
      .width(328)
      .height(100)
      .margin({ top: 16 })
      .justifyContent(FlexAlign.Center)
      .visibility(this.isEditing ? Visibility.Hidden : Visibility.Visible)

      Column({ space: 4 }) {
        Grid() {
          ForEach(
            this.reportData.topReasonList,
            (item: ReportItem, index: number) => {
              GridItem() {
                Text(item.reason)
                  .width(104)
                  .height(28)
                  .borderRadius(14)
                  .backgroundColor(!item.isSelected ? $r('app.color.focused_background') :
                    '#E84026')
                  .fontSize(14)
                  .fontWeight(500)
                  .fontColor(!item.isSelected ? '#E5000000' : '#fff')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 6, bottom: 6 })
                  .onClick(() => {
                    if (!item.isSelected) {
                      this.reasons.push(item.reason)
                    } else {
                      this.reasons.splice(this.reasons.indexOf(item.reason), 1)
                    }
                    this.reportData.topReasonList[index].isSelected = !this.reportData.topReasonList[index].isSelected
                  })
              }
            }
          )
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(8)
        .rowsGap(4)
        .width(328)
        .height(84)
        Stack({ alignContent: Alignment.BottomEnd }) {
          TextArea({ placeholder: '请输入详细举报内容，便于平台鉴定违规情况（非必选）' })
            .width(328)
            .height(72)
            .borderRadius(4)
            .padding({ top: 8, left: 8, right: 8 })
            .fontSize(14)
            .backgroundColor($r('app.color.focused_background'))
            .placeholderFont({ size: 12 })
            .placeholderColor($r('app.color.report_placeholder'))
            .maxLength(30)
            .onChange((value: string) => {
              this.inputLength = value.length
              this.reportText = value
            })
            .onEditChange((isEditing: boolean) => {
              this.isEditing = isEditing
            })

          Text(`${this.inputLength}/30`)
            .height(16)
            .fontSize(12)
            .fontWeight(400)
            .fontColor($r('app.color.report_placeholder'))
            .margin({ right: 8, bottom: 8 })
        }
        .width(328)
        .height(72)
        Grid() {
          ForEach(
            this.reportData.bottomReasonList,
            (item: ReportItem, index: number) => {
              GridItem() {
                Text(item.reason)
                  .width(104)
                  .height(28)
                  .borderRadius(14)
                  .backgroundColor(!item.isSelected ? $r('app.color.focused_background') :
                    '#E84026')
                  .fontSize(14)
                  .fontWeight(500)
                  .fontColor(!item.isSelected ? '#E5000000' : '#fff')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 6, bottom: 6 })
                  .onClick(() => {
                    if (!item.isSelected) {
                      this.reasons.push(item.reason)
                    } else {
                      this.reasons.splice(this.reasons.indexOf(item.reason), 1)
                    }
                    this.reportData.bottomReasonList[index].isSelected =
                      !this.reportData.bottomReasonList[index].isSelected
                  })
              }
            }
          )
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(8)
        .rowsGap(4)
        .width(328)
        .height(172)
      }
      .width(328)
      .height(352)
      .padding({ top: 16 })
      .offset({ y: this.isEditing ? -111 : 0})

      Blank()

      Row() {
        Button('提交')
          .width(328)
          .height(40)
          .borderRadius(20)
          .backgroundColor('#E84026')
          .fontColor('#fff')
          .fontSize(16)
          .fontWeight(500)
          .onClick(() => {
            if(this.reasons.length === 0 && this.reportText.length === 0){
              promptAction.showToast({ message: '请选择举报原因后提交' })
              return
            }
            promptAction.showToast({ message: '举报成功' })
            this.onReport(this.reasons)
            this.setDisappear()
          })
      }
      .width(328)
      .height(80)
      .backgroundColor('#F1F3F5')
      .margin({ bottom: 24 })
      .offset({ y: this.isEditing ? -278 : 0 })
      .justifyContent(FlexAlign.Center)
    }
    .width(328)
    .height(665)
  }
}