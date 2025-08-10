import { CommonConstants } from 'lib_common'
import { NewsResponse } from 'lib_news_api'
import { TabEnum, TabItem } from '../common/Constants';
import { InteractionViewModel } from '../viewmodels/InteractionViewModel';
import { InteractionFeedCard } from './InteractionFeedCard'
import { NoWatcher } from './NoWatcher';

@ComponentV2
export struct InterActionTabContent {
  @Param @Require resource:TabItem
  @Local vm: InteractionViewModel = new InteractionViewModel();

  aboutToAppear(): void {
    this.vm.init(this.resource.id)
  }

  build() {
    Column(){
      Refresh({ refreshing: $$this.vm.isRefreshing }) {
        List({ space: CommonConstants.SPACE_M }) {
          if(!this.vm.interactionList.length && this.resource.id === TabEnum.Watch) {
            ListItem() {
              NoWatcher()
            }
          }else {
            ForEach(this.vm.interactionList, (item: NewsResponse) => {
              ListItem() {
                InteractionFeedCard({
                  cardInfo: item,
                })
              }
              .backgroundColor($r('sys.color.background_primary'))
              .borderRadius(16)
              .padding(CommonConstants.PADDING_M)
            }, (item: NewsResponse) => item.id)
          }
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .padding({ left: CommonConstants.PADDING_M, right: CommonConstants.PADDING_M })
        .margin({ top: 16 })
      }
      .onRefreshing(() => {
        this.vm.refresh()
      })
      .layoutWeight(1)
      .pullToRefresh(true)
    }
    .height(CommonConstants.FULL_PERCENT)
  }
}