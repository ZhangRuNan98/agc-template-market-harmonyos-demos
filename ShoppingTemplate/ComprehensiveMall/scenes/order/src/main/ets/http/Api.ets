import { Address, OrderCardDto } from 'lib_foundation';
import { assign, formatFullDate } from '../utils';

export class OrderApi {
  public static readonly ORDER_LIST: OrderCardDto[] = [
    {
      type: 4,
      time: '2025-03-01 08:00:00',
      orderCode: 'mock_order_code_0',
      statusDesc: '已完成',
      remark: '',
      skuList: [
        {
          skuCode: 'sku_100001',
          skuDesc: '粉色;160/80A',
          count: 1,
          banner: 'app://dev/media/spec/mock_spec_pink.jpg',
          title: '时尚轻商务系列针织打底纯羊毛内搭',
          serviceDesc: '运费险｜7天无理由',
          price: 188,
          dashPrice:200,
        },
        {
          skuCode: 'sku_100003',
          skuDesc: '粉色;170/88A',
          count: 3,
          banner: 'app://dev/media/spec/mock_spec_white.jpg',
          title: '时尚轻商务系列针织打底纯羊毛内搭',
          serviceDesc: '运费险｜7天无理由',
          price: 600,
          dashPrice:600,
        },
      ],
      logisticsInfo: [
        {
          icon: 'app://dev/media/icon/ic_car.svg',
          status: '',
          desc: '您提交了订单，请等待系统确认',
          time: '2025-03-01 09:00:00',
        },
        {
          icon: 'app://dev/media/icon/ic_car.svg',
          status: '',
          desc: '您的订单已经安排车辆',
          time: '2025-03-01 09:05:00',
        },
        {
          icon: 'app://dev/media/icon/ic_car.svg',
          status: '运输中',
          desc: '预计XX月XX日送达',
          time: '2025-03-01 10:00:00',
        },
      ],
      totalPrice: 788,
      address: {
        name: '张三',
        cellphone: '12345678901',
        address: '江苏省南京市雨花台区铁心桥街道软件大道101号',
      },
      receivingMethod: '快递物流',
    },
    {
      type: 2,
      time: '2025-03-01 09:00:00',
      orderCode: 'mock_order_code_1',
      statusDesc: '待发货',
      remark: '',
      skuList: [
        {
          skuCode: 'sku_100001',
          skuDesc: '粉色;160/80A',
          count: 3,
          banner: 'app://dev/media/spec/mock_spec_pink.jpg',
          title: '时尚轻商务系列针织打底纯羊毛内搭',
          serviceDesc: '运费险｜7天无理由',
          price: 564,
          dashPrice:600,
        },
      ],
      logisticsInfo: [],
      totalPrice: 564,
      address: {
        name: '张三',
        cellphone: '12345678901',
        address: '江苏省南京市雨花台区铁心桥街道软件大道101号',
      },
      receivingMethod: '快递物流',
    },
    {
      type: 3,
      time: '2025-03-02 17:30:00',
      orderCode: 'mock_order_code_2',
      statusDesc: '待收货',
      remark: '',
      skuList: [
        {
          skuCode: 'sku_100001',
          skuDesc: '粉色;160/80A',
          count: 5,
          banner: 'app://dev/media/spec/mock_spec_pink.jpg',
          title: '时尚轻商务系列针织打底纯羊毛内搭',
          serviceDesc: '运费险｜7天无理由',
          price: 940,
          dashPrice:1000,
        },
      ],
      logisticsInfo: [],
      totalPrice: 940,
      address: {
        name: '张三',
        cellphone: '12345678901',
        address: '江苏省南京市雨花台区铁心桥街道软件大道101号',
      },
      receivingMethod: '快递物流',
    },
    {
      type: 5,
      time: '2025-03-15 12:00:00',
      orderCode: 'mock_order_code_3',
      statusDesc: '已取消',
      remark: '',
      skuList: [
        {
          skuCode: 'sku_100001',
          skuDesc: '粉色;160/80A',
          count: 1,
          banner: 'app://dev/media/spec/mock_spec_pink.jpg',
          title: '时尚轻商务系列针织打底纯羊毛内搭',
          serviceDesc: '运费险｜7天无理由',
          price: 188,
          dashPrice:200,
        },
      ],
      logisticsInfo: [],
      totalPrice: 188,
      address: {
        name: '张三',
        cellphone: '12345678901',
        address: '江苏省南京市雨花台区铁心桥街道软件大道101号',
      },
      receivingMethod: '快递物流',
    },
    {
      type: 6,
      time: '2025-04-01 05:27:19',
      orderCode: 'mock_order_code_4',
      statusDesc: '已退款',
      remark: '',
      skuList: [
        {
          skuCode: 'sku_100001',
          skuDesc: '粉色;160/80A',
          count: 2,
          banner: 'app://dev/media/spec/mock_spec_pink.jpg',
          title: '时尚轻商务系列针织打底纯羊毛内搭',
          serviceDesc: '运费险｜7天无理由',
          price: 376,
          dashPrice:400,
        },
      ],
      logisticsInfo: [],
      totalPrice: 376,
      address: {
        name: '张三',
        cellphone: '12345678901',
        address: '江苏省南京市雨花台区铁心桥街道软件大道101号',
      },
      refundTime: '2025-06-01 05:27:19',
      receivingMethod: '快递物流',
    },
    {
      type: 1,
      time: '2025-06-01 05:27:19',
      orderCode: 'mock_order_code_5',
      statusDesc: '待付款',
      remark: '',
      skuList: [
        {
          skuCode: 'sku_100001',
          skuDesc: '粉色;160/80A',
          count: 1,
          banner: 'app://dev/media/spec/mock_spec_pink.jpg',
          title: '时尚轻商务系列针织打底纯羊毛内搭',
          serviceDesc: '运费险｜7天无理由',
          price: 188,
          dashPrice:200,
        },
      ],
      logisticsInfo: [],
      totalPrice: 188,
      remainingTime: '00:30:00',
      address: {
        name: '张三',
        cellphone: '12345678901',
        address: '江苏省南京市雨花台区铁心桥街道软件大道101号',
      },
      receivingMethod: '快递物流',
    },
  ];

  static getOrderList(type: number): Promise<OrderCardDto[]> {
    if (type === 0) {
      return Promise.resolve(OrderApi.ORDER_LIST);
    }
    return Promise.resolve(
      OrderApi.ORDER_LIST.filter((item) => {
        return item.type === type;
      }),
    );
  }

  static getOrderListByName(value: string): Promise<OrderCardDto[]> {
    return Promise.resolve(
      OrderApi.ORDER_LIST.filter((item) => {
        const index = item.skuList.findIndex((child) => {
          return child.title.includes(value);
        });
        if (index !== -1) {
          return true;
        }
        return false;
      }),
    );
  }

  static getOrderInfo(orderCode: string): Promise<OrderCardDto | undefined> {
    return Promise.resolve(
      OrderApi.ORDER_LIST.find((v) => v.orderCode === orderCode),
    );
  }

  static updateOrder(data: OrderCardDto): Promise<boolean> {
    const target = OrderApi.ORDER_LIST.find(
      (v) => v.orderCode === data.orderCode,
    );
    if (target) {
      assign(target, data);
    }
    return Promise.resolve(true);
  }

  static agreeOrderByCode(orderCode: string): Promise<boolean> {
    const index = OrderApi.ORDER_LIST.findIndex(
      (v) => v.orderCode === orderCode,
    );
    if (index !== -1) {
      OrderApi.ORDER_LIST[index].type = 4;
      OrderApi.ORDER_LIST[index].statusDesc = '已完成';
    }
    return Promise.resolve(true);
  }

  static payOrderByCode(orderCode: string): Promise<boolean> {
    const index = OrderApi.ORDER_LIST.findIndex(
      (v) => v.orderCode === orderCode,
    );
    if (index !== -1) {
      OrderApi.ORDER_LIST[index].type = 2;
      OrderApi.ORDER_LIST[index].statusDesc = '待发货';
      OrderApi.ORDER_LIST[index].remainingTime = '';
    }
    return Promise.resolve(true);
  }

  static refundOrderByCode(orderCode: string): Promise<boolean> {
    const index = OrderApi.ORDER_LIST.findIndex(
      (v) => v.orderCode === orderCode,
    );
    if (index !== -1) {
      OrderApi.ORDER_LIST[index].type = 6;
      OrderApi.ORDER_LIST[index].statusDesc = '已退款';
      OrderApi.ORDER_LIST[index].refundTime = formatFullDate(new Date());
    }
    return Promise.resolve(true);
  }

  static cancelOrderByCode(orderCode: string): Promise<boolean> {
    const index = OrderApi.ORDER_LIST.findIndex(
      (v) => v.orderCode === orderCode,
    );
    if (index !== -1) {
      OrderApi.ORDER_LIST[index].type = 5;
      OrderApi.ORDER_LIST[index].statusDesc = '已取消';
      OrderApi.ORDER_LIST[index].remainingTime = '';
    }
    return Promise.resolve(true);
  }

  static updateOrderAddressByCode(
    orderCode: string,
    address: Address,
  ): Promise<boolean> {
    const index = OrderApi.ORDER_LIST.findIndex(
      (v) => v.orderCode === orderCode,
    );
    if (index !== -1) {
      OrderApi.ORDER_LIST[index].address!.name = address.name;
      OrderApi.ORDER_LIST[index].address!.cellphone = address.cellphone;
      OrderApi.ORDER_LIST[index].address!.address = address.address;
    }
    return Promise.resolve(true);
  }

  static deleteOrder(orderCode: string): Promise<boolean> {
    const targetIndex = OrderApi.ORDER_LIST.findIndex(
      (v) => v.orderCode === orderCode,
    );
    if (targetIndex !== -1) {
      OrderApi.ORDER_LIST.splice(targetIndex, 1);
    }
    return Promise.resolve(true);
  }
}
