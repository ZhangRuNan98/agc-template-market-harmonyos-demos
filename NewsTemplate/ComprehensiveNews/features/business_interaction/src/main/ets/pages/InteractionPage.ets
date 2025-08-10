import { PersistenceV2 } from '@kit.ArkUI';
import { CommonConstants, LinearColumnModifier, RouterMap, RouterUtils, SettingModel } from 'lib_common'
import { NavHeaderBar } from 'lib_widget';
import { TopBar } from '../components/TopBar';
import { TabItem, TAB_LIST } from '../common/Constants';
import { InterActionTabContent } from '../components/InterActionTabContent';

@Builder
export function InteractionPageBuilder() {
  InteractionPage()
}

@ComponentV2
struct InteractionPage {
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!
  @Local selectedId: number = 0
  @Local targetIndex: number = 0
  @Local modifier: LinearColumnModifier = new LinearColumnModifier($r('app.color.action_linear'));

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: '互动',
          isSubTitle: false,
          rightPartBuilder: () => {
            this.rightHeadPartBuilder()
          },
        })
        Column() {
          TopBar({
            selectedId: this.selectedId,
            onClickBar: (id: number) => {
              this.selectedId = id
              this.targetIndex = TAB_LIST.findIndex(item => item.id === id)
            },
          })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(40)
        .alignItems(HorizontalAlign.Start)
        .padding({
          left: CommonConstants.PADDING_PAGE,
          right: CommonConstants.PADDING_PAGE,
        })

        Tabs({ index: this.targetIndex }) {
          ForEach(TAB_LIST, (v: TabItem) => {
            TabContent() {
              InterActionTabContent({
                resource: v,
              })
            }
          }, (v: TabItem) => v.id + v.label)
        }
        .barHeight(0)
        .layoutWeight(1)
        .onAnimationStart((index: number, targetIndex: number) => {
          this.selectedId = TAB_LIST[targetIndex].id
        })
        .onChange((index: number) => {
          this.targetIndex = index
        })
      }
      .attributeModifier(this.modifier)
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_secondary'))
    }
    .hideTitleBar(true)
  }

  @Builder
  rightHeadPartBuilder() {
    Row({ space: CommonConstants.SPACE_S }) {
      Row() {
        Image($r('app.media.ic_search')).width($r('app.float.nav_icon_width')).fillColor($r('sys.color.font_primary'))
          .onClick(() => {
            RouterUtils.pushPathByName(RouterMap.NEWS_SEARCH)
          })
      }
      .padding(10)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .borderRadius('50%')

      Row() {
        Image($r('app.media.ic_plus'))
          .fillColor($r('sys.color.font_primary'))
          .width($r('app.float.nav_icon_width'))
          .draggable(false)
          .onClick(() => {
            RouterUtils.pushPathByName(RouterMap.PUBLISH_POST_PAGE);
          })
      }
      .padding(10)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .borderRadius('50%')
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.End)
  }
}