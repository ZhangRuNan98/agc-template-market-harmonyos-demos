import { emitter } from '@kit.BasicServicesKit';
import { getServicePointList, IServicePoint, RouterModule } from 'lib_foundation';
import { RouterMap } from 'module_base';
import { promptAction } from '@kit.ArkUI';

@ObservedV2
export class ServicePointPageVM {
  private static _instance: ServicePointPageVM;
  @Trace public servicePointList: IServicePoint[] = []
  @Trace public selectedServicePoint: IServicePoint | undefined

  public static get instance() {
    if (!ServicePointPageVM._instance) {
      ServicePointPageVM._instance = new ServicePointPageVM();
    }
    return ServicePointPageVM._instance;
  }

  public async init() {
    const param = RouterModule.getNavParam<number>({ url: RouterMap.SERVICE_POINT_PAGE })
    this.getServicePointList(param)
  }

  public async getServicePointList(id?: number) {
    const res = await getServicePointList()
    this.servicePointList = res;
    if (id) {
      this.selectedServicePoint = this.servicePointList.find((item) => {
        return item.id === id
      })
    } else {
      this.selectedServicePoint = res[0]
    }
  }

  public save() {
    RouterModule.pop()
    let servicePoint: emitter.EventData = {
      data: this.selectedServicePoint
    };
    emitter.emit('servicePoint', servicePoint);
    promptAction.showToast({ message: '保存成功！' });
  }
}
