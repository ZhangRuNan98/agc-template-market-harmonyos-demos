import {
  AvoidArea,
  CommonConstants,
  LeftReturnComponent,
  TitleBar
} from '@ohos_agcit/common_component';
import { AppStorageV2, PersistenceV2, router } from '@kit.ArkUI';
import { AttachmentDatabase, DocumentType, FileManagement, FileDataSource, ResumeEntity } from 'file_management';

@Entry
@ComponentV2
export struct ResumeManagement {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local attachmentDatabase: AttachmentDatabase =
    PersistenceV2.connect(AttachmentDatabase, () => new AttachmentDatabase())!;
  @Local resumeData: FileDataSource<ResumeEntity> = new FileDataSource();

  aboutToAppear(): void {
    this.resumeData.clear();

    for (let i = 0; i < this.attachmentDatabase.attachmentList.length; i++) {
      this.resumeData.pushData(this.attachmentDatabase.attachmentList[i])
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          LeftReturnComponent()
            .onClick(() => {
              router.back();
            });
          TitleBar({ text: '简历管理' });
        }
        .height(56)
        .alignItems(VerticalAlign.Center)
        .width(CommonConstants.FULL_WIDTH)
        .alignItems(VerticalAlign.Center);
      }
      .padding({
        top: px2vp(this.avoidArea.topRectHeight),
        left: '6%',
        right: '6%'
      })
      .height(80)
      .width('100%')
      .justifyContent(FlexAlign.Start)


      FileManagement({
        resumeData: this.resumeData,
        buttonText: '上传简历',
        documentTypeArray:[DocumentType.PDF],
        limitCount: 3
      })
    }
    .backgroundColor($r('app.color.common_background'))
    .height(CommonConstants.FULL_HEIGHT)
    .width(CommonConstants.FULL_WIDTH)
    .padding({
      bottom: px2vp(this.avoidArea.bottomRectHeight)
    })
  }
}


