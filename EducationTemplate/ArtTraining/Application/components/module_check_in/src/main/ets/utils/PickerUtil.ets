import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Context } from '@kit.AbilityKit';
import { picker } from '@kit.CoreFileKit';
import { promptAction, UIContext } from '@kit.ArkUI';
import { Logger } from 'module_ui_base';

const TAG: string = '[PickerUtil]';

export enum PickerResourceType {
  IMAGE,
  VIDEO,
  AUDIO,
}

export interface PickerPreviewItem {
  type: PickerResourceType;
  uri: ResourceStr;
  fileName?: string;
}

@ObservedV2
export class PickerUtil {
  @Trace public mediaPreviewList: PickerPreviewItem[] = [];
  @Trace public selectedNum: number = 0;
  public maxResourceNumber: number = 0;
  private _context: Context | undefined;

  constructor(uiContext: UIContext, maxResourceNumber: number = 9) {
    this._context = uiContext.getHostContext();
    this.maxResourceNumber = maxResourceNumber;
  }

  @Computed
  public get maxSelectNumber() {
    return this.maxResourceNumber - this.mediaPreviewList.length;
  }

  public async selectResource(type: PickerResourceType) {
    if(this.mediaPreviewList.length === this.maxResourceNumber){
      promptAction.showToast({message:'媒体资源选择已达上限~'})
      return;
    }
    switch (type) {
      case PickerResourceType.IMAGE:
        await this._getMediaFromAlbum(photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE);
        break;
      case PickerResourceType.VIDEO:
        await this._getMediaFromAlbum(photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE);
        break;
      case PickerResourceType.AUDIO:
        await this._getAudioFromFile();
        break;
      default:
        break;
    }
  }

  public clearResource() {
    this.mediaPreviewList = [];
    this.selectedNum = 0;
  }

  private async _getAudioFromFile() {
    if (!this._context) {
      Logger.error(TAG, 'get ability context failed.');
      return;
    }
    const audioSelectOptions = new picker.AudioSelectOptions();
    const audioViewPicker = new picker.AudioViewPicker(this._context);
    audioViewPicker.select(audioSelectOptions).then((audioSelectResult: string[]) => {
      const uri = audioSelectResult[0];
      const fileName = '音频文件';
      const item: PickerPreviewItem = {
        type: PickerResourceType.AUDIO,
        uri,
        fileName,
      };
      this.mediaPreviewList.push(item);
      Logger.info(TAG, 'audioViewPicker select successfully, audioSelectResult uri is:' + audioSelectResult[0]);
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `AudioViewPicker select failed, code is ${err.code}, message is ${err.message}`);
    });
  }

  public deleteItem(index: number) {
    this.mediaPreviewList.splice(index, 1);
  }

  private _getMediaFromAlbum(resourceType: photoAccessHelper.PhotoViewMIMETypes) {
    let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = resourceType;
    photoSelectOptions.maxSelectNumber = this.maxSelectNumber;
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    return photoPicker.select(photoSelectOptions).then((photoSelectResult) => {
      if (photoSelectResult !== null && photoSelectResult !== undefined) {
        photoSelectResult.photoUris.forEach((uri) => {
          const item: PickerPreviewItem = {
            uri,
            type: resourceType === photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE ? PickerResourceType.IMAGE :
            PickerResourceType.VIDEO,
          };
          this.mediaPreviewList.push(item);
        });
      }
      Logger.info(TAG, 'PhotoViewPicker.select successfully, PhotoSelectResult uri: ' +
      JSON.stringify(this.mediaPreviewList));
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `PhotoViewPicker select failed, code is ${err.code}, message is ${err.message}.`);
    });
  }
}
