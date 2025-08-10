import { BaseViewModel, RouterMap, RouterUtils } from 'lib_common';
import { AuthorModel, AuthorServiceApi } from 'lib_news_api';
import { AuthorDataSource } from '../common/AuthorDataSource';

@ObservedV2
export class WatchPageViewModel extends BaseViewModel {
  @Trace userId: string = '';
  @Trace title: string = '我的关注';
  @Trace emptyTip: string = '暂无关注';
  @Trace dataSource: AuthorDataSource = new AuthorDataSource();

  init() {
    this.userId = RouterUtils.getParamByName(RouterMap.PROFILE_WATCH) as string;
    this.title = this.userId === this.userInfoModel.authorId ? '我的关注' : '他的关注';
    this.queryWatchList();
  }

  queryWatchList() {
    const list = AuthorServiceApi.queryWatchUsers(this.userId).map(v => new AuthorModel(v));
    this.dataSource.setData(list);
  }

  loadMore() {
  }

  customBack() {
    RouterUtils.pop('refresh');
  }
}