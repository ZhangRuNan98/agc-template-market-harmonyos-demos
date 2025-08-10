import { BaseViewModel } from 'lib_common';
import { HomeServiceApi, NewsEnum, RequestListData } from 'lib_news_api';
import { RendNewsInfo } from '../sdk/model/Model';
import { emitter } from '@kit.BasicServicesKit';


@ObservedV2
export class NewsContentVM extends BaseViewModel {
  @Trace isRefreshing: boolean = false
  @Trace resource: string = 'recommend'
  @Trace rendNewsInfoList: RendNewsInfo[] = []
  @Trace bgColor: ResourceStr = $r('sys.color.background_primary')

  public init(resource: string, rendNewsInfoList: RendNewsInfo[]) {
    this.rendNewsInfoList = rendNewsInfoList
    this.resource = resource
    this.isRefreshing = true
    if (resource === 'follow') {
      emitter.on('followRefresh', () => {
        this.getNewsDynamicData('follow')
      })
    }
  }


  public emitterOff() {
    emitter.off('followRefresh')
  }

  public async getNewsDynamicData(resource: string) {
    let newsInfoList: RequestListData[] = []
    if (resource === 'recommend' && AppStorage.get('recommendList')) {
      newsInfoList = AppStorage.get('recommendList') as RequestListData[]
      /*
       * 再次刷新不需要从AppStorage取
       * */
      AppStorage.setOrCreate('recommendList','')
    } else {
      newsInfoList = await HomeServiceApi.queryHomeRecommendList(resource);
    }
    if (resource === 'follow') {
      newsInfoList = await HomeServiceApi.queryHomeFollowList([NewsEnum.Article])
      /*
       * 处理extraInfo
       * */
      newsInfoList.forEach(item => {
        item.extraInfo.isNeedAuthor = true
        item.extraInfo.isFollow = true
      })
    }
    let list = this.rendNewsInfoList.find(item => item.id === resource)
    if (list) {
      list.newsList.setData(newsInfoList)
    }
    this.isRefreshing = false
  }

  public refresh() {
    this.getNewsDynamicData(this.resource)
  }
}