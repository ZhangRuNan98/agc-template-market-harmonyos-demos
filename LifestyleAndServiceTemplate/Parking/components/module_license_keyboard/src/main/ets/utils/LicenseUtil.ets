import { PersistenceV2 } from '@kit.ArkUI';

@ObservedV2
export class UsedLicenseModel {
  @Trace all: string[] = [];
}

@ObservedV2
export class UsedLicenseUtil {
  // 车牌信息
  private static _usedLicenses: UsedLicenseModel =
    PersistenceV2.connect(UsedLicenseModel, 'usedLicenses', () => new UsedLicenseModel())!;

  public static getLicenses(): UsedLicenseModel {
    return UsedLicenseUtil._usedLicenses;
  }

  public static findIndex(license: string) {
    return UsedLicenseUtil._usedLicenses.all.findIndex(item => item === license);
  }

  public static addLicense(license: string) {
    UsedLicenseUtil._usedLicenses.all.push(license);
  }

  public static deleteLicense(license: string) {
    const index = UsedLicenseUtil.findIndex(license);
    if (index === -1) {
      return;
    }
    UsedLicenseUtil._usedLicenses.all.splice(index, 1);
  }
}