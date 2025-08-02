import { ColumnModifier, ListItemModifier, ListModifier, RowModifier } from '@kit.ArkUI';

class ContainerModifier implements AttributeModifier<RowModifier | ColumnModifier | ListModifier | ListItemModifier> {
  public applyNormalAttribute(instance: CommonAttribute): void {
    instance
      .padding(12)
      .borderRadius(16)
      .backgroundColor('#ffffff')
      .width('100%');
  }
}

class ContainerModifierCalcWidth implements AttributeModifier<RowModifier | ColumnModifier | ListModifier |
ListItemModifier> {
  public applyNormalAttribute(instance: CommonAttribute): void {
    instance
      .padding(12)
      .borderRadius(16)
      .backgroundColor('#ffffff')
      .width('calc(100% - 32vp)');
  }
}

export const CONTAINER_STYLE: ContainerModifier = new ContainerModifier();

export const CONTAINER_STYLE_CALC_WIDTH: ContainerModifierCalcWidth = new ContainerModifierCalcWidth();