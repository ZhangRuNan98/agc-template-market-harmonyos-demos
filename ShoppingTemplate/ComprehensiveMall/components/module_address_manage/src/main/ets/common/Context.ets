import { AddressDTO } from '../model/AddressDTO';
import { AddressMgrVM } from '../viewmodel/AddressMgrVM';
import { Operation } from './CommonConst';

@ObservedV2
export class Context {
  @Trace
  public navPathStack: NavPathStack = new NavPathStack();

  @Trace
  public isSelectMode: boolean = false;

  @Trace
  public onSelect: (address: AddressDTO) => void = () => {};

  @Trace
  public operation: Operation = Operation.CREATE;

  @Trace
  public addressMgr: AddressMgrVM = new AddressMgrVM();

  @Trace
  public editingAddressDTO: AddressDTO | null = null;
}
