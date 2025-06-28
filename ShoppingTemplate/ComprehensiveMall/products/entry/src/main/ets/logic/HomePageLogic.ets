import {
  LoadingStatus,
  cache,
  routerStack,
  GuessLike,
  Home,
  Category,
  SearchSuggestionCarouselLogic,
  RouterMap,
  GlobalStateMgr,
  iData,
  Any,
} from 'lib_foundation';
import { client } from 'lib_network';

export enum LoadStatus {
  LOAD = 'load',
  REFRESH = 'refresh',
}

@ObservedV2
export class HomePageLogic {
  public readonly global: GlobalStateMgr = iData.global;
  public readonly searchSuggestionCarouselLogic: SearchSuggestionCarouselLogic =
    new SearchSuggestionCarouselLogic();
  @Trace
  public loadingStatus: LoadingStatus = LoadingStatus.LOADING;
  @Trace
  public refreshStatus: RefreshStatus = RefreshStatus.Inactive;
  @Trace
  public isRefreshing: boolean = false;
  @Trace
  categoryList: Category[] = [];
  @Monitor('global.rootPageActiveTabId', 'global.isNavPathStackEmpty')
  public onGlobalStateChange(iMonitor: IMonitor): void {
    let isShow: boolean = false;
    for (let k of iMonitor.dirty) {
      const v: IMonitorValue<Any> | undefined = iMonitor.value<Any>(k);
      if (v) {
        switch (k) {
          case 'global.rootPageActiveTabId':
            const id: string = v.now as string;
            isShow = (id === 'HomePage' && iData.global.isNavPathStackEmpty);
            break;
          case 'global.isNavPathStackEmpty':
            const isEmpty: boolean = v.now as boolean;
            isShow = (isEmpty && iData.global.rootPageActiveTabId === 'HomePage');
            break;
        }
      }
    }
    if (isShow) {
      this.searchSuggestionCarouselLogic.start();
    } else {
      this.searchSuggestionCarouselLogic.stop();
    }
  }
  public onReloading = (): void => {
    if (this.loadingStatus === LoadingStatus.FAIL) {
      this.loadingStatus = LoadingStatus.RELOADING;
      this.loadHomePage(LoadStatus.LOAD);
    }
  };
  public onRefreshStateChange = (state: RefreshStatus): void => {
    this.refreshStatus = state;
    if (state === RefreshStatus.Refresh) {
      this.loadHomePage(LoadStatus.REFRESH);
    }
  };
  private initSearchSuggestionCarousel = (): void => {
    this.searchSuggestionCarouselLogic.modifyCurrentDisplay('请输入搜索内容');
    this.searchSuggestionCarouselLogic.setSelectEventCallback((key: string) => {
      cache.search.placeholder = key;
      routerStack.pushPathByName('ProductSearchPage', null);
    });
  };
  private loadHomePage = async (intent: LoadStatus): Promise<void> => {
    try {
      const result = await Promise.all([
        client.search.getSuggestions(),
        client.homepage.getHomeCoreData(),
        client.cardList.getGuessLike(0),
      ]);
      const suggestions: string[] | null = result[0];
      const home: Home | null = result[1];
      const guessLike: GuessLike | null = result[2];
      if (suggestions && home && guessLike) {
        this.updateSearchSuggestionCarousel(suggestions);
        this.categoryList = home.categoryList;
        this.loadingStatus = LoadingStatus.SUCCESS;
      } else {
        throw new Error();
      }
    } catch (e) {
      if (intent === 'load') {
        this.loadingStatus = LoadingStatus.FAIL;
      }
    }
    this.isRefreshing = false;
  };

  private updateSearchSuggestionCarousel(suggestions: string[]): void {
    this.searchSuggestionCarouselLogic.setSuggestionData(suggestions, true);
    if (this.global.isNavPathStackEmpty && iData.global.rootPageActiveTabId === 'HomePage') {
      this.searchSuggestionCarouselLogic.start();
    }
  }

  jumpToCategoryPage(id: string) {
    routerStack.pushPathByName(RouterMap.PRODUCT_CATEGORY, id);
  }

  constructor() {
    this.initSearchSuggestionCarousel();
    this.loadHomePage(LoadStatus.LOAD);
  }
}
