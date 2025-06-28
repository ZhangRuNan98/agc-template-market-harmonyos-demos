import { ProductInfo } from '../commons/Types';

export const PRODUCT_ITEM: ProductInfo = {
  id: 'product_10001',
  banners: [
    $r('app.media.mock_spec_pink'),
    $r('app.media.mock_spec_white'),
    $r('app.media.mock_spec_stripe'),
  ],
  price: '188',
  dashPrice: '200',
  sales: '已售 3000+',
  title: '时尚轻商务系列针织打底纯羊毛内搭',
  tags: ['退货包邮费最高减￥5'],
  logistics: [
    {
      icon: $r('app.media.ic_truck'),
      content: '48小时内发货',
    },
    { icon: '', content: '免运费｜江苏无锡发货' },
  ],
  service: [{ icon: $r('app.media.ic_heart'), content: '运费险｜7天无理由' }],
  pictures: [
    $r('app.media.mock_spec_pink'),
    $r('app.media.mock_spec_white'),
    $r('app.media.mock_spec_stripe'),
    $r('app.media.mock_spec_green'),
  ],
  selectionInfo: {
    defaultBanner: $r('app.media.mock_spec_pink'),
    basicPrice: '188',
    priceRange: '188-200',
    priceRemark: '实付',
    totalPriceRemark: '共实付',
    services: ['运费险｜7天无理由', '48小时内发货'],
    skuItems: [
      {
        skuCode: 'sku_100001',
        specs: { '型号': 'uuid_160_80A', '外观颜色': 'uuid_pink' },
        stock: 10,
        price: 188,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100002',
        specs: { '型号': 'uuid_165_84A', '外观颜色': 'uuid_pink' },
        stock: 10,
        price: 188,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100003',
        specs: { '型号': 'uuid_170_88A', '外观颜色': 'uuid_pink' },
        stock: 10,
        price: 188,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100004',
        specs: { '型号': 'uuid_160_80A', '外观颜色': 'uuid_white' },
        stock: 10,
        price: 200,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100005',
        specs: { '型号': 'uuid_165_84A', '外观颜色': 'uuid_white' },
        stock: 0,
        price: 200,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100006',
        specs: { '型号': 'uuid_170_88A', '外观颜色': 'uuid_white' },
        stock: 0,
        price: 200,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100007',
        specs: { '型号': 'uuid_160_80A', '外观颜色': 'uuid_stripe' },
        stock: 0,
        price: 200,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100008',
        specs: { '型号': 'uuid_165_84A', '外观颜色': 'uuid_stripe' },
        stock: 0,
        price: 200,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100009',
        specs: { '型号': 'uuid_170_88A', '外观颜色': 'uuid_stripe' },
        stock: 0,
        price: 200,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100010',
        specs: { '型号': 'uuid_160_80A', '外观颜色': 'uuid_green' },
        stock: 0,
        price: 200,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100011',
        specs: { '型号': 'uuid_165_84A', '外观颜色': 'uuid_green' },
        stock: 0,
        price: 200,
        dashPrice: 200,
      },
      {
        skuCode: 'sku_100012',
        specs: { '型号': 'uuid_170_88A', '外观颜色': 'uuid_green' },
        stock: 0,
        price: 200,
        dashPrice: 200,
      },
    ],
    specOptions: [
      {
        key: '尺码',
        values: [
          { id: 'uuid_160_80A', text: '160/80A' },
          { id: 'uuid_165_84A', text: '165/84A' },
          { id: 'uuid_170_88A', text: '170/88A' },
        ],
      },
    ],
    specOptionWithImage: {
      key: '外观颜色',
      values: [
        {
          id: 'uuid_pink',
          text: '粉色',
          image: $r('app.media.mock_spec_pink'),
        },
        {
          id: 'uuid_white',
          text: '白色',
          image: $r('app.media.mock_spec_white'),
        },
        {
          id: 'uuid_stripe',
          text: '条纹',
          image: $r('app.media.mock_spec_stripe'),
        },
        {
          id: 'uuid_green',
          text: '绿色',
          image: $r('app.media.mock_spec_green'),
        },
      ],
    },
  },
};

export function getProductListMock(): ProductInfo[] {
  let arr: ProductInfo[] = [];
  for (let index = 0; index < 8; index++) {
    const element = JSON.parse(JSON.stringify(PRODUCT_ITEM)) as ProductInfo;
    element.id = `product_1000${index + 1}`;
    const bannerList: ResourceStr[] = [
      $r('app.media.mock_spec_pink'),
      $r('app.media.mock_spec_white'),
      $r('app.media.mock_spec_stripe'),
      $r('app.media.mock_spec_green'),
    ];
    const first = bannerList.splice(index % 4, 1);
    bannerList.unshift(...first);
    element.banners = bannerList;
    arr.push(element);
  }
  return arr;
}
