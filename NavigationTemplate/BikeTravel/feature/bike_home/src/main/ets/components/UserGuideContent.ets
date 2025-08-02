import { TabsContent } from '../model/GuidePageModel'
import { UserGuideItem } from './UserGuideItem'

@ComponentV2
export struct UserGuideContent {
  @Param @Require content: TabsContent[]

  build() {
    Column() {
      List({ space: 24 }) {
        Repeat<TabsContent>(this.content)
          .each((ri: RepeatItem<TabsContent>) => {
            ListItem() {
              if (ri.item && ri.item.type === 'text') {
                UserGuideItem({ title: ri.item.title, content: ri.item.content })
              }
            }
          })
      }
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}