import { BookMain } from 'course';
import { MockService } from 'external_interactions';
import { Home } from './Home';
import { Mine } from './Mine';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  pathStack: NavPathStack = new NavPathStack()
  tabController: TabsController = new TabsController()
  @StorageLink('bookJumpSearch') @Watch('changeIndex') bookJumpSearch: string = '';
  @StorageLink('jumpLogin') @Watch('changeIndex') jumpLogin: boolean = false

  aboutToAppear(): void {
    MockService.init();
  }

  @Builder
  tabBarBuilder(title: string, image: ResourceStr, index: number) {
    Column() {
      Image(image)
        .width(24)
        .height(24)
        .fillColor(this.currentIndex === index ? Color.Orange : '#666666')
      Text(title)
        .fontSize(10)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.currentIndex === index ? Color.Orange : '#666666')
    }
    .margin({ bottom: 15 })
  }

  build() {
    Navigation(this.pathStack) {
      Tabs({ barPosition: BarPosition.End, index: $$this.currentIndex, controller: this.tabController }) {
        TabContent() {
          // 首页
          Home({ pathStack: this.pathStack })
        }
        .tabBar(this.tabBarBuilder('首页', $r('app.media.home'), 0))

        TabContent() {
          // 预约页
          BookMain({ pathStack: this.pathStack, mainTabIndex: this.currentIndex })
        }
        .tabBar(this.tabBarBuilder('预约', $r('app.media.booking'), 1))

        TabContent() {
          // 个人页
          Mine({ pathStack: this.pathStack })
        }
        .tabBar(this.tabBarBuilder('我的', $r('app.media.mine'), 2))
      }
      .barHeight(70)
      .scrollable(false)
      .width('100%')
      .height('100%')
      .margin({ left: 10, right: 10 })
    }
    .hideTitleBar(true)
    .width('100%')
    .height('100%')
  }

  changeIndex(propertyName: string) {
    if (propertyName === 'bookJumpSearch') {
      if (this.bookJumpSearch !== undefined && this.bookJumpSearch.length > 0) {
        this.tabController.changeIndex(1)
      }
    } else if (propertyName === 'jumpLogin') {
      this.tabController.changeIndex(2)
    }
  }
}