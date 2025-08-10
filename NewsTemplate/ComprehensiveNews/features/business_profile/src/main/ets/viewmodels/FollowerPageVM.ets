import { BaseViewModel, RouterMap, RouterUtils } from 'lib_common';
import { AuthorModel, AuthorServiceApi } from 'lib_news_api';
import { AuthorDataSource } from '../common/AuthorDataSource';

@ObservedV2
export class FollowerPageViewModel extends BaseViewModel {
  @Trace userId: string = '';
  @Trace title: string = '我的粉丝';
  @Trace emptyTip: string = '暂无粉丝';
  @Trace dataSource: AuthorDataSource = new AuthorDataSource();

  init() {
    this.userId = RouterUtils.getParamByName(RouterMap.PROFILE_FOLLOWER) as string;
    this.title = this.userId === this.userInfoModel.authorId ? '我的粉丝' : '他的粉丝';
    this.queryFollowList();
  }

  queryFollowList() {
    const list = AuthorServiceApi.queryFollowers(this.userId).map(v => new AuthorModel(v));
    this.dataSource.setData(list);
  }

  loadMore() {
  }

  customBack() {
    RouterUtils.pop('refresh');
  }
}