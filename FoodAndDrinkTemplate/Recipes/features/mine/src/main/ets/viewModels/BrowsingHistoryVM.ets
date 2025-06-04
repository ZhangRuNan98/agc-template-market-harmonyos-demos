import { queryRecipeHistoryList } from 'network';
import { historyListMapper } from '../mapper/Index';
import { RecipeItem } from '../types/Index';


@ObservedV2
export class BrowsingHistoryVM {
  private static _instance: BrowsingHistoryVM;
  @Trace history: RecipeItem[] = [];

  async queryRecipeHistory() {
    const res = await queryRecipeHistoryList();
    this.history = historyListMapper(res.data);
  }

  public static get instance() {
    if (!BrowsingHistoryVM._instance) {
      BrowsingHistoryVM._instance = new BrowsingHistoryVM();
    }
    return BrowsingHistoryVM._instance;
  }
}
