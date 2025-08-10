import { BaseNewsService } from './BaseNewsService';

/**
 * 新闻-文章类
 */
export class ArticleService extends BaseNewsService {

}

const instance = new ArticleService();

export { instance as ArticleServiceApi };