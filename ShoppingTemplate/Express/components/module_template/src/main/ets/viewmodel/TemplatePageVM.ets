import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { OrderType, PaymentMethod, timeList } from '../common/Constant';
import { IAddrInfo, IGoods, ITemplate } from '../http/Type';
import { AddrList } from 'module_address';
import { TemplateApi } from '../http/Api';
import { RouterMap, getAddressData, sendAddressData } from 'module_base';

@ObservedV2
export class TemplatePageVM {
  @Trace addrList: AddrList = AppStorageV2.connect(AddrList, () => new AddrList())!;

  @Monitor('addrList.list')
  onChange(monitor: IMonitor) {
    const list = monitor.value()?.now as IAddrInfo[];
  }

  private static _instance: TemplatePageVM;
  stack: NavPathStack = new NavPathStack();
  @Trace public template: ITemplate | undefined
  @Trace public goodsList: IGoods[] = []
  @Trace public selectedGoodsId: number = 0
  @Trace public selectedShippingMethod: number = 1
  @Trace public selectedPaymentMethod: PaymentMethod = PaymentMethod.PAY_NOW
  @Trace public weight: number = 0
  @Trace public timePickerList: string[] = timeList
  @Trace public selectedTime: string = ''
  @Trace public selectedTimeIndex: number = 0
  @Trace public tempTime: string = ''
  @Trace public sendAddress: IAddrInfo = sendAddressData
  @Trace public getAddress: IAddrInfo = getAddressData
  @Trace public selectedAddress: OrderType = OrderType.SEND
  @Trace public isFresh: boolean = true

  public static get instance() {
    if (!TemplatePageVM._instance) {
      TemplatePageVM._instance = new TemplatePageVM();
    }
    return TemplatePageVM._instance;
  }

  public async init() {
    if (!this.isFresh) {
      return
    }
    const params: ITemplate[] =
      this.stack.getParamByName(RouterMap.TEMPLATE_PAGE) as ITemplate[];
    if (params.length && params[params.length - 1]) {
      const param = params[params.length - 1];
      if (param) {
        this.template = param
        this.sendAddress = param.sendAddress
        this.getAddress = param.getAddress
        this.selectedGoodsId = param.goods.id
        this.selectedShippingMethod = param.shippingMethod
        this.selectedPaymentMethod = param.paymentMethod
        this.weight = param.weight
        if (param.shippingMethod === 3) {
          this.selectedTime = param.time as string
          this.selectedTimeIndex = this.getSelectedIndex(this.tempTime, this.timePickerList)
        }
      } else {
        this.getDefaultPeople()
      }
    } else {
      this.getDefaultPeople()
    }
    this.getGoodsList()
  }

  public clear() {
    this.isFresh = true
    this.template = undefined
    this.selectedGoodsId = 0
    this.selectedShippingMethod = 2
    this.selectedPaymentMethod = PaymentMethod.PAY_NOW
    this.weight = 0
    this.sendAddress = sendAddressData as IAddrInfo
    this.getAddress = getAddressData as IAddrInfo
  }

  setStack(stack: NavPathStack) {
    this.stack = stack;
  }


  public getSelectedIndex(value: string, list: string[]) {
    const index = list.findIndex((item) => {
      return item === value
    })
    if (index !== -1) {
      return index
    }
    return 0
  }

  public async getDefaultPeople() {
    const people = this.addrList.list.find((item) => {
      return item.isDefault === true
    })
    if (people) {
      this.sendAddress = {
        id: people.id,
        name: people.name,
        cellphone: people.cellphone,
        province: people.province,
        city: people.city,
        area: people.area,
        detailAddress: people.detailAddress,
        isDefault: people.isDefault,
      }
    }
  }

  public async getGoodsList() {
    const res = await TemplateApi.getGoodsList()
    this.goodsList = res
  }

  public checkTemplate(): boolean {
    if (this.sendAddress.id === 0) {
      promptAction.showToast({ message: '请填写寄件人信息！', alignment: Alignment.Center, duration: 2000 });
      return false
    }
    if (this.getAddress.id === 0) {
      promptAction.showToast({ message: '请填写收件人信息！', alignment: Alignment.Center, duration: 2000 });
      return false
    }
    if (this.selectedGoodsId === 0) {
      promptAction.showToast({ message: '请选择物品！', alignment: Alignment.Center, duration: 2000 });
      return false
    }
    if (this.weight <= 0) {
      promptAction.showToast({ message: '请填写重量！', alignment: Alignment.Center, duration: 2000 });
      return false
    }
    return true
  }

  public async addTemplate() {
    if (!this.checkTemplate()) {
      return
    }
    const goods = this.goodsList.find((item) => {
      return this.selectedGoodsId === item.id
    })
    if (!goods) {
      return
    }
    const data: ITemplate = {
      id: 0,
      name: goods.name,
      sendAddress: this.sendAddress,
      getAddress: this.getAddress,
      goods: goods,
      shippingMethod: this.selectedShippingMethod,
      paymentMethod: this.selectedPaymentMethod,
      weight: this.weight,
      time: this.selectedTime
    }
    await TemplateApi.addTemplate(data)
    promptAction.showToast({ message: '添加成功！', alignment: Alignment.Center });
    this.clear()
    this.stack.pop()
    let template: emitter.EventData = {
      data: {
        isFresh: true
      }
    };
    emitter.emit('template', template);
  }

  public async updateTemplate() {
    const goods = this.goodsList.find((item) => {
      return this.selectedGoodsId === item.id
    })
    if (!goods) {
      return
    }
    if (!this.template) {
      return
    }
    const data: ITemplate = {
      id: this.template.id,
      name: goods.name,
      sendAddress: this.sendAddress,
      getAddress: this.getAddress,
      goods: goods,
      shippingMethod: this.selectedShippingMethod,
      paymentMethod: this.selectedPaymentMethod,
      weight: this.weight,
      time: this.selectedTime
    }
    await TemplateApi.updateTemplate(data)
    promptAction.showToast({ message: '修改成功！' });
    this.clear()
    this.stack.pop()
    let template: emitter.EventData = {
      data: {
        isFresh: true
      }
    };
    emitter.emit('template', template);
  }
}
