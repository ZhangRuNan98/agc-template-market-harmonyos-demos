import { CartCardDto, Product, CartDto, MockCart } from '../commons/Model';
import { PersistenceV2 } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';

function handleBannerIcon(banner: string): ResourceStr {
  if (banner.startsWith('app://')) {
    const imgPath: string = banner.split('/spec/')[1];
    const imgUrl = imgPath.split('.')[0];
    const path: string = 'app.media.' + imgUrl;
    return $r(path);
  }
  return banner;
}

export class CartApi {
  // 获取购物车列表数据
  public static getCartList(): Promise<Product[]> {
    let mockCart: MockCart = PersistenceV2.connect(
      MockCart,
      'MockCart',
      () => new MockCart(),
    )!;
    let resList: Product[] = [];
    if (mockCart.data) {
      const resData = JSON.parse(mockCart.data) as CartDto;
      resList = resData.cards.map((item: CartCardDto) => {
        let itemData: Product = new Product();
        itemData.productId = item.productId;
        itemData.skuCode = item.skuCode;
        itemData.skuDesc = item.skuDesc;
        itemData.stock = 10;
        itemData.count = item.count;
        itemData.banner = handleBannerIcon(item.banner);
        itemData.title = item.title;
        itemData.serviceDesc = item.serviceDesc;
        itemData.price = item.price;
        itemData.dashPrice = item.dashPrice;
        itemData.isSelected = item.isSelected;
        return itemData;
      });
    }
    return Promise.resolve(resList);
  }

  // 删除购物车商品
  public static deleteCartProduct(data: string[]): Promise<string> {
    let mockCart: MockCart = PersistenceV2.connect(
      MockCart,
      'MockCart',
      () => new MockCart(),
    )!;
    const mockCartData = JSON.parse(mockCart.data) as CartDto;
    let remainList: CartCardDto[] = mockCartData.cards.filter(
      (item: CartCardDto) => data.includes(item.skuCode),
    );
    let cacheData = {
      version: util.generateRandomUUID(false),
      total: remainList.length,
      cards: remainList,
    } as CartDto;
    mockCart.data = JSON.stringify(cacheData);

    return Promise.resolve('0');
  }

  // 更新购物车商品的数量
  public static updateProductCount(
    data: Record<string, string | number>,
  ): Promise<string> {
    let mockCart: MockCart = PersistenceV2.connect(
      MockCart,
      'MockCart',
      () => new MockCart(),
    )!;
    const mockCartData = JSON.parse(mockCart.data) as CartDto;
    for (let i = 0; i < mockCartData.cards.length; i++) {
      if (mockCartData.cards[i].skuCode === data.skuCode) {
        mockCartData.cards[i].count = Number(data.count);
        break;
      }
    }
    mockCartData.version = util.generateRandomUUID(false);
    mockCart.data = JSON.stringify(mockCartData);
    return Promise.resolve('0');
  }
}
