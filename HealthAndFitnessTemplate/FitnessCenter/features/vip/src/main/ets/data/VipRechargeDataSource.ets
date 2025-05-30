import { VipRechargeItem } from '../bean/VipRechargeItem';
import { BasicDataSource } from '../data/BasicDataSource';

export class VipRechargeDataSource extends BasicDataSource {
  private dataArray: VipRechargeItem[] = [];

  public getIndex(inputItem: VipRechargeItem): number {
    return this.dataArray.findIndex(item => {
      item.getPayNumber() === inputItem.getPayNumber() && item.getDiscounts() === inputItem.getDiscounts()
    })
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): VipRechargeItem {
    return this.dataArray[index];
  }

  public pushData(data: VipRechargeItem): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public updateAllData(): void {
    this.dataArray = this.dataArray.map((item: VipRechargeItem) => {
      return item;
    });
    this.notifyDataReload();
  }
}