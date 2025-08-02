import { Product } from '../commons/Model';
import { CartCard } from './CartCard';

@ComponentV2
export struct CartListView {
  // 数据源
  @Param listData: Product[] = [];
  // 是否编辑态
  @Param isEdit: boolean = false;
  // 购物车商品数量变化的事件回调
  @Event onChangeCount: (skuCode: string) => void = (skuCode: string) => {};
  // 删除操作
  @Event onDelete: (skuCode: string) => void = (skuCode: string) => {};
  // 商品卡片事件回调
  @Event onCardClick: (id: string) => void = (id: string) => {};

  build() {
    List({space: 12}) {
      ForEach(this.listData, (card: Product, index: number) => {
        ListItem() {
          CartCard({
            data: card,
            isEdit: this.isEdit,
            onChangeCount: (skuCode: string) => {
              this.onChangeCount && this.onChangeCount(skuCode);
            },
            onCardClick: () => {
              this.onCardClick && this.onCardClick(card.productId);
            },
            onDelete: (skuCode: string) => {
              this.onDelete && this.onDelete(skuCode);
            },
          })
        }
        .transition({ type: TransitionType.Delete, opacity: 0 })
        .swipeAction(this.isEdit ? {} : {
          end: this.CardItemEnd(card, index),
          edgeEffect: SwipeEdgeEffect.None,
        })
      }, (item: Product, index: number) => index + '__' + JSON.stringify(item))
    }
    .width('100%')
    .height('auto')
    .edgeEffect(EdgeEffect.None)
    .margin({ top: 10 })
    .padding({left: 12, right: 12})
    .clip(true)
  }

  @Builder
  CardItemEnd(card: Product, index: number) {
    Row() {
      Button({ type: ButtonType.Normal, stateEffect: true }) {
        Text('删除')
          .fontSize(14)
          .fontColor(Color.White)
      }
      .height('100%')
      .padding({left:14, right: 14})
      .backgroundColor('#E84026')
      .onClick(() => {
        this.onDelete && this.onDelete(card.skuCode);
      })
    }
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}