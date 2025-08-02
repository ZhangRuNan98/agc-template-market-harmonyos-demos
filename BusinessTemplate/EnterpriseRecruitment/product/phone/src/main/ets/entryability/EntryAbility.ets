import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppStorageV2, display, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AvoidArea, BreakPoint, BreakPointController } from '@ohos_agcit/common_component';


export default class EntryAbility extends UIAbility {
  private breakPointController: BreakPointController = BreakPointController.instance;
  private updateBreakpoint(windowWidth: number): void {
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    if (windowWidthVp < 600) {
      this.breakPointController.currentBreakPoint = BreakPoint.SM
    } else if (windowWidthVp < 840) {
      this.breakPointController.currentBreakPoint = BreakPoint.MD
    }
    // else {
    //   this.breakPointController.currentBreakPoint = 'lg';
    // }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 获取UIAbility实例的上下文
    let context = this.context;
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  private windowObj?: window.Window;
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.getMainWindow().then((windowObj) => {
      this.windowObj = windowObj;
      this.updateBreakpoint(windowObj.getWindowProperties().windowRect.width);
      windowObj.on('windowSizeChange', (windowSize) => {
        this.updateBreakpoint(windowSize.width);
      })
    });

    let windowClass: window.Window | undefined = undefined;
    windowStage.getMainWindow((err: BusinessError, data) => {
      const errCode: number = err.code;
      if (errCode) {
        console.error(`Failed to obtain the main window. Cause code: ${err.code}, message: ${err.message}`);
        return;
      }
      windowClass = data;
      let isLayoutFullScreen = true;
      try {
        let promise = windowClass.setWindowLayoutFullScreen(isLayoutFullScreen);
        promise.then(() => {
          console.info('Succeeded in setting the window layout to full-screen mode.');
        }).catch((err: BusinessError) => {
          console.error(`Failed to set the window layout to full-screen mode. Cause code: ${err.code}, message: ${err.message}`);
        });
      } catch (exception) {
        console.error(`Failed to set the window layout to full-screen mode. Cause code: ${exception.code}, message: ${exception.message}`);
      }
    });

    // Load Index
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }

      // 获取当前布局遮挡区域
      let windowClass: window.Window = windowStage.getMainWindowSync();
      let isLayoutFullScreen = true;
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen).then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      }).catch((err: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });

      // 导航条与状态栏避让
      let topAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      let topRectHeight = topAvoidArea.topRect.height; // 获取状态栏区域高度
      let bottomAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      let bottomRectHeight = bottomAvoidArea.bottomRect.height; // 获取到导航条区域的高度
      AppStorageV2.connect(AvoidArea, () => new AvoidArea(topRectHeight, bottomRectHeight));

      // 注册监听函数，动态获取避让区域数据
      windowClass.on('avoidAreaChange', (data) => {
        let avoidArea: AvoidArea = AppStorageV2.connect(AvoidArea, () => new AvoidArea(0, 0))!;
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          avoidArea.topRectHeight = data.area.topRect.height;
        } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          avoidArea.bottomRectHeight = data.area.bottomRect.height;
        }
      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}

