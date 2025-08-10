import { Category } from './Model';

export function initCategoryList(): Array<Category>{
  let categoryList: Array<Category> = [];
  categoryList.push(new Category('全部笔记', 0, '-1',));
  return categoryList;
}


