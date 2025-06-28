import { LengthMetrics } from '@kit.ArkUI';
import { BuildTitleBar, WindowUtil } from 'commonlib';
import {FormDecoration} from 'module_decoration_form'
import { MyDecorationInfoVM } from '../viewModels/MyDecorationInfoVM';



@Builder
export function MyDecorationInfoBuilder() {
  MyDecorationInfo();
}

@ComponentV2
struct RowWrapper {
  @Param label: string = '';
  @Param verticalAlign: VerticalAlign = VerticalAlign.Center;
  @BuilderParam contentBuilderParam: () => void;

  build() {
    Row({ space: 12 }) {
      Text(this.label).width(70);
      Row() {
        this.contentBuilderParam();
      }.layoutWeight(1);
    }.width('100%').alignItems(this.verticalAlign);
  }
}


@ComponentV2
struct MyDecorationInfo {
  vm: MyDecorationInfoVM = MyDecorationInfoVM.instance;

  aboutToAppear(): void {
    this.vm.cloneDecorationInfo();
  }

  build() {
    NavDestination() {

      Scroll() {
        Column({ space: 10 }) {
          FormDecoration({
            homeType: this.vm.newDecorationInfo.homeType,
            homeLayout: {
              room: this.vm.newDecorationInfo.room,
              hall: this.vm.newDecorationInfo.hall,
              washroom: this.vm.newDecorationInfo.washroom,
              kitchen: this.vm.newDecorationInfo.kitchen,
              balcony: this.vm.newDecorationInfo.balcony,
            },
            address: this.vm.newDecorationInfo.address,
            cellName: this.vm.newDecorationInfo.cellName,
            area: this.vm.newDecorationInfo.area,
            onFormSubmit: (data) => {
              this.vm.newDecorationInfo.address = data.address;
              this.vm.newDecorationInfo.cellName = data.cellName;
              this.vm.newDecorationInfo.area = data.area;
              this.vm.newDecorationInfo.homeType = data.homeType;
              this.vm.newDecorationInfo.room = data.homeLayout.room;
              this.vm.newDecorationInfo.hall = data.homeLayout.hall;
              this.vm.newDecorationInfo.washroom = data.homeLayout.washroom;
              this.vm.newDecorationInfo.kitchen = data.homeLayout.kitchen;
              this.vm.newDecorationInfo.balcony = data.homeLayout.balcony;
              this.vm.upDateDecorationInfo();
            },
          });
        }.padding({ left: 16, right: 16, top: 12 });

      }
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .height('100%')
      .backgroundColor($r('sys.color.background_secondary'));

    }
    .title(BuildTitleBar('我的装修信息'), { paddingStart: LengthMetrics.vp(16) })
    .padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });

  }
}


