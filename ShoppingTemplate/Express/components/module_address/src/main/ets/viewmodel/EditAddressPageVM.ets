import { promptAction } from '@kit.ArkUI';
import { TypeAddressPage } from '../common/Constant';
import { CurrentAppStorage } from '../common/Global';
import { CommonUtils } from '../common/Utils';
import { AddrMgtApi } from '../http/Api';
import { IAddrInfo } from '../http/Type';
import { emitter } from '@kit.BasicServicesKit';

@ObservedV2
export class EditAddressPageVM {
  private static _instance: EditAddressPageVM;
  stack: NavPathStack = new NavPathStack();
  @Trace address: IAddrInfo = CurrentAppStorage.addressInfo
  @Trace type: TypeAddressPage = TypeAddressPage.NEW;
  @Trace name: string = ''
  @Trace cellphone: string = ''
  @Trace province: string = ''
  @Trace city: string = ''
  @Trace area: string = ''
  @Trace detailAddress: string = ''
  @Trace isDefault: boolean = false

  public static get instance() {
    if (!EditAddressPageVM._instance) {
      EditAddressPageVM._instance = new EditAddressPageVM();
    }
    return EditAddressPageVM._instance;
  }

  isNew() {
    return this.type === TypeAddressPage.NEW;
  }

  async savaData() {
    this.address.name = this.name
    this.address.cellphone = this.cellphone
    this.address.province = this.province
    this.address.city = this.city
    this.address.area = this.area
    this.address.detailAddress = this.detailAddress
    this.address.isDefault = this.isDefault
    if (this.isNew()) {
      if (this.address.isDefault) {
        AddrMgtApi.ADDRESS_LIST.forEach((item) => {
          item.isDefault = false
        })
      }
      this.address.id = new Date().getTime();
      AddrMgtApi.ADDRESS_LIST.splice(0, 0, this.address);
      promptAction.showToast({ message: '添加成功', alignment: Alignment.Center });
    } else {
      const target = AddrMgtApi.ADDRESS_LIST.find(v => v.id === this.address.id);
      if (target) {
        CommonUtils.assign(target, this.address);
      }
      if (this.address.isDefault) {
        AddrMgtApi.ADDRESS_LIST.forEach((item) => {
          if (item.id !== this.address.id) {
            item.isDefault = false
          }
        })
      }

      promptAction.showToast({ message: '修改成功', alignment: Alignment.Center });
    }
    let addressInfo: emitter.EventData = {
      data: this.address
    };
    emitter.emit('address', addressInfo);
    CurrentAppStorage.reset()
    return Promise.resolve();
  }

  onSubmit(): Promise<void> {
    const isValid = this.validInfo();
    if (!isValid) {
      return Promise.reject();
    }
    return this.savaData();
  }

  validInfo() {
    if (!this.name) {
      promptAction.showToast({ message: '请填写姓名' });
      return false;
    }
    if (!this.cellphone) {
      promptAction.showToast({ message: '请填写手机号' });
      return false;
    }
    if (!this.area) {
      promptAction.showToast({ message: '请选择地区' });
      return false;
    }
    if (!this.detailAddress) {
      promptAction.showToast({ message: '请填写详细地址' });
      return false;
    }
    return true;
  }
}