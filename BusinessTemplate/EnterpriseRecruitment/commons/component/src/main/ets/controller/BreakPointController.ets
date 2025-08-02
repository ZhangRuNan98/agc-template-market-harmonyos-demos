@ObservedV2
export class BreakPointController {
  private static _instance: BreakPointController;

  public static get instance() {
    if (!BreakPointController._instance) {
      BreakPointController._instance = new BreakPointController();
    }
    return BreakPointController._instance;
  }

  @Trace currentBreakPoint: BreakPoint = BreakPoint.SM;

  @Trace informationBarWidth: number = 150;
  @Trace jobBarPadding: number = 20;
  @Trace jobUpLoad: number = 75;

  @Monitor('currentBreakPoint')
  onBreakPointChange(){
    if (this.currentBreakPoint === BreakPoint.SM) {
      this.informationBarWidth = 150
      this.jobBarPadding = 20
      this.jobUpLoad = 75;
    } else if (this.currentBreakPoint === BreakPoint.MD){
      this.informationBarWidth = 300
      this.jobBarPadding = 60
      this.jobUpLoad = 90;
    }
  }
}

export enum BreakPoint {
  SM,
  MD,
}