import { emitter } from '@kit.BasicServicesKit';
import { WindowUtil, RouterMap, RouterModule } from 'commonlib';
import { TabListItem } from '../types/Index';
import { MainEntryVM } from '../viewmodels/MainEntryVM';


@Entry
@ComponentV2
struct MainEntry {
  @Local vm: MainEntryVM = MainEntryVM.instance;
  private controller: TabsController = new TabsController();
  callbackFn: () => void = () => {
    this.controller.changeIndex(1);
  };

  @Monitor('vm.formCardJump.form.id', 'vm.formCardJump.form.url')
  formChange(monitor: IMonitor) {
    if (monitor.value('vm.formCardJump.form.url')?.now) {
      let url = monitor.value('vm.formCardJump.form.url')?.now as string;
      this.widgetInterception(url);
    }
  }

  /*
    * 卡片跳转拦截
    * */
  widgetInterception(url: string) {
    if (url) {
      if (url === RouterMap.HOME) {
        RouterModule.clear();
        this.controller.changeIndex(0);
      }
      if (url === RouterMap.FIND) {
        RouterModule.clear();
        this.controller.changeIndex(1);
      }
      if (url === RouterMap.CUSTOM) {
        RouterModule.clear();
        this.controller.changeIndex(2);
      }

      this.vm.formCardJump.form.url = '';
    }
  }

  aboutToAppear(): void {
    WindowUtil.initWindowUtil();
    emitter.on('toFindPage', this.callbackFn);
  }

  aboutToDisappear(): void {
    emitter.off('toFindPage', this.callbackFn);
  }

  build() {
    Navigation(this.vm.navStack) {
      Column() {
        Blank().height(WindowUtil.avoidAreaSize.top).backgroundColor($r('sys.color.background_secondary'))
        Tabs({ barPosition: BarPosition.End, index: this.vm.curIndex, controller: this.controller }) {
          ForEach(this.vm.tabList, (item: TabListItem, index: number) => {
            TabContent() {
              item.component.builder();
            }
            .tabBar(this.tabBarBuilder(item, index))
            .clip(index !== 0)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]);
          }, (item: TabListItem) => item.label);
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
        .scrollable(false)
        .layoutWeight(1)
        .barHeight(48)
        .animationDuration(0)
        .barMode(BarMode.Fixed)
        .onChange((index: number) => {
          this.vm.curIndex = index;
        });
        Blank().height(WindowUtil.avoidAreaSize.bottom)
      }
      .backgroundColor(Color.White)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]);
    }
    .hideTitleBar(true)
    .hideToolBar(true)
    .hideBackButton(true)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .mode(NavigationMode.Stack)
  }

  @Builder
  tabBarBuilder(item: TabListItem, index: number) {
    Column() {
      Image(this.vm.curIndex === index ? item.iconChecked : item.icon)
        .width(24)
        .height(24);
      Text(item.label)
        .fontColor(this.vm.curIndex === index ? $r('sys.color.alert') :
        $r('sys.color.font_secondary'))
        .fontSize(10)
        .margin({ top: 4 });
    }.width('100%').padding({ top: 4 });
  }
}