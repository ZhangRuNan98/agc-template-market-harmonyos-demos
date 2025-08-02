import { OrderCardDto } from 'lib_foundation';

export class MockDatabase {
  public static readonly PRODUCT_TABLE: ProductData[] = [
    {
      skuCode: 'sku_100001',
      productId: 'product_10001',
      skuDesc: '粉色;160/80A',
      stock: 10,
      banner: 'app://dev/media/spec/mock_spec_pink.jpg',
      title: '时尚轻商务系列针织打底纯羊毛内搭',
      serviceDesc: '运费险｜7天无理由',
      price: 188,
      dashPrice: 200,
    },
    {
      skuCode: 'sku_100002',
      productId: 'product_10001',
      skuDesc: '粉色;165/84A',
      stock: 10,
      banner: 'app://dev/media/spec/mock_spec_pink.jpg',
      title: '时尚轻商务系列针织打底纯羊毛内搭',
      serviceDesc: '运费险｜7天无理由',
      price: 188,
    },
    {
      skuCode: 'sku_100003',
      productId: 'product_10001',
      skuDesc: '粉色;170/88A',
      stock: 10,
      banner: 'app://dev/media/spec/mock_spec_pink.jpg',
      title: '时尚轻商务系列针织打底纯羊毛内搭',
      serviceDesc: '运费险｜7天无理由',
      price: 188,
    },
    {
      skuCode: 'sku_100004',
      productId: 'product_10001',
      skuDesc: '白色;160/80A',
      stock: 10,
      banner: 'app://dev/media/spec/mock_spec_white.jpg',
      title: '时尚轻商务系列针织打底纯羊毛内搭',
      serviceDesc: '运费险｜7天无理由',
      price: 200,
    },
  ];
  public static readonly ORDER_LIST: OrderCardDto[] = [];
}

interface ProductData {
  skuCode: string; // 主键
  productId: string;
  skuDesc: string;
  stock: number;
  banner: string;
  title: string;
  serviceDesc: string;
  price: number;
  dashPrice?: number;
}
