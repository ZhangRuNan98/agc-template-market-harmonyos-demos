import util from '@ohos.util';
import { cache } from 'lib_foundation';
import { routerStack } from 'lib_foundation';
import { client } from 'lib_network';

@ObservedV2
export class ProductSearchPageLogic {
  @Trace
  public placeholder: string = '请输入搜索内容';

  @Trace
  public isShowCandidate: boolean = false;

  @Trace
  public candidateWords: string[] = [];

  @Trace
  public keyWord: string = '';

  @Trace
  public submit: string = '';

  public readonly SEARCH_ID: string = util.generateRandomUUID(false);

  public controller: SearchController = new SearchController();

  public onClickBack = (): void => {
    routerStack.pop();
  };

  public onChange = (value: string, _?: PreviewText): void => {
    if (value === '') {
      this.isShowCandidate = false;
    } else {
      client.search.getCandidateWords(value).then((words: string[]) => {
        this.candidateWords = words;
        this.keyWord = value;
        this.isShowCandidate = true;
      });
    }
  };

  public onSubmit = (value: string): void => {
    const key: string = value === '' ? this.placeholder : value;
    if (key !== '请输入搜索内容' && key !== '') {
      cache.search.lastSubmit = key;
      routerStack.pushPathByName('ProductSearchResultsPage', null, false);
    }
  };

  public onShown = (ctx: UIContext): void => {
    this.submit = cache.search.lastSubmit;
    ctx.getFocusController().requestFocus(this.SEARCH_ID);
  };

  constructor() {
    if (cache.search.placeholder !== '') {
      this.placeholder = cache.search.placeholder;
    }
    cache.search.lastSubmit = '';
  }
}
