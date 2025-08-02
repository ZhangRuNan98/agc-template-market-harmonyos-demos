import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { RouterPageEnum, UserInfoStorage } from 'common';
import { CardID } from '../components/CardID';
import { camera, cameraPicker as picker } from '@kit.CameraKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';

@ComponentV2
export struct RealNameAuth {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @Local userInfoStorage: UserInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!
  @Local cardID: CardID = AppStorageV2.connect(CardID, () => new CardID())!;

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column({ space: 12 }) {
            Text('请拍照或上传身份证正反面')
              .fontWeight('bold')
              .fontSize(16)

            Text('正面为国徽面，反面为头像面')
              .fontSize(12)
              .fontColor($r('app.color.font_orange'))

            Row({ space: 12 }) {
              Text('头像面')
                .width(48)
                .fontWeight('bold')
                .fontSize(16)

              Image(this.cardID.frontImage != null ? this.cardID.frontImage : $r('app.media.front_ID_card'))
                .height(136)
                .width(220)
                .onClick(() => {
                  this.pageInfos.pushPathByName(RouterPageEnum.FRONT_ID_ROUTER, null,
                  (res: PopInfo) => {
                    this.cardID.frontImage = res.result.toString()
                  })
                })
            }
            .padding({
              top: 12,
              bottom: 12,
              left: 12,
              right: 12
            })
            .width('100%')
            .borderRadius(16)
            .backgroundColor($r('app.color.common_background'))
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Top)

            Row() {
              Text('国徽面')
                .width(48)
                .fontWeight('bold')
                .fontSize(16)

              Image(this.cardID.backImage != null ? this.cardID.backImage : $r('app.media.back_ID_card'))
                .height(136)
                .width(220)
                .onClick(() => {
                  this.pageInfos.pushPathByName(RouterPageEnum.BACK_ID_ROUTER, null,
                    (res: PopInfo) => {
                      this.cardID.backImage = res.result.toString()
                    }
                  )
                })
            }
            .padding({
              top: 12,
              bottom: 12,
              left: 12,
              right: 12
            })
            .width('100%')
            .borderRadius(16)
            .backgroundColor($r('app.color.common_background'))
            .alignItems(VerticalAlign.Top)
            .justifyContent(FlexAlign.SpaceBetween)

            Row() {
              Text('手持\n身份证'+'\n'+'照片')
                .width(48)
                .fontWeight('bold')
                .fontSize(16)
                .layoutWeight(1)

              Image(this.cardID.picture != null ? this.cardID.picture : $r('app.media.handheld_ID_card'))
                .height(136)
                .width(220)
                .onClick(async () => {
                  let pathDir = getContext().filesDir;
                  let fileName = `${new Date().getTime()}`
                  let filePath = pathDir + `/${fileName}.tmp`
                  fileIo.createRandomAccessFileSync(filePath, fileIo.OpenMode.CREATE);

                  let uri = fileUri.getUriFromPath(filePath);
                  let pickerProfile: picker.PickerProfile = {
                    cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
                    saveUri: uri
                  };
                  let result: picker.PickerResult =
                    await picker.pick(getContext(), [picker.PickerMediaType.PHOTO],
                      pickerProfile);
                  console.info(`picker resultCode: ${result.resultCode},resultUri: ${result.resultUri},mediaType: ${result.mediaType}`);
                  if (result.resultCode === 0) {
                    this.cardID.picture = result.resultUri;
                  }
                })
            }
            .width('100%')
            .padding({
              top: 12,
              bottom: 12,
              left: 12,
              right: 12
            })
            .borderRadius(16)
            .backgroundColor($r('app.color.common_background'))
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Top)
          }
          .backgroundColor($r('app.color.pure_white'))
          .alignItems(HorizontalAlign.Start)
          .borderRadius(16)
          .padding({
            top: 12,
            right: 12,
            left: 12,
            bottom: 16
          })
        }
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1)
        .align(Alignment.Top)

        Button('确认')
          .width('100%')
          .padding({ top: 10, bottom: 10 })
          .fontSize(16)
          .fontWeight('medium')
          .backgroundColor($r('sys.color.multi_color_09'))
          .onClick(() => {
            Object.values(this.cardID).every((value?: string) => {
              if (value !== undefined) {
                this.userInfoStorage.realName = true
              } else {
                this.userInfoStorage.realName = false
              }
            })
            this.pageInfos.pop()
          })
      }
      .padding({ right: 16, left: 16, top: 8 })

    }
    .backgroundColor($r('app.color.common_background'))
    .title('实名认证')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}