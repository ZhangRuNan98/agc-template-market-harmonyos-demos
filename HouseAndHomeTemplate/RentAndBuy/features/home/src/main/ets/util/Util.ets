import { HouseType, IBasicHouse, ILayout } from 'foundation';
import { Layout } from '../model/Index';

// 首页相关Util
export class Util {
  /**
   * 获取房屋面积
   * @param house
   * @returns
   */
  static getHouseSpace(house: IBasicHouse) {
    let space: string = `${house.space[0]}`;
    if (house.type === HouseType.NEW) {
      space = `${house.space[0]}~${house.space[1]}`;
    }
    return space;
  }

  /**
   * 获取户型面积
   * @param house
   * @returns
   */
  static getLayoutInfo(house: IBasicHouse) {
    return `${house.bedroom}室${house.lounge}厅/${Util.getHouseSpace(house)}㎡/${house.orientation}`;
  }

  /**
   * 获取户型信息
   * @param house
   * @returns
   */
  static getFullLayout(house: IBasicHouse) {
    return `${house.bedroom}室${house.lounge}厅${house.bathroom}卫`;
  }

  /**
   * 获取房屋总价
   * @param house
   * @returns
   */
  static getHouseTotal(house: IBasicHouse) {
    let total: string = `${house.total[0]}`;
    if (house.type === HouseType.NEW) {
      total = `${house.total[0]}万~${house.total[1]}万`;
    }
    return total;
  }

  /**
   * 获取房型分类列表
   * @param layouts
   * @returns
   */
  static getLayoutList(layouts: ILayout[]) {
    let map: Map<number, ILayout[]> = new Map();
    // 记录所有房型个数
    map.set(0, layouts);
    layouts.forEach((item: ILayout) => {
      let current = map.get(item.bedroom) ?? [];
      current.push(item);
      map.set(item.bedroom, current);
    });
    let layOutList: Layout[] = [];
    for (let i of map.keys()) {
      layOutList.push({
        bedroomCount: i,
        layouts: map.get(i),
      } as Layout);
    }
    return layOutList;
  }
}