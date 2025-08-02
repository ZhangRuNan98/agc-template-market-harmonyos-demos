import { AccountUtil, AddressUtil, CommonAddressListModel, LicenseModel, LicenseUtil, WidgetUtil } from 'common';
import {
  AllCommonAddressesResp,
  AllLicenseInfoResp,
  BaseResponse,
  GetDefaultLicenseNumberResp,
  GetHomePageBannerResp,
  Https,
} from 'network';

@ObservedV2
export class HomePageVM {
  // banner
  @Trace banner: ResourceStr = '';
  // 车牌信息
  @Trace licenseInfo: LicenseModel = LicenseUtil.getLicenseInfo();
  // 常去地址
  @Trace commonAddresses: CommonAddressListModel = AddressUtil.getCommonAddresses();
  private static _instance: HomePageVM;

  public static get instance() {
    if (!HomePageVM._instance) {
      HomePageVM._instance = new HomePageVM();
    }
    return HomePageVM._instance;
  }

  @Monitor('licenseInfo.default')
  private _defaultChange() {
    WidgetUtil.updateWidgetsWhenChange(getContext(), true);
  }

  /** 删除车牌 **/
  public async deleteLicense(license: string) {
    const res = await Https.deleteOldLicenseNumber({ id: AccountUtil.getId(), old: license });
    if (res.code === 0) {
      LicenseUtil.deleteLicense(license);
    }
  }

  /** 查询车辆入场 **/
  public async queryParking(license: string) {
    const res = await Https.queryParking({ id: AccountUtil.getId(), license: license });
    if (res.code === 0) {
      return res.data.info?.pop();
    }
    return undefined;
  }

  /** 处理首页相关配置 **/
  public async handleHomePageConfig() {
    const promises = [
      Https.getHomePageBanner(),
      Https.getLicenseNumbers(),
      Https.getDefaultLicenseNumber(),
      Https.getCommonAddresses(),
    ];
    const results = await Promise.allSettled(promises);
    results.forEach((res, index) => {
      switch (index) {
        case 0:
          const res0 = res as PromiseSettledResult<BaseResponse<GetHomePageBannerResp>>;
          if (res0.status === 'fulfilled' && res0.value.code === 0) {
            this.banner = res0.value.data.banner;
          }
          break;
        case 1:
          const res1 = res as PromiseSettledResult<BaseResponse<AllLicenseInfoResp>>;
          if (res1.status === 'fulfilled' && res1.value.code === 0) {
            LicenseUtil.updateAllLicenses(res1.value.data.licenses);
          }
          break;
        case 2:
          const res2 = res as PromiseSettledResult<BaseResponse<GetDefaultLicenseNumberResp>>;
          if (res2.status === 'fulfilled' && res2.value.code === 0) {
            LicenseUtil.updateDefaultLicense(res2.value.data.default);
          }
          break;
        case 3:
          const res3 = res as PromiseSettledResult<BaseResponse<AllCommonAddressesResp>>;
          if (res3.status === 'fulfilled' && res3.value.code === 0) {
            AddressUtil.initAddress(res3.value.data.addresses);
          }
          break;
        default:
          break;
      }
    });
  }
}