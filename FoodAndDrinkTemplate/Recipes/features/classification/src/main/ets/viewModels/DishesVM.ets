import { AccountUtil, AppStorageMap, Logger, RouterMap, RouterModule } from 'commonlib';
import { addCollection, changeFollowers, queryRecipeDetail, RecipeDetail, removeCollection } from 'network';
import { BasketList } from '../types/Index';
import { PersistenceV2, promptAction } from '@kit.ArkUI';

const TAG = '[DishesVM]';

@ObservedV2
export class DishesVM {
  @Trace recipeDetail?: RecipeDetail = undefined
  @Trace basketList: BasketList =
    PersistenceV2.connect(BasketList, AppStorageMap.SHOPPING_BASKET, () => new BasketList())!;
  @Trace collection: boolean = false
  @Trace isFollower: boolean = false
  scroller: Scroller = new Scroller();

  init(): void {
    let recipeRouter = RouterModule.getNavParam<RecipeDetail>(RouterMap.DISHES)
    Logger.info('Dishes detail router params:', JSON.stringify(recipeRouter))
    queryRecipeDetail(recipeRouter?.id || 0).then(res => {
      if (res.status === 200) {
        this.recipeDetail = res.data
        this.collection = res.data.isCollected || false
      }
    })
  }

  addCollection(): void {
    addCollection(this.recipeDetail?.id || 0).then(res => {
      if (res.status === 200) {
        this.collection = true
      }
    })
  }

  cancelCollection(): void {
    removeCollection(this.recipeDetail?.id || 0).then(res => {
      if (res.status === 200) {
        this.collection = false
      }
    })
  }

  collectClick() {
    if (AccountUtil.getUserInfo().isLogin) {
      if (!this.collection) {
        this.addCollection();
      } else {
        this.cancelCollection();
      }

    } else {
      promptAction.showToast({ message: '未登录，请登录后重试！' });
      RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
    }
  }

  addBasket() {
    if (this.basketList.isInBasket(this.recipeDetail?.id ?? -1)) {
      return;
    }
    if (this.recipeDetail) {
      if (AccountUtil.getUserInfo().isLogin) {
        this.basketList.addBasket(this.recipeDetail);
        promptAction.showToast({ message: '添加成功~！' });
      } else {
        promptAction.showToast({ message: '未登录，请登录后重试！' });
        RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
      }
    }
  }

  collectCb() {
    if (AccountUtil.getUserInfo().isLogin) {
      if (!this.collection) {
        this.addCollection();
      } else {
        this.cancelCollection();
      }

    } else {
      promptAction.showToast({ message: '未登录，请登录后重试！' });
      RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
    }
  }

  changeFollower(isFollower: boolean) {
    if (!AccountUtil.getUserInfo().isLogin) {
      RouterModule.push(RouterMap.QUICK_LOGIN_PAGE);
      return
    }
    if (isFollower) {
      changeFollowers(Number(this.recipeDetail?.authorId), 1)
    } else {
      changeFollowers(Number(this.recipeDetail?.authorId), 2)
    }
    this.isFollower = isFollower
  }
}
