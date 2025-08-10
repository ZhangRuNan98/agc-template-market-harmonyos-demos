import { UIUtils } from '@kit.ArkUI';
import { LoginSheetUtils } from 'lib_account';
import { BaseViewModel, NewsEnum, RouterToNews } from 'lib_common';
import { MineServiceApi, NewsResponse, PostServiceApi } from 'lib_news_api';
import { TabEnum } from '../common/Constants';

@ObservedV2
export class InteractionViewModel extends BaseViewModel {
  private authorId: string = ''
  @Trace isRefreshing: boolean = false
  @Trace interactionList: NewsResponse[] = []
  @Trace resourceId: TabEnum = TabEnum.Watch

  @Monitor('resourceId')
  tabChange() {
    this.tabSwitch()
  }

  setAuthorId(authorId: string) {
    this.authorId = authorId
  }

  public isWatch() {
    return this.userInfoModel.isLogin && this.userInfoModel.watchers.includes(this.authorId)
  }

  public init(resourceId: TabEnum) {
    this.isRefreshing = true
    this.resourceId = resourceId
    this.setActionData(PostServiceApi.queryPostFollowList)
  }

  public async setActionData(actionAPi: () => NewsResponse[]) {
    this.interactionList = await actionAPi()
    this.interactionList = this.interactionList.map(item => UIUtils.makeObserved(item))
    this.isRefreshing = false
  }

  public tabSwitch() {
    switch (this.resourceId) {
      case TabEnum.Watch:
        this.setActionData(PostServiceApi.queryPostFollowList)
        break
      case TabEnum.Recommend:
        this.setActionData(PostServiceApi.queryPostRecommendList)
        break
      case TabEnum.Nearby:
        this.setActionData(PostServiceApi.queryPostRecommendList)
        break
    }
  }

  public refresh() {
    this.tabSwitch()
  }

  public watchOperation() {
    if (!this.userInfoModel.isLogin) {
      LoginSheetUtils.open()
      return
    }
    if (!this.isWatch()) {
      this.addWatch()
      return
    }
    this.cancelWatch()
  }

  public addWatch() {
    this.userInfoModel.watchers.push(this.authorId)
    MineServiceApi.addWatch(this.authorId)
  }

  public cancelWatch() {
    let watchIndex = this.userInfoModel.watchers.findIndex(v => v === this.authorId)
    this.userInfoModel.watchers.splice(watchIndex, 1)
    MineServiceApi.cancelWatch(this.authorId)
  }

  public actionToNewsDetails(cardInfo: NewsResponse) {
    let routerParams: Record<string, string | NewsEnum> = {
      'type': cardInfo.type,
      'newsId': cardInfo.id,
      'surfaceUrl': cardInfo.postImgList?.[0].surfaceUrl ?? '',
    }
    RouterToNews.pushToNewsDetails(routerParams)
  }
}