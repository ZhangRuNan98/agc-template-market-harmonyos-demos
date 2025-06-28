import { LengthMetrics } from '@kit.ArkUI';
import { BuildTitleBar, WindowUtil } from 'commonlib';
import { CitySearchController, UICitySelect } from 'module_city_select';
import { AllCityPageVM } from '../viewModels/AllCityPageVM';


@Builder
export function AllCityPageBuilder() {
  AllCityPage();
}


@ComponentV2
struct AllCityPage {
  controller: CitySearchController = new CitySearchController();
  vm: AllCityPageVM = AllCityPageVM.instance;

  build() {

    NavDestination() {
      Column() {
        UICitySelect({
          currentCity: this.vm.currentCity.cityName,
          emitUpdateCityLocation: (city: string) => {
            if (city) {
              this.vm.handleCitySelect(city);
            }
          },
          goBack: (city: string | undefined) => {
            if (city) {
              this.vm.handleCitySelect(city);
            }
          },
        });
      }.height('100%').width('100%');

    }.title(BuildTitleBar('选择城市'), { paddingStart: LengthMetrics.vp(16) }).onBackPressed(() => {
      return this.controller.onBackPressed();
    }).padding({ top: WindowUtil.avoidAreaSize.top, bottom: WindowUtil.avoidAreaSize.bottom });

  }
}

