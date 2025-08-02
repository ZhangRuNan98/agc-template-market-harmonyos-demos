import { Constants } from '../commons/Constants';
import { ProductOperationType } from '../commons/Enum';
import { ProductInfo } from '../commons/Types';
import { ProductInfoCard } from '../components/ProductInfoCard';
import { ProductSwiper } from '../components/ProductSwiper';
import { ProductDetailApis } from '../https/Apis';
import { ProductSelector } from './ProductSelector';

@ComponentV2
export struct ProductDetail {
  @Param
  productId: string = '';
  @Param
  isLogin: boolean = false;
  @Param
  cartProdNum: number = 0;
  @Event
  clickCart: () => void;
  @Event
  handleAddCart: (skuCode: string, count: number) => void;
  @Event
  handlePayNow: (skuCode: string, count: number) => void;
  @Event
  handleNotLogin: () => void;
  @Event
  getProductInfo: (data: ProductInfo) => void;
  @Local
  isLoading: boolean = false;
  @Local
  productInfo: ProductInfo | undefined = undefined;
  @Local
  showSelector: boolean = false;
  @Local
  operationType: ProductOperationType = ProductOperationType.ADD_TO_CART;

  async aboutToAppear() {
    this.isLoading = true;
    this.productInfo = await ProductDetailApis.getProductDetail(this.productId);
    this.getProductInfo?.(this.productInfo);
    this.isLoading = false;
  }

  build() {
    Column() {
      if (this.isLoading) {
        LoadingProgress().width(32);
      } else {
        Scroll() {
          Column() {
            // 顶部轮播
            ProductSwiper({
              imgList: this.productInfo?.banners ?? [],
            });
            // 基本信息
            ProductInfoCard({
              productInfo: this.productInfo,
            }).margin({ bottom: 8 });
            // 详情介绍
            this.productDescBuilder();
          };
        }
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Off)
        .layoutWeight(1);

        Blank();
        // 底部操作栏
        this.bottomOperationBarBuilder();
      }
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Constants.BACKGROUND_COLOR_GREY)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM]);
  }

  @Builder
  productDescBuilder() {
    Column() {
      Text('商品详情').chapterTitleStyle();
      if (this.productInfo?.pictures) {
        ForEach(this.productInfo.pictures, (item: ResourceStr) => {
          Image(item)
            .width('100%')
            .objectFit(ImageFit.Contain)
            .draggable(false);
        }, (item: ResourceStr) => JSON.stringify(item));
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Constants.BACKGROUND_COLOR)
    .padding({ top: 12, bottom: 12 });
  }

  @Builder
  bottomOperationBarBuilder() {
    Row() {
      Badge({
        count: this.cartProdNum,
        style: {
          badgeSize: 16,
          badgeColor: Constants.THEME_COLOR,
          fontWeight: FontWeight.Medium,
          fontSize: 10,
        },
        position: BadgePosition.RightTop,
      }) {
        Column() {
          Image($r('app.media.ic_tab_inactive_cart'))
            .width(24)
            .height(24)
            .fillColor(Constants.FONT_COLOR_LEVEL2)
            .margin({ bottom: 2 });
          Text('购物车')
            .fontSize(8)
            .fontColor(Constants.FONT_COLOR_LEVEL2);
        }
        .padding(4);
      }
      .onClick(() => {
        this.clickCart?.();
      });

      Blank();
      Button('加入购物车')
        .bottomButtonStyle()
        .borderColor(Constants.BACKGROUND_COLOR_GREY_2)
        .fontColor(Constants.THEME_COLOR)
        .backgroundColor(Constants.BACKGROUND_COLOR_GREY_2)
        .borderRadius({
          topLeft: Constants.BORDER_RADIUS_CAPSULE,
          bottomLeft: Constants.BORDER_RADIUS_CAPSULE,
          topRight: 0,
          bottomRight: 0,
        })
        .onClick(() => {
          this.handleButtonClick(ProductOperationType.ADD_TO_CART);
        });

      Button('立即购买')
        .bottomButtonStyle()
        .borderColor(Constants.THEME_COLOR)
        .backgroundColor(Constants.THEME_COLOR)
        .fontColor(Constants.FONT_COLOR_1_INVERT)
        .borderRadius({
          topLeft: 0,
          bottomLeft: 0,
          topRight: Constants.BORDER_RADIUS_CAPSULE,
          bottomRight: Constants.BORDER_RADIUS_CAPSULE,
        })
        .onClick(() => {
          this.handleButtonClick(ProductOperationType.PAY_NOW);
        });
    }
    .width('100%')
    .padding({
      left: 16,
      right: 16,
      top: 16,
    })
    .backgroundColor(Constants.BACKGROUND_COLOR)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .bindSheet($$this.showSelector,
      this.productSelectorBuilder(),
      {
        title: { title: '商品规格选择' },
        detents: [SheetSize.LARGE],
        backgroundColor: Constants.BACKGROUND_COLOR,
        onWillDismiss: (action: DismissSheetAction) => {
          if (action.reason === DismissReason.PRESS_BACK || action.reason === DismissReason.CLOSE_BUTTON) {
            action.dismiss();
          }
        },
      });
  }

  @Builder
  productSelectorBuilder() {
    ProductSelector({
      operationType: this.operationType,
      productInfo: this.productInfo,
      handleCancel: () => {
        this.showSelector = false;
      },
      handleAddCart: (skuCode: string, count: number) => {
        this.handleAddCart?.(skuCode, count);
        this.showSelector = false;
      },
      handlePayNow: (skuCode: string, count: number) => {
        this.handlePayNow?.(skuCode, count);
        this.showSelector = false;
      },
    });
  }

  handleButtonClick(operationType: ProductOperationType) {
    if (!this.isLogin) {
      this.handleNotLogin?.();
      return;
    }
    this.operationType = operationType;
    this.showSelector = true;
  }
}

@Extend(Text)
function chapterTitleStyle() {
  .fontSize(14)
  .textIndent(16)
  .fontColor(Constants.FONT_COLOR_LEVEL1)
  .fontWeight(FontWeight.Medium)
  .margin({ bottom: 16 });
}

@Extend(Button)
function bottomButtonStyle() {
  .fontSize(14)
  .borderWidth(1)
  .height(40)
  .type(ButtonType.Normal);
}