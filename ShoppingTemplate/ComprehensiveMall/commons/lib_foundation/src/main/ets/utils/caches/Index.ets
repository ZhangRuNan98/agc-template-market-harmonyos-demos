class Product {
  public id: string = '';
}

class Search {
  public placeholder: string = '';
  public lastSubmit: string = '';
}

class Cache {
  public search: Search = new Search();
  public product: Product = new Product();
}

export const cache: Cache = new Cache();
