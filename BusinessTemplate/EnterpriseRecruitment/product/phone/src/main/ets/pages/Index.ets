import { Information } from './Information';
import { Job } from './Job';
import { Mine } from './Mine';
import { AvoidArea } from '@ohos_agcit/common_component';
import { AppStorageV2, ComponentContent } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { checkUpdate, DialogController, findNewVersion, Params } from 'check_app_update';

@Entry
@ComponentV2
struct Index {
  @Local avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
  @Local currentIndex: number = 0
  private controller: TabsController = new TabsController()
  private tabsController: TabsController = new TabsController()
  private ctx: UIContext = this.getUIContext();

  aboutToAppear(): void {
    checkUpdate(this.getUIContext().getHostContext() as common.UIAbilityContext)
      .then(version => {
        // 0 不存在新版本， 1 存在新版本
        if (version === 1) {
          this.showDialog(version);
        } else {
          // mock 新版本
          this.showDialog(version);
        }
      })
  }

  showDialog(version: number) {
    let contentNode: ComponentContent<object> =
      new ComponentContent(this.ctx, wrapBuilder(findNewVersion), new Params(version))
    DialogController.setContext(this.ctx);
    DialogController.setContentNode(contentNode);
    DialogController.setOptions({alignment:DialogAlignment.Center,offset:{dx:0, dy:0}})
    DialogController.openDialog();
  }


  @Builder
  tabBuilder(title: Resource, index: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === index ? selectedImg : normalImg)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
      Text(title)
        .margin({ top: 4 })
        .fontSize($r('app.float.font_size_10'))
        .fontColor(this.currentIndex === index ? '#3388ff' : '#E6000000')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(52)
    .padding({ bottom: px2vp(this.avoidArea.bottomRectHeight) })
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller, index: this.currentIndex }) {
        TabContent() {
          Information()
        }
        .tabBar(this.tabBuilder($r('app.string.app_information'), 0, $r('app.media.active_home'), $r('app.media.home')))

        TabContent() {
          Job()
        }
        .tabBar(this.tabBuilder($r('app.string.app_job'), 1, $r('app.media.active_job'), $r('app.media.job')))

        TabContent() {
          Mine()
        }
        .tabBar(this.tabBuilder($r('app.string.app_mine'), 2, $r('app.media.mine_active'), $r('app.media.mine')))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth(360)
      .barHeight(80)
      .animationDuration(0)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .backgroundColor('#F1F3F5')
      .scrollable(false)
    }
    .width('100%')
    .height('100%')
  }
}