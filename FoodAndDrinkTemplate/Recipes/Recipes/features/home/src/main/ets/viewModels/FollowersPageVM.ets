import { RouterMap, RouterModule } from 'commonlib';
import { getBloggerFollowers } from 'network';
import { BloggerFollowerClz } from '../types/Index';

const TAG = '[FollowersPageVM]';

@ObservedV2
export class FollowersPageVM {
  @Trace followerList: BloggerFollowerClz[] = []
  @Trace authorName: string = ''

  init() {
    let params = RouterModule.getNavParam<Record<string, number | string>>(RouterMap.FOLLOWERS_PAGE)
    let authorId = params?.id || 0
    this.authorName = params?.name?.toString() || ''
    getBloggerFollowers(Number(authorId)).then(res => {
      if (res.status === 200) {
        this.followerList =
          res.data.map(item => new BloggerFollowerClz(item.id, item.authorId, item.author, item.authorAvatar,
            item.isFollower))
      }
    })
  }
}
