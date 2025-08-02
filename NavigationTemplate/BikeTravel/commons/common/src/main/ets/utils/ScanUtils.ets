import { scanBarcode, scanCore } from '@kit.ScanKit';

export class ScanUtils {
  public static async getScanResult(obj: Object): Promise<string> {
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL, scanCore.ScanType.ONE_D_CODE], enableMultiMode: true, enableAlbum: true
    };

    let result: scanBarcode.ScanResult = await scanBarcode.startScanForResult(getContext(obj), options);
    return result.originalValue;
  }
}