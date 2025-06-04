import { RecipeCategory } from 'link_category';
import { queryRecipeCategory } from 'network';

const TAG = '[ClassificationVM]';

@ObservedV2
export class ClassificationVM {
  @Trace recipeCategoryList: RecipeCategory[] = []
  @Trace currentIndex: number = 0
  private static _instance: ClassificationVM;

  public static get instance() {
    if (!ClassificationVM._instance) {
      ClassificationVM._instance = new ClassificationVM();
    }
    return ClassificationVM._instance;
  }

  init() {
    queryRecipeCategory().then(res => {
      if (res.status === 200) {
        this.recipeCategoryList = res.data
      }
    })
  }

  changeCurrentIndex(index: number) {
    this.currentIndex = index
  }
}
