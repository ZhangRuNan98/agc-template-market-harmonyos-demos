import { AlertDialog } from '@kit.ArkUI';
import { RouterMap, RouterModule } from '@agctemplate/router_module';
import { RouterTable, TabStyle } from '../common/TabConstants';
import { TabListItem } from '../model/TabListItem';
import { MainVM } from '../viewmodels/MainVM';
import { PreferenceUtil, PreferConstant } from '@agctemplate/utils';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BarVM } from '@agctemplate/widgets';

const TAG = '[Index]'

@Entry
@ComponentV2
struct Index {
  @Provider('pathInfo') pathInfo: NavPathStack = RouterModule.stack
  @Provider('navId') navId: string = 'navId';
  // 弹框页
  dialogPages: string[] = [RouterMap.PRIVACY_USE_PAGE, RouterMap.LOGIN_PAGE, RouterMap.COMMENT_KEY_BOARD_PAGE]
  backPageDialogController?: CustomDialogController;
  content = ''
  leftButtonText = ''
  rightButtonText = ''

  backPageDialogOpen(content: string, leftButtonText: string, rightButtonText: string) {
    this.backPageDialogController = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: '温馨提示',
        content: content,
        secondaryButton: {
          value: rightButtonText,
          action: () => {
          }
        },
        primaryButton: {
          value: leftButtonText,
          fontColor: $r('sys.color.font_tertiary'),
          action: () => {
            RouterModule.pop()
          },
        },
      }),
    })
    this.backPageDialogController.open()
  }

  aboutToAppear() {
    //读取状态值，如果为空设置为true
    let isFirstLaunch = PreferenceUtil.getInstance(getContext()).get(PreferConstant.FIRSTLAUNCH, true) as boolean
    if (isFirstLaunch) {
      //隐私政策
      RouterModule.replace({ url: RouterMap.PRIVACY_AGREEMENT_PAGE })
      return;
    }
    RouterModule.replace({ url: RouterMap.MAIN_PAGE })
  }

  onBackPressed: Function = (): boolean => {
    return false;
  }

  @Builder
  pageMap(name: string) {
    RouterTable.getBuilder(name).builder()
  }

  build() {
    Column() {
      Navigation(RouterModule.stack) {
      }
      .hideNavBar(true)
      .hideToolBar(true)
      .hideTitleBar(true)
      .hideBackButton(true)
      .mode(NavigationMode.Stack)
      .navDestination(this.pageMap)
      .id(this.navId)
    }
  }
}

@ComponentV2
struct MainPage {
  vm: MainVM = MainVM.instance;

  @Builder
  tabBarBuilder(item: TabListItem, index: number) {
    Column({ space: 2 }) {
      Image(this.vm.curIndex === index ? item.iconChecked : item.icon)
        .width(TabStyle.ICON_SIZE)
        .height(TabStyle.ICON_SIZE)
      Text(item.label)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.Caption_M'))
        .fontColor(this.vm.curIndex === index ?
          '#EE5D1A' : $r('sys.color.icon_secondary'))
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(TabStyle.BAR_HEIGHT)
  }

  build() {
    NavDestination() {
      Column() {
        Tabs({ barPosition: BarPosition.End, index: $$this.vm.curIndex, controller: this.vm.controller }) {
          ForEach(this.vm.tabList, (item: TabListItem, index: number) => {
            TabContent() {
              item.component.builder();
            }
            .tabBar(this.tabBarBuilder(item, index))
          }, (item: TabListItem, index) => JSON.stringify(item) + '_' + index)
        }
        .scrollable(false)
        .barMode(BarMode.Fixed)
        .barHeight(TabStyle.BAR_HEIGHT)
        .height('100%')
        .padding({ bottom: BarVM.instance.aiBarH })
        .animationDuration(TabStyle.ANIMATION_DURATION)
      }
      .backgroundColor($r('sys.color.white'))
    }
  }
}

@Builder
export function MainPageBuilder() {
  MainPage()
}