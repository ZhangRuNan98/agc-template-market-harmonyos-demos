import { ArticleCard, TopicCard } from 'message_manager'
import { CardData } from 'message_manager'

@ComponentV2
export struct CardHome {
  @Param list:CardData[] = [];
  @Event itemClick:(item:CardData) => void = (item:CardData) => {};
  build() {
    List({space:12}) {
      ForEach(this.list, (item:CardData) => {
        ArticleCard({
          cardStyle: {
            maxLines: 2
          },
          cardData:item,
          itemClick:() => {
            this.itemClick(item)
          }
        })
      }, (item:CardData) => JSON.stringify(item))
      TopicCard({
        cardData:this.list[0],
        itemClick:() => {
          this.itemClick(this.list[0])
        }
      })
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}