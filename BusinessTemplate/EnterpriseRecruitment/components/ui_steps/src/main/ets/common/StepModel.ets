/**
 * 选项
 */
@ObservedV2
export class OptionsModel {
  title: string = '';
  isPassed ?: boolean;
  @Trace stepWidth: Length = ''
  constructor(title: string, isPassed ?: boolean) {
    this.title = title
    this.isPassed = isPassed
  }
}

@ObservedV2
export class ComponentSizeModel {
  @Trace width: Length = 0
  @Trace heigth: Length = 0
}