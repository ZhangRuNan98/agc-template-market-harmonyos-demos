export interface UserInfo {
  id: number;
  avatar: string;
  name: string;
  nickname: string;
  sex: string;
  cellphone: string;
  birthday: string;
  code: string;
  isLogin: boolean;
}




@ObservedV2
export class DecorationInfo {
  @Trace address: string = '';
  @Trace cellName: string = '';
  @Trace area: string = '';
  @Trace room: string = '';
  @Trace hall: string = '';
  @Trace washroom: string = '';
  @Trace kitchen: string = '';
  @Trace balcony: string = '';
  @Trace homeType: string = '0';

  public upDateInfo(data: DecorationInfo) {
    this.address = data.address;
    this.cellName = data.cellName;
    this.area = data.area;
    this.room = data.room;
    this.hall = data.hall;
    this.washroom = data.washroom;
    this.kitchen = data.kitchen;
    this.balcony = data.balcony;
    this.homeType = data.homeType;
  }


  public initInfo() {
    this.address = '';
    this.cellName = '';
    this.area = '';
    this.room = '';
    this.hall = '';
    this.washroom = '';
    this.kitchen = '';
    this.balcony = '';
    this.homeType = '0';
  }
}


@ObservedV2
export class CurrentCity {
  @Trace cityName: string = '南京';
  @Trace isSelect: boolean = false;
}






@ObservedV2
export class ObservedArray<T> extends Array<T> {
  constructor(args?: T[]) {
    if (args instanceof Array) {
      super(...args);
    } else {
      super();
    }
  }
}

export class DataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return this.originDataArray.length;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number, count: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{ type: DataOperationType.ADD, index, count }]);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number, count: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{ type: DataOperationType.DELETE, index, count }]);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }

  clear(): void {
    this.originDataArray.splice(0, this.originDataArray?.length)
  }

  // 在数组末尾，批量插入数据
  pushArrData(data: ObservedArray<T>): void {
    this.clear();
    this.originDataArray.push(...data);
    this.notifyDataReload();
  }
}