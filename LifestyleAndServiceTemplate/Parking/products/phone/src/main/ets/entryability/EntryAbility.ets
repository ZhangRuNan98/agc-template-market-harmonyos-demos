import { UIAbility, Want } from '@kit.AbilityKit';
import { AppStorageV2, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
export class FormModel {
  @Trace license: string = '';
  @Trace url: string = '';
}

const TAG = '[EntryAbility]';

export default class EntryAbility extends UIAbility {
  public onCreate(want: Want): void {
    this._processWant(want);
  }

  public onNewWant(want: Want): void {
    this._processWant(want);
  }

  public onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/MainEntry', (err) => {
      if (err.code) {
        hilog.error(0xff00, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(0xff00, TAG, 'Succeeded in loading the content.');
    });
  }

  private _processWant(want: Want) {
    if (want?.parameters?.params) {
      try {
        let params: Record<string, string> = JSON.parse(want.parameters.params as string);
        let formInfo: FormModel = AppStorageV2.connect(FormModel, () => new FormModel())!;
        formInfo.url = params.targetPage as string;
        formInfo.license = params.license as string;
      } catch (error) {
        hilog.error(0xff00, TAG, 'Failed to get params. Cause: %{public}s', JSON.stringify(error));
      }
    }
  }
}