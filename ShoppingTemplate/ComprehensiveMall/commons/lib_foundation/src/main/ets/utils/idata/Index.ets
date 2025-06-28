import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI';
import { GlobalStateMgr } from './GlobalStateMgr';
import { Persistence } from './Persistence';

@ObservedV2
class IData {
  @Trace
  public readonly global: GlobalStateMgr = AppStorageV2.connect(
    GlobalStateMgr,
    'GlobalStateMgr',
    () => new GlobalStateMgr(),
  )!;
  @Trace
  public readonly local: Persistence = PersistenceV2.connect(
    Persistence,
    'Persistence',
    () => new Persistence(),
  )!;
}

const iData: IData = new IData();

export { iData, GlobalStateMgr };
