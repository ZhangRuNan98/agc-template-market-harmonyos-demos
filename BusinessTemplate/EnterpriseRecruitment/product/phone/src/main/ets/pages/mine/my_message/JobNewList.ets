import { ArticleCard } from 'message_manager'
import { CardData } from 'message_manager'

@ComponentV2
export struct JobNewList {
  @Param list:CardData[] = [];
  @Event itemClick:(item:CardData) => void = (item:CardData) => {};
  build() {
    List({space:12}) {
      ForEach(this.list, (item: CardData) => {
        ArticleCard({
          cardStyle: {
            timeColor:'#376BFC',
            timeFontSize: 16,
            maxLines: 6
          },
          cardData:item,
          itemClick:() => {
            this.itemClick(item)
          }
        })
      }, (item:string) => JSON.stringify(item))
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}