import { Constants } from '../commons/Constants';
import { ProductResource } from '../commons/Types';
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { Logger } from '../utils/Logger';
import { PosterType } from '../commons/Enums';

export interface PosterDialogOptions {
  posterType: PosterType;
  posterResource: ProductResource;
  saveButtonOptions?: SaveButtonOptions;
}

@Builder
export function posterDialogBuilder(options: PosterDialogOptions) {
  PosterDialog({
    posterResource: options.posterResource,
    saveButtonOptions: options.saveButtonOptions,
    posterType: options.posterType,
  });
}

const TAG: string = '[PosterDialog]';

@ComponentV2
struct PosterDialog {
  @Param
  posterType: PosterType = PosterType.DEFAULT;
  @Param @Require
  posterResource: ProductResource;
  @Param
  saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.LINES,
    buttonType: ButtonType.Normal,
    text: SaveDescription.SAVE_IMAGE,
  };
  POSTER_ID = 'poster_id';

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        this.defaultPosterBuilder();
      }
      .width(270)
      .backgroundColor('#FFFFFF')
      .alignItems(HorizontalAlign.Center)
      .padding(Constants.SPACE_L)
      .borderRadius(Constants.BORDER_RADIUS_16)
      .id(this.POSTER_ID);

      Row() {
        SaveButton(this.saveButtonOptions)
          .fontSize(12)
          .onClick(async (_event, result: SaveButtonOnClickResult) => {
            if (result === SaveButtonOnClickResult.SUCCESS) {
              const uiContext = this.getUIContext();
              const context = uiContext.getHostContext();
              try {
                const pixmap: image.PixelMap = uiContext.getComponentSnapshot().getSync(this.POSTER_ID);
                const imagePackerApi: image.ImagePacker = image.createImagePacker();
                const packOpts: image.PackingOption = { format: 'image/jpeg', quality: 98 };
                const buffer = await imagePackerApi.packToData(pixmap, packOpts);
                const helper = photoAccessHelper.getPhotoAccessHelper(context);
                const photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE;
                const extension: string = 'jpg';
                const assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
                  photoAccessHelper.MediaAssetChangeRequest.createAssetRequest(context, photoType, extension);
                assetChangeRequest.addResource(photoAccessHelper.ResourceType.IMAGE_RESOURCE, buffer);
                await helper.applyChanges(assetChangeRequest);
                uiContext.getPromptAction().showToast({ message: '海报保存成功，快去分享吧~' });
                Logger.info(TAG, 'save poster successfully');
              } catch (err) {
                Logger.error(TAG, `save poster failed. error: ${err.code}, ${err.message}`);
              }
            } else {
              Logger.error(TAG, 'SaveButtonOnClickResult create asset failed');
            }
          });
      }
      .justifyContent(FlexAlign.End)
      .padding({
        right: 12,
        bottom: 12,
      });
    };
  }

  @Builder
  defaultPosterBuilder() {
    Column() {
      Column() {
        Image(this.posterResource.image)
          .width('100%');

        Row() {
          Text(this.posterResource.title)
            .fontColor(Constants.FONT_COLOR_LEVEL1)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
        }
        .width('100%')
        .padding(Constants.SPACE_M)
        .alignItems(VerticalAlign.Top);

      }
      .borderRadius(Constants.BORDER_RADIUS_16)
      .clip(true)
      .backgroundColor(Constants.BACKGROUND_COLOR_GREY)
      .margin({ bottom: Constants.SPACE_L });


      Row() {
        QRCode(this.posterResource.url)
          .width(64)
          .height(64)
          .margin({ right: Constants.SPACE_L });
        Text('扫描二维码查看商品')
          .fontSize(12)
          .fontColor(Constants.FONT_COLOR_LEVEL3);
      }
      .width('100%');

    }
    .margin({ bottom: Constants.SPACE_L });
  }
}
