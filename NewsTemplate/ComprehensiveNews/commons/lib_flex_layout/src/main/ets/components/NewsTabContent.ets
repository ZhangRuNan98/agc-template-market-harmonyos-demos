import { PersistenceV2 } from '@kit.ArkUI';
import { CommonConstants, UserInfoModel } from 'lib_common'
import { RequestListData } from 'lib_news_api';
import { RendNewsInfo } from '../sdk/model/Model'
import { FlexLayoutPage } from '../sdk/FlexLayoutPage';
import { NewsContentVM } from '../viewModel/NewsContentVM';
import { NoLoginPage } from './NoLoginPage';

@ComponentV2
export struct NewsTabContent {
  @Param @Require channelItem: RendNewsInfo
  @Param rendNewsInfoList: RendNewsInfo[] = []
  @Param bgColor:ResourceStr = $r('sys.color.background_primary')
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;
  @Local newsContentVM: NewsContentVM = new NewsContentVM()
  scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.newsContentVM.init(this.channelItem.id,this.rendNewsInfoList)
  }

  aboutToDisappear(): void {
    this.newsContentVM.emitterOff()
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.newsContentVM.isRefreshing }) {
        List({ space: CommonConstants.SPACE_S, scroller: this.scroller }) {
          if (this.channelItem.id === 'follow' && !this.userInfoModel.isLogin) {
            ListItem() {
              NoLoginPage()
            }
            .backgroundColor($r('sys.color.background_primary'))
            .height(CommonConstants.FULL_PERCENT)
            .width(CommonConstants.FULL_PERCENT)
          } else {
            LazyForEach(this.channelItem.newsList, (value: RequestListData) => {
              ListItem() {
                FlexLayoutPage({
                  setting: JSON.parse(value.navInfo.setting),
                  articles: value.articles,
                  extraInfo: value.extraInfo,
                })
              }
              .padding({
                left: CommonConstants.PADDING_PAGE,
                right: CommonConstants.PADDING_PAGE,
              })
              .backgroundColor($r('sys.color.background_primary'))
            }, (value: RequestListData,index:number) => index + JSON.stringify(value))
          }
        }
        .scrollBar(BarState.Off)
        .cachedCount(3)
        .backgroundColor(this.bgColor)
      }
      .onRefreshing(() => {
        this.newsContentVM.refresh()
      })
      .pullToRefresh(true)
      .height(CommonConstants.FULL_PERCENT)
    }
    .height(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.Start)
  }
}