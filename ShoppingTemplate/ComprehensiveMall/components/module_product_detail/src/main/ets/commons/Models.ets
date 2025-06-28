@ObservedV2
export class SpecViewModel {
  @Trace specKey: string;
  @Trace id: string;
  @Trace value: string;
  @Trace image?: ResourceStr;
  @Trace isOutOfStock: boolean;
  @Trace isSelected: boolean;
  @Trace isTempOutOfStock: boolean = false;

  constructor(
    specKey: string,
    id: string,
    value: string,
    isOutOfStock: boolean,
    isSelected: boolean,
  ) {
    this.specKey = specKey;
    this.id = id;
    this.value = value;
    this.isOutOfStock = isOutOfStock;
    this.isSelected = isSelected;
  }
}
