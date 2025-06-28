import axios, { AxiosInstance } from '@ohos/axios';

import { Config } from 'lib_foundation';
import { CardList } from './api/CardList';
import { Cart } from './api/Cart';
import { Homepage } from './api/Homepage';
import { Order } from './api/Order';
import { Product } from './api/Product';
import { Search } from './api/Search';
import { User } from './api/User';
import { MockServer } from './MockServer';

export class HttpClient {
  private axiosInstance: AxiosInstance = axios.create({
    baseURL: Config.API_BASE_URL,
    timeout: Config.REQUEST_TIMEOUT,
  });

  public search: Search = new Search(this.axiosInstance);

  public homepage: Homepage = new Homepage(this.axiosInstance);

  public cardList: CardList = new CardList(this.axiosInstance);

  public product: Product = new Product(this.axiosInstance);

  public user: User = new User(this.axiosInstance);

  public cart: Cart = new Cart(this.axiosInstance);

  public order: Order = new Order(this.axiosInstance);

  constructor() {
    if (Config.IS_DEV) {
      const server: MockServer = new MockServer(this.axiosInstance);
      server.start();
    }
  }
}
