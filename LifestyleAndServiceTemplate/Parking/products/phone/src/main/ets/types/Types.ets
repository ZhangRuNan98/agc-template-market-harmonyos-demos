export interface TabListItem {
  label: string;
  icon: Resource;
  iconChecked: Resource;
  component: WrappedBuilder<[]>;
}

@ObservedV2
export class FormModel {
  @Trace license: string = '';
  @Trace url: string = '';
}