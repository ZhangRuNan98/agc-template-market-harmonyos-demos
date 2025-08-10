import { BaseViewModel, RouterMap, RouterUtils } from 'lib_common';
import { AuthorModel, AuthorResponse, AuthorServiceApi, BaseNewsServiceApi } from 'lib_news_api';
import { LayoutNewsDataSource, NewsDataSource } from '../common/NewsDataSource';

@ObservedV2
export class PersonalPageViewModel extends BaseViewModel {
  @Trace userId: string = '';
  @Trace userInfo: AuthorModel | null = null;
  @Trace titleText: string = '';
  @Trace curIndex: number = 0;
  @Trace targetIndex: number = 0;
  @Trace loading: boolean = false;
  @Trace articleDataSource: LayoutNewsDataSource = new LayoutNewsDataSource();
  @Trace videoDataSource: LayoutNewsDataSource = new LayoutNewsDataSource();
  @Trace postDataSource: LayoutNewsDataSource = new LayoutNewsDataSource();
  @Trace dataSource: (LayoutNewsDataSource | NewsDataSource) [] =
    [this.articleDataSource, this.videoDataSource, this.postDataSource];

  init() {
    this.userId = RouterUtils.getParamByName(RouterMap.PROFILE_HOME) as string || this.userInfoModel.authorId;
    this.queryAuthorInfo();
    this.queryArticleList();
    this.queryVideoList();
    this.queryPostList();
  }

  onRefreshing() {
    this.loading = true;
    setTimeout(() => {
      this.init();
      this.loading = false;
    }, 300);
  }

  queryAuthorInfo() {
    const user = AuthorServiceApi.queryAuthorInfo(this.userId) as AuthorResponse;
    this.userInfo = new AuthorModel(user);
  }

  queryArticleList() {
    const list = BaseNewsServiceApi.queryAuthorArticles(this.userId);
    this.articleDataSource.setData(list);
  }

  queryVideoList() {
    const list = BaseNewsServiceApi.queryAuthorVideos(this.userId);
    this.videoDataSource.setData(list);
  }

  queryPostList() {
    const list = BaseNewsServiceApi.queryAuthorPosts(this.userId);
    list.forEach((item) => {
      item.extraInfo.showUserBar = false;
      item.extraInfo.showTimeBottom = true;
      item.extraInfo.authorId = this.userId
    })
    this.postDataSource.setData(list);
  }

  jumpChatPage() {
    RouterUtils.pushPathByName(RouterMap.MINE_MSG_IM_CHAT, this.userInfo);
  }

  @Computed
  get isMyself() {
    return this.userInfoModel.authorId === this.userInfo?.authorId;
  }
}