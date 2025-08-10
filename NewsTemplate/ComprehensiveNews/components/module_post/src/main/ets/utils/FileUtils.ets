import fs from '@ohos.file.fs';
import { util } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
const TAG = '[FileUtils]';

export class FileUtils {
  /**
   * uri对应文件复制到沙箱
   * @param uri
   * @param suffix
   * @returns
   */
  public static handleUri(uri: string, suffix: string = 'png'): string {
    if (!uri) {
      return '';
    }
    let tempFile: fs.File | null = null;
    try {
      tempFile = fs.openSync(uri, fs.OpenMode.READ_ONLY);
      let newPath: string = getContext().cacheDir + `/${util.generateRandomUUID(false)}.${suffix}`;
      fs.copyFileSync(tempFile.fd, newPath);
      hilog.info(DOMAIN, TAG, 'handleUri copyFileSync success, cache path: ' + newPath);
      return 'file://' + newPath;
    } finally {
      if (tempFile) {
        fs.closeSync(tempFile);
      }
    }
  }

  /**
   * pixelMap写入沙箱
   * @param pixelMap
   * @returns
   */
  public static async writePixelMap(pixelMap?: image.PixelMap): Promise<string> {
    if (!pixelMap) {
      return '';
    }
    let file: fs.File | null = null;
    try {
      const newPath: string = getContext().cacheDir + `/${util.generateRandomUUID(false)}.png`;
      file = fs.openSync(newPath, fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE);
      let imagePacker: image.ImagePacker = image.createImagePacker();
      let packOpts: image.PackingOption = { format: 'image/png', quality: 100 };
      await imagePacker.packToFile(pixelMap, file.fd, packOpts);
      return 'file://' + newPath;
    } finally {
      if (file) {
        fs.closeSync(file);
      }
    }
  }
}