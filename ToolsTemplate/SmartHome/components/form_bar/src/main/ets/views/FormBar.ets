import { AccessSettingBarView } from '../components/AccessSettingBarView';
import { ImageSettingBarView } from '../components/ImageSettingBarView';
import { NavBarView } from '../components/NavBarView';
import { TextSettingBarView } from '../components/TextSettingBarView';
import { TextShowBarView } from '../components/TextShowBarView';
import { FormType } from '../model/FormType';

@ComponentV2
export struct FormBar {
  @Require @Param formType: FormType
  @Param startImage?: ResourceStr = '';
  @Require @Param name: string = '';
  @Param value?: ResourceStr = '';
  @Param valueChangeCb?: (value: ResourceStr) => void = ()=>{};
  @Param pathStack: NavPathStack = new NavPathStack();
  @Param pageName?: string = '';
  @Param maxLength?: number = 8

  build() {
    if (this.formType === FormType.ACCESS_SETTING) {
      AccessSettingBarView({
        startImage: this.startImage,
        name: this.name,
        value: this.value as string
      })
    } else if (this.formType === FormType.IMAGE_SETTING) {
      ImageSettingBarView({
        startImage: this.startImage,
        name: this.name,
        value: this.value,
        valueChangeCb: this.valueChangeCb
      })
    } else if (this.formType === FormType.NAV) {
      NavBarView({
        startImage: this.startImage,
        text: this.name,
        pathStack: this.pathStack,
        pageName: this.pageName
      })
    } else if (this.formType === FormType.TEXT_SETTING) {
      TextSettingBarView({
        startImage: this.startImage,
        maxLength: this.maxLength,
        name: this.name,
        value: this.value as string,
        valueChangeCb: this.valueChangeCb
      })
    } else if (this.formType === FormType.TEXT_SHOW) {
      TextShowBarView({
        startImage: this.startImage,
        name: this.name,
        value: this.value as string
      })
    }
  }
}