import { display, UIContext, window } from '@kit.ArkUI';
import { Logger } from './Logger';

const TAG = '[WindowUtil]';

@ObservedV2
export class AvoidAreaSize {
  @Trace top: number = 0;
  @Trace bottom: number = 0;
}

@ObservedV2
export class WindowUtil {
  private static _avoidAreaSize: AvoidAreaSize = new AvoidAreaSize();

  public static get avoidAreaSize() {
    return WindowUtil._avoidAreaSize;
  }

  private static _mainWindow: window.Window;

  public static get mainWindow() {
    return WindowUtil._mainWindow;
  }

  private static _display: display.Display;

  public static get display(): display.Display {
    return WindowUtil._display;
  }

  private static _context: Context | undefined;

  public static get context(): Context | undefined {
    return WindowUtil._context;
  }

  private static _uiContext: UIContext;

  public static get uiContext(): UIContext {
    return WindowUtil._uiContext;
  }

  public static get promptAction() {
    return WindowUtil._uiContext.getPromptAction();
  }

  public static async initWindowUtil(mainWindow: window.Window) {
    try {
      WindowUtil._mainWindow = mainWindow;
      WindowUtil._uiContext = mainWindow.getUIContext();
      WindowUtil._context = mainWindow.getUIContext().getHostContext();
      WindowUtil._display = display.getDefaultDisplaySync();
      if (WindowUtil._mainWindow && WindowUtil._uiContext) {
        const systemArea = WindowUtil._mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        WindowUtil._avoidAreaSize.top = WindowUtil._uiContext.px2vp(systemArea.topRect.height);
        const bottomArea = WindowUtil._mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        WindowUtil._avoidAreaSize.bottom = WindowUtil._uiContext.px2vp(bottomArea.bottomRect.height);
      }
    } catch (err) {
      Logger.error(TAG, 'init window util failed. error:' + JSON.stringify(err));
    }
  }
}
