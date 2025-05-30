import { TabIndexEnum } from 'base_ui';
import { AccountUtil, RouterMap, RouterModule } from 'commonlib';
import { LazyDataSource, RecipeBriefInfo } from 'featured_recipes';
import { changeFollowers, getBloggerInfo } from 'network';
import { BloggerInfo } from 'personal_homepage';

const TAG = '[BloggerProfilePageVM]';

@ObservedV2
export class BloggerProfilePageVM {
  @Trace bloggerInfo: BloggerInfo = new BloggerInfo()
  @Trace recipeList: LazyDataSource<RecipeBriefInfo> = new LazyDataSource();
  @Trace currentIndex: number = 1
  @Trace isFollower: boolean = false

  init() {
    let params = RouterModule.getNavParam<Record<string, number>>(RouterMap.BLOGGER_PROFILE_PAGE)
    let authorId = params?.id || 0
    getBloggerInfo(authorId).then(res => {
      if (res.status === 200) {
        let avatar = $r(`app.media.${res.data.avatar}`)
        this.bloggerInfo.updateData(res.data.id, res.data.name, avatar, res.data.profile, res.data.sex,
          res.data.createdAccount, res.data.ipLocation, res.data.bloggerType, res.data.followers, res.data.fans,
          res.data.beFavorite, res.data.beFollowed, res.data.myRecipeList, res.data.collectRecipeList)
        this.recipeList.pushArrayData(res.data.myRecipeList)
      }
    })
  }

  changeTabs(index: number) {
    this.currentIndex = index
    this.recipeList.pushArrayData(index === TabIndexEnum.FIRST ? this.bloggerInfo.myRecipeList :
    this.bloggerInfo.collectRecipeList)
  }

  followCb(isFollower: boolean) {
    if (!AccountUtil.getUserInfo().isLogin) {
      RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
      return
    }
    if (isFollower) {
      changeFollowers(this.bloggerInfo.id, 1)
    } else {
      changeFollowers(this.bloggerInfo.id, 2)
    }
    this.isFollower = isFollower
    this.init()
  }
}
