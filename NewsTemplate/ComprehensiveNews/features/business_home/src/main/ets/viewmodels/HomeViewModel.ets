import { PersistenceV2 } from '@kit.ArkUI';
import { BaseViewModel, NewsEnum, PushActionParams, PushUtils,
  RouterToNews,
  SearchHistory, SettingModel } from 'lib_common';
import { BaseNewsServiceApi, RequestListData } from 'lib_news_api';
import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';

@ObservedV2
export class HomeViewModel extends BaseViewModel {
  searchHistory: SearchHistory = PersistenceV2.connect(SearchHistory, () => new SearchHistory())!;
  @Trace searchResultList: RequestListData[] = []
  @Trace settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;

  getSearchResultList(searchValue: string) {
    this.searchResultList = BaseNewsServiceApi.querySearchResultList(searchValue)
  }

  searchChange(searchValue: string) {
    this.getSearchResultList(searchValue)
    if (this.searchHistory.historyList.includes(searchValue) || searchValue.trim() === '') {
      return
    }
    this.searchHistory.historyList.push(searchValue)
  }

  clearHistory() {
    this.searchHistory.historyList = []
  }

  sendPushNotice(context:common.UIAbilityContext) {
    if(this.settingInfo.pushSwitch) {
      notificationManager.requestEnableNotification(context, () => {
        /*
         * mock 开启随机推送
         * */
        let pushArticle = BaseNewsServiceApi.queryAllNewsList()
        PushUtils.randomPushMessage(pushArticle)
      });
    }
    /*
     * 判断是否是从push 卡片进入
     * */
    if (AppStorage.get('pushCardEntry')) {
      let newsData = AppStorage.get('pushCardEntry') as PushActionParams
      let routerParams: Record<string, string | NewsEnum> = {
        'type': newsData.type,
        'newsId': newsData.articleId,
        'authorId': newsData.authorId,
      }
      RouterToNews.pushToNewsDetails(routerParams)
      AppStorage.setOrCreate('isPushCardEntry', '')
    }
  }
}