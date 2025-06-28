import { common } from '@kit.AbilityKit';
import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { getCascadeInfo } from '../utils/CascaderUtils';
import { HomeLayout, DecorationData, TypeOption } from '../types/Index';


@ComponentV2
export struct FormDecoration {
  @Param buttonText: string = '保存资料';
  @Param typeOptions: TypeOption[] =
    [{ label: '高层', value: '0', desc: '高于7层' }, { label: '混砖', value: '1', desc: '低于7层' }];
  @Param @Once homeType: string = this.typeOptions[0].value;
  @Param @Once address: string = '';
  @Param @Once cellName: string = '';
  @Param @Once area: string = '';
  @Param @Once homeLayout: HomeLayout = {
    room: '',
    hall: '',
    washroom: '',
    kitchen: '',
    balcony: '',
  };
  @Local countNumber: number = 3000;
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @Event onFormSubmit: (data: DecorationData) => void = () => {

  };

  isDecorationValid(): boolean {
    if (!this.address) {
      promptAction.showToast({ message: '请选择小区地区！' });
      return false;
    }
    if (!this.area) {
      promptAction.showToast({ message: '请填写房屋面积！' });
      return false;
    }
    if (Number(this.area) < 5) {
      promptAction.showToast({ message: '房屋面积至少为5㎡！' });
      return false;
    }
    if (!this.homeLayout.room) {
      promptAction.showToast({ message: '请完整填写户型！' });
      return false;
    }
    if (Number(this.homeLayout.room) < 1) {
      promptAction.showToast({ message: '卧室数至少为1！' });
      return false;
    }
    if (!this.homeLayout.hall) {
      promptAction.showToast({ message: '请完整填写户型！' });
      return false;
    }
    if (!this.homeLayout.washroom) {
      promptAction.showToast({ message: '请完整填写户型！' });
      return false;
    }
    if (!this.homeLayout.kitchen) {
      promptAction.showToast({ message: '请完整填写户型！' });
      return false;
    }

    if (!this.homeLayout.balcony) {
      promptAction.showToast({ message: '请完整填写户型！' });
      return false;
    }

    return true;
  }

  build() {
    Column({ space: 16 }) {
      Column({ space: 8 }) {
        this.BaseTitle('房屋类型');
        Grid() {
          ForEach(this.typeOptions, (item: TypeOption) => {
            GridItem() {
              Row() {
                Radio({ value: item.value, group: 'homeType' })
                  .checked(this.homeType === item.value)
                  .radioExtend()
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.homeType = item.value;
                    }
                  });
                Text(item.label)
                  .baseTextExtend();
                Text(`（${item.desc}）`)
                  .subTextExtend();

              };
            };
          }, (item: TypeOption) => item.value);
        }.columnsGap(0)
        .rowsGap(12);
      }.alignItems(HorizontalAlign.Start).width('100%');

      Column({ space: 8 }) {
        this.BaseTitle('小区地区');
        Row({ space: 8 }) {
          Image($r('app.media.ic_public_gps_filled')).width(16).margin({ bottom: 6 });

          Text(this.address || '请选择小区所在省市区')
            .layoutWeight(1)
            .padding({
              left: 0,
              right: 0,
              top: 0,
              bottom: 5,
            })
            .border({
              width: {
                bottom: 1,
              },
              color: $r('sys.color.comp_divider'),
            })
            .fontColor(this.address === '' ? $r('sys.color.font_tertiary') : $r('sys.color.font_primary'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Regular);
          Image($r('app.media.ic_designer_right')).width(16).height(16);
        };
      }.alignItems(HorizontalAlign.Start).width('100%').onClick(() => {
        getCascadeInfo(this.context).then((res) => {
          this.address = res;
        });
      });

      Column({ space: 8 }) {
        this.BaseTitle('小区名称', false);
        Row({ space: 8 }) {
          Image($r('app.media.form_home_name')).width(16);
          TextInput({ placeholder: '请输入小区名称', text: this.cellName })
            .inputExtend()
            .onChange((res) => {
              this.cellName = res;
            });
          Row().width(16).height(16);
        };
      }.alignItems(HorizontalAlign.Start).width('100%');

      Column({ space: 8 }) {
        this.BaseTitle('房屋面积');
        Row({ space: 8 }) {
          Image($r('app.media.form_home_name')).width(16);
          TextInput({ placeholder: '请输入房屋面积', text: this.area })
            .type(InputType.Number)
            .inputExtend()
            .onChange((res) => {
              this.area = res;
            });
          Text('㎡')
            .width(16)
            .height(16)
            .fontColor($r('sys.color.font_primary'))
            .fontSize($r('sys.float.Body_M'))
            .fontWeight(FontWeight.Medium);
        };
      }.alignItems(HorizontalAlign.Start).width('100%');

      Column({ space: 8 }) {
        this.BaseTitle('房屋户型');
        Row({ space: 8 }) {
          Image($r('app.media.form_home_type')).width(16);
          Grid() {
            GridItem() {
              Column() {
                Row() {
                  TextInput({ text: this.homeLayout.room })
                    .emptyInputExtend()
                    .onChange((res) => {
                      this.homeLayout.room = res;
                    });
                  Text('室')
                    .unitTextExtend();

                }.width('100%');

                Divider().width('100%');
              }.width(72).height(34);
            };

            GridItem() {
              Column() {
                Row() {
                  TextInput({ text: this.homeLayout.hall })
                    .emptyInputExtend()
                    .onChange((res) => {
                      this.homeLayout.hall = res;
                    });
                  Text('厅')
                    .unitTextExtend();

                }.width('100%');

                Divider().width('100%');
              }.width(72).height(34);
            };

            GridItem() {
              Column() {
                Row() {
                  TextInput({ text: this.homeLayout.washroom })
                    .emptyInputExtend()
                    .onChange((res) => {
                      this.homeLayout.washroom = res;
                    });
                  Text('卫')
                    .unitTextExtend();

                }.width('100%');

                Divider().width('100%');
              }.width(72).height(34);
            };

            GridItem() {
              Column() {
                Row() {
                  TextInput({ text: this.homeLayout.kitchen })
                    .emptyInputExtend()
                    .onChange((res) => {
                      this.homeLayout.kitchen = res;
                    });
                  Text('厨')
                    .unitTextExtend();

                }.width('100%');

                Divider().width('100%');
              }.width(72).height(34);
            };

            GridItem() {
              Column() {
                Row() {
                  TextInput({ text: this.homeLayout.balcony })
                    .emptyInputExtend()
                    .width(44)
                    .onChange((res) => {
                      this.homeLayout.balcony = res;
                    });
                  Text('阳台')
                    .unitTextExtend()
                    .width(28);
                }.width('100%');

                Divider().width('100%');
              }.width(72).height(34);
            };
          }.columnsTemplate('1fr 1fr 1fr')
          .rowsGap(8)
          .height(76);
        }.alignItems(VerticalAlign.Top);
      }.alignItems(HorizontalAlign.Start).width('100%');

      Column({ space: 8 }) {
        Button(this.buttonText).height(40).backgroundColor($r('sys.color.alert')).width('100%').onClick(() => {
          if (this.isDecorationValid()) {
            const data: DecorationData = {
              homeLayout: this.homeLayout,
              homeType: this.homeType,
              address: this.address,
              area: this.area,
              cellName: this.cellName,
            };
            this.homeLayout.room = Number(this.homeLayout.room).toString();
            this.homeLayout.hall = Number(this.homeLayout.hall).toString();
            this.homeLayout.washroom = Number(this.homeLayout.washroom).toString();
            this.homeLayout.kitchen = Number(this.homeLayout.kitchen).toString();
            this.homeLayout.balcony = Number(this.homeLayout.balcony).toString();
            this.area = Number(this.area).toString();
            this.onFormSubmit(data);
          }
        });
        Text() {
          Span('已有');
          Span(this.countNumber + '+').fontColor($r('sys.color.alert'));
          Span('业主获取过装修预算报价');
        }.fontWeight(FontWeight.Regular).fontSize($r('sys.color.font_tertiary')).fontSize($r('sys.float.Caption_M'));
      }.padding({ top: 8 }).width('100%');

    }
    .padding({
      left: 12,
      right: 12,
      top: 12,
      bottom: 16,
    })
    .width('100%')
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16);
  }

  @Builder
  BaseTitle(title: string, isRequire: boolean = true) {
    Row({ space: 4 }) {
      Text('*')
        .visibility(isRequire ? Visibility.Visible : Visibility.Hidden)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.multi_color_08'))
        .fontWeight(FontWeight.Medium)
        .margin({ top: 2 });
      Text(title)
        .height(19)
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Medium);
    }.height(19).alignItems(VerticalAlign.Top);
  }
}

@Extend(TextInput)
function emptyInputExtend() {
  .fontColor($r('sys.color.font_primary'))
  .fontSize($r('sys.float.Body_M'))
  .fontWeight(FontWeight.Regular)
  .width(54)
  .padding(0)
  .height(33)
  .backgroundColor('transparent')
  .borderRadius(0)
  .type(InputType.Number);
}

@Extend(Text)
function unitTextExtend() {
  .fontColor($r('sys.color.font_secondary'))
  .fontSize($r('sys.float.Body_M'))
  .fontWeight(FontWeight.Regular)
  .layoutWeight(1);
}

@Extend(TextInput)
function inputExtend() {
  .layoutWeight(1)
  .padding({
    left: 0,
    right: 0,
    top: 0,
    bottom: 5,
  })
  .border({
    width: {
      bottom: 1,
    },
    color: $r('sys.color.comp_divider'),
  })
  .borderRadius(0)
  .placeholderColor($r('sys.color.font_tertiary'))
  .placeholderFont({
    size: $r('sys.float.Body_M'),
    weight: FontWeight.Regular,
  })
  .fontColor($r('sys.color.font_primary'))
  .fontSize($r('sys.float.Body_M'))
  .fontWeight(FontWeight.Regular)
  .backgroundColor('transparent');
}


@Extend(Text)
function subTextExtend() {
  .fontColor($r('sys.color.font_secondary'))
  .fontSize($r('sys.float.Body_M'))
  .fontWeight(FontWeight.Regular)
  .width(78)
  .textAlign(TextAlign.Center);
}

@Extend(Text)
function baseTextExtend() {
  .fontColor($r('sys.color.font_primary'))
  .fontSize($r('sys.float.Body_M'))
  .fontWeight(FontWeight.Regular);
}

@Extend(Radio)
function radioExtend() {
  .radioStyle({
    checkedBackgroundColor: $r('sys.color.alert'),
  })
  .width(13)
  .height(13)
  .margin({ right: 8 });
}
