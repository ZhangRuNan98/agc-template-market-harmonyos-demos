import { RecipeBriefInfo } from '../types/Index';
import LazyDataSource from '../utils/LazyDataSource';
import { RecommendedCard } from './RecommendedCard';

/**
 * @usage: 精选推荐组件，用于展示菜谱卡片瀑布流
 * @layout: 组件为列排列。顶部是标题栏；底部是瀑布流，左右和上下排列
 */
@ComponentV2
export struct FeaturedRecipes {
  @Param dishesList: LazyDataSource<RecipeBriefInfo> = new LazyDataSource();
  @Param showTitle: boolean = false;
  @Param canDelete: boolean = false;
  @Param isToDelete: boolean = false;
  @Event onClickCb: (id: number) => void = () => {
  }
  @Event jumpBloggerInfo: (id: number) => void = () => {
  }
  @Event deleteRecipes: (ids: number[]) => void = () => {
  }
  @Event changeSelect: (id: number, flag: boolean) => void = () => {
  }
  @Event changeDeleteState: (isToDelete: boolean) => void = () => {
  }
  @BuilderParam uploadBuilderParam: () => void = this.uploadBuilder;

  @Builder
  uploadBuilder() {
  }

  build() {
    Column() {
      Text('精选推荐')
        .margin({ bottom: 12 })
        .fontColor($r('sys.color.font_primary'))
        .fontSize(16)
        .width('100%')
        .visibility(this.showTitle ? Visibility.Visible : Visibility.None)
      WaterFlow() {
        this.uploadBuilderParam()
        LazyForEach(this.dishesList, (item: RecipeBriefInfo) => {
          FlowItem() {
            RecommendedCard({
              recipe: item,
              canDelete: this.canDelete,
              isToDelete: this.isToDelete,
              jumpBloggerInfo: () => {
                this.jumpBloggerInfo(item.authorId)
              },
              changeDeleteState: (isToDelete: boolean) => {
                this.changeDeleteState(isToDelete)
              },
              onClickCb: (id: number) => {
                this.onClickCb(id)
              },
              changeSelect: (id: number, flag: boolean) => {
                this.changeSelect(id, flag)
              },
            })
          }
        }, (item: RecipeBriefInfo) => item.id.toString())
      }
      .columnsGap(8)
      .rowsGap(8)
      .columnsTemplate('1fr 1fr');
    }

  }
}
