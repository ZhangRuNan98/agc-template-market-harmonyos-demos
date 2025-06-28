import { AppStorageV2, window } from '@kit.ArkUI';

@ObservedV2
export class AvoidAreaSize {
  @Trace top: number = 0;
  @Trace bottom: number = 0;
}

@ObservedV2
export class WindowUtil {
  private static _avoidAreaSize: AvoidAreaSize = AppStorageV2.connect(AvoidAreaSize, () => new AvoidAreaSize())!;

  public static get avoidAreaSize() {
    return WindowUtil._avoidAreaSize;
  }

  private static _currentWindow: window.Window;

  public static get currentWindow() {
    return WindowUtil._currentWindow;
  }

  public static async initWindowUtil() {
    await WindowUtil.getCurrentWindow();
    WindowUtil.getWindowAvoidArea();
  }

  public static getWindowAvoidArea() {
    if (WindowUtil._currentWindow) {
      const systemArea = WindowUtil._currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      WindowUtil._avoidAreaSize.top = px2vp(systemArea.topRect.height);
      const bottomArea = WindowUtil._currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      WindowUtil._avoidAreaSize.bottom = px2vp(bottomArea.bottomRect.height);
    }
  }

  private static async getCurrentWindow() {
    await window
      .getLastWindow(getContext())
      .then((win) => {
        WindowUtil._currentWindow = win
      })
  }
}





