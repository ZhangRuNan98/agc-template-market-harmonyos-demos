import { getDataFromJSON } from 'common';
import { UserGuideContent } from '../components/UserGuideContent';
import { TabsInfo } from '../model/GuidePageModel';

@ComponentV2
export struct UserGuidePage {
  @Consumer('pageInfos') pageInfos: NavPathStack = new NavPathStack()
  @Local currentIndex: number = 0;
  private tabsInfos?: Array<TabsInfo>

  aboutToAppear(): void {
    this.tabsInfos = getDataFromJSON<TabsInfo>('user_guide_tabs.json5', this);
  }

  @Builder
  tabBuilder(title: string, targetIndex: number) {
    Row() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? $r('app.color.pure_white') : $r('app.color.tab_font_color'))
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
    }
    .padding({
      left: 7,
      right: 7,
      top: 6,
      bottom: 6
    })
    .backgroundColor(this.currentIndex === targetIndex ? $r('app.color.orange') : $r('app.color.item_gray'))
    .justifyContent(FlexAlign.Center)
    .borderRadius(14)
    .width(60)
    .height(28)
  }

  build() {
    NavDestination() {
      Column() {
        Tabs({
          barPosition: BarPosition.Start,
          index: this.currentIndex,
        }) {
          ForEach(this.tabsInfos, (item: TabsInfo, index: number) => {
            TabContent() {
              UserGuideContent({ content: item.value })
            }
            .tabBar(this.tabBuilder(item.name, index))
          })
        }
        .barMode(BarMode.Scrollable, { nonScrollableLayoutStyle: LayoutStyle.ALWAYS_AVERAGE_SPLIT })
        .onChange((index: number) => {
          this.currentIndex = index;
        })
      }
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 16, right:16 })

    }
    .title('用户指南')
  }
}