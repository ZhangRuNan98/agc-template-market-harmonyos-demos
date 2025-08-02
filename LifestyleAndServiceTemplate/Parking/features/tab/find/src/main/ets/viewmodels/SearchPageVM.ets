import { AccountUtil, AddressModel, AddressUtil, AppStorageMap, IAddressInfo, RouterMap, RouterModule } from 'common';
import { Https } from 'network';
import { promptAction } from '@kit.ArkUI';
import { MapController } from 'module_parking_map';

@ObservedV2
export class SearchPageVM {
  // 当前文本
  @Trace text: string = '';
  // 来源页面(0~3:新增地址页;-1:地图页)
  @Trace type: number = 0;
  // 修改地址id
  @Trace oldSiteId: string = '';
  private static _instance: SearchPageVM;

  public static get instance() {
    if (!SearchPageVM._instance) {
      SearchPageVM._instance = new SearchPageVM();
    }
    return SearchPageVM._instance;
  }

  /** 初始化 **/
  public init() {
    this._resetSearchData();
    this._setTypeWithParams();
  }

  /** 点击搜索结果卡片操作 **/
  public async clickCardNextDo(address: IAddressInfo) {
    if (this.type === -1) {
      // 调整地图
      AppStorage.setOrCreate(AppStorageMap.SELECTED_ADDRESS, address.name);
      MapController.move(address.location);
    } else {
      if (this.type === 0 && this.oldSiteId === '') {
        // 新增自定义
        await this._addAddress(address);
      } else {
        // 更新地址
        await this._updateAddress(address);
      }
    }
    RouterModule.pop();
  }

  /** 新增地址 **/
  private async _addAddress(info: IAddressInfo) {
    const index = AddressUtil.getCommonAddresses().list.findIndex(item => item.siteId === info.siteId);
    if (index !== -1) {
      promptAction.showToast({ message: '已存在相同地址!' });
      return;
    }
    const res = await Https.addCommonAddresses({
      id: AccountUtil.getId(),
      siteId: info.siteId!,
      name: info.name,
      addr: info.addr,
      location: info.location,
      type: this.type,
    });

    if (res.code === 0) {
      AddressUtil.addAddress({
        siteId: info.siteId!,
        name: info.name,
        addr: info.addr,
        location: info.location,
        type: this.type,
      });
    }
  }

  /** 更新地址 **/
  private async _updateAddress(info: IAddressInfo) {
    const index = AddressUtil.getCommonAddresses().list.findIndex(item => item.siteId === info.siteId);
    if (index !== -1) {
      promptAction.showToast({ message: '已存在相同地址!' });
      return;
    }
    const res = await Https.updateCommonAddresses({
      id: AccountUtil.getId(),
      siteId: info.siteId!,
      oldSiteId: this.oldSiteId,
      name: info.name,
      addr: info.addr,
      location: info.location,
      type: this.type,
    });

    if (res.code === 0) {
      AddressUtil.updateAddress({
        siteId: info.siteId!,
        name: info.name,
        addr: info.addr,
        location: info.location,
        type: this.type,
      }, this.oldSiteId);
    }
  }

  /** 重置搜索页面参数 **/
  private _resetSearchData() {
    this.text = '';
    this.type = 0;
    this.oldSiteId = '';
  }

  /** 设置来源页面 **/
  private _setTypeWithParams() {
    const obj = RouterModule.getNavParam({ url: RouterMap.SEARCH_LIST }) as number | string | AddressModel;
    if (typeof obj === 'number') {
      this.type = obj;
    } else if (typeof obj === 'string') {
      this.type = -1;
      this.text = obj;
    } else {
      this.type = obj.type;
      this.oldSiteId = obj.siteId;
    }
  }
}
