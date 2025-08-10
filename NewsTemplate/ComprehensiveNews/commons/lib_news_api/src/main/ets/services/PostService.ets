import { NewsEnum } from '../constants/Constants';
import { BaseNews } from '../database/NewsType';
import { PostRequest } from '../params/request/CommonRequest';
import { FlexLayoutModel } from '../params/response/LayoutResponse';
import { NewsResponse } from '../params/response/NewsResponse';
import { Utils } from '../utils/Utils';
import { BaseNewsService, BaseNewsServiceApi } from './BaseNewsService';
import { MineServiceApi } from './MineService';
import { MockFlexLayout } from './mockdata/MockFlexLayout';
import { MockPost } from './mockdata/MockPost';

/**
 * 新闻-动态类
 */
export class PostService extends BaseNewsService {
  /**
   * 查询推荐
   * @returns
   */
  public queryPostRecommendList(): NewsResponse[] {
    const posts = MockPost.list
      .map((post: BaseNews) => BaseNewsServiceApi.queryNews(post.id))
      .filter(v => Boolean(v)) as NewsResponse[];
    return Utils.shuffleArray([...posts]);
  }

  /**
   * 查询关注
   * @returns
   */
  public queryPostFollowList(): NewsResponse[] {
    const myUserInfo = MineServiceApi.queryAuthorRaw();
    const posts = MockPost.list
      .filter(v => myUserInfo?.watchers.includes(v.authorId))
      .map((post: BaseNews) => BaseNewsServiceApi.queryNews(post.id))
      .filter(v => Boolean(v)) as NewsResponse[];
    return Utils.shuffleArray([...posts]);
  }

  /**
   * 查询附近
   */
  public queryPostNearList(): NewsResponse[] {
    return [];
  }

  /**
   * 发布动态
   * @param post
   */
  public publishPost(post: PostRequest) {
    const postDefault = MockPost.default
    let postInfo: BaseNews = {
      id: `post_${Utils.randomArticleId()}`,
      type: NewsEnum.Post,
      title: post.postBody,
      authorId: MineServiceApi.queryAuthorInfo()?.authorId as string,
      createTime: new Date().getTime(),
      commentCount: 0,
      markCount: 0,
      likeCount: 0,
      shareCount: 0,
      isLiked: false,
      isMarked: false,
      recommends: [{
        newsId: 'article_9',
        newsType: 0,
      }, {
        newsId: 'article_11',
        newsType: 0,
      }],
      postImgList: post.postImgList,
      navInfo: postDefault.navInfo,
    }
    MockPost.list.unshift(postInfo)
  }
}

const instance = new PostService();

export { instance as PostServiceApi }