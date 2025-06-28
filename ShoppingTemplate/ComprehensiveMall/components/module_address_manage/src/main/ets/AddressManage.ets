import { RouteMap } from './common/CommonConst';
import { Context } from './common/Context';
import { AddressDTO } from './model/AddressDTO';

@ComponentV2
export struct AddressManage {

  @BuilderParam
  private contentBuilder: () => void = buildEmptyComponent;

  @Param
  public navPathStack: NavPathStack = new NavPathStack();

  @Param
  public isSelectMode: boolean = false;

  @Event
  public onSelect: (address: AddressDTO) => void = () => {};

  @Event
  public onBeforeNavigate: () => boolean = () => true;

  private readonly ctx: Context = new Context();

  public aboutToAppear(): void {
    this.ctx.navPathStack = this.navPathStack;
    this.ctx.isSelectMode = this.isSelectMode;
    this.ctx.onSelect = this.onSelect;
  }

  @Monitor('navPathStack', 'isSelectMode', 'onSelect')
  public onAttributeChange(iMonitor: IMonitor): void {
    for (let k of iMonitor.dirty) {
      let v: IMonitorValue<ESObject> | undefined = iMonitor.value<ESObject>(k);
      if (v) {
        switch (k) {
          case 'navPathStack':
            this.ctx.navPathStack = v.now as NavPathStack;
            break;
          case 'isSelectMode':
            this.ctx.isSelectMode = v.now as boolean;
            break;
          case 'onSelect':
            this.ctx.onSelect = v.now as (address: AddressDTO) => void;
            break;
        }
      }
    }
  }

  public build(): void {
    Column() {
      this.contentBuilder();
    }
    .width('auto')
    .height('auto')
    .onClick(() => {
      if (this.onBeforeNavigate()) {
        this.navPathStack.pushPathByName(RouteMap.ADDRESS_MANAGE_PAGE, this.ctx);
      }
    })
  }

}

@Builder
function buildEmptyComponent() {
  // No need to do anything
}
