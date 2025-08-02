import { CitySearchController, UICitySelect } from 'city_select';
import { CityList, Constant, https, RouterModule, TitleBar } from 'foundation';
import { HomeVM } from '../viewmodel/HomeVM';

@Builder
export function CitySelectBuilder() {
  CitySelect();
}

@ComponentV2
export struct CitySelect {
  vm: HomeVM = HomeVM.instance;
  @Local recentCityList: CityList = new CityList();
  @Local currentCity: string = '';
  controller: CitySearchController = new CitySearchController();

  aboutToAppear(): void {
    let recentCityListPromise = https.getRecentCityList();
    let currentCityPromise = https.getCurrentCity();
    Promise.all([recentCityListPromise, currentCityPromise]).then((values) => {
      this.recentCityList = values[0].data;
      this.currentCity = values[1].data;
    });
  }

  build() {
    NavDestination() {
      Column() {
        TitleBar({ title: '选择城市' });

        UICitySelect({
          currentCity: this.currentCity,
          recentVisitList: this.recentCityList.cityList,
          controller: this.controller,
          goBack: (citySelected?: string) => {
            RouterModule.stack.pop(citySelected);
          },
          emitUpdateCityLocation: (city: string) => {
            this.vm.updateCurrentCity(city);
          },
          emitUpdateRecentCityList: (city) => {
            this.vm.updateCityList(city);
          },
        });
      }
      .width(Constant.FULL_PERCENT);
    }
    .hideTitleBar(true)
    .backgroundColor(Color.White)
    .onBackPressed(() => {
      return this.controller.onBackPressed();
    });
  }
}
