import { IGoods, ITemplate } from './Type';
import { CommonUtils } from '../common/Utils';
import { goodsList } from 'module_base';

export class TemplateApi {
  static TEMPLATE_LIST: ITemplate[] =
    [
      {
        id: 1,
        name: '文件',
        sendAddress: {
          id: 1,
          name: '用户1',
          cellphone: '12345678901',
          province: '江苏省',
          city: '南京市',
          area: '雨花台区',
          detailAddress: 'xx街道xxx小区',
          isDefault: true
        },
        getAddress: {
          id: 2,
          name: '用户2',
          cellphone: '12345678901',
          province: '江苏省',
          city: '南京市',
          area: '雨花台区',
          detailAddress: 'xx街道xxx小区',
          isDefault: false
        },
        goods: {
          id: 1,
          name: '文件',
          weight: 1
        },
        shippingMethod: 1,
        paymentMethod: 1,
        weight: 1,
        time: '8:00 - 9:00'
      },
      {
        id: 2,
        name: '发票',
        sendAddress: {
          id: 1,
          name: '用户1',
          cellphone: '12345678901',
          province: '江苏省',
          city: '南京市',
          area: '雨花台区',
          detailAddress: 'xx街道xxx小区',
          isDefault: true
        },
        getAddress: {
          id: 2,
          name: '用户2',
          cellphone: '12345678901',
          province: '江苏省',
          city: '南京市',
          area: '雨花台区',
          detailAddress: 'xx街道xxx小区',
          isDefault: false
        },
        goods: {
          id: 3,
          name: '发票',
          weight: 1
        },
        shippingMethod: 1,
        paymentMethod: 1,
        weight: 1,
        time: '8:00 - 9:00'
      }
    ]
  static GOODS_LIST: IGoods[] = goodsList

  static getGoodsList(): Promise<IGoods[]> {
    return Promise.resolve(TemplateApi.GOODS_LIST);
  }

  static getTemplateList(): Promise<ITemplate[]> {
    return Promise.resolve(TemplateApi.TEMPLATE_LIST);
  }

  static getTemplate(id: number): Promise<ITemplate | undefined> {
    return Promise.resolve(TemplateApi.TEMPLATE_LIST.find(v => v.id === id));
  }

  static updateTemplate(data: ITemplate): Promise<boolean> {
    const target = TemplateApi.TEMPLATE_LIST.find(v => v.id === data.id);
    if (target) {
      CommonUtils.assign(target, data);
    }
    return Promise.resolve(true);
  }

  static deleteTemplate(id: number): Promise<boolean> {
    const targetIndex = TemplateApi.TEMPLATE_LIST.findIndex(v => v.id === id);
    if (targetIndex !== -1) {
      TemplateApi.TEMPLATE_LIST.splice(targetIndex, 1);
    }
    return Promise.resolve(true);
  }

  static addTemplate(data: ITemplate): Promise<boolean> {
    data.id = new Date().getTime();
    TemplateApi.TEMPLATE_LIST.splice(0, 0, data);
    return Promise.resolve(true);
  }
}
