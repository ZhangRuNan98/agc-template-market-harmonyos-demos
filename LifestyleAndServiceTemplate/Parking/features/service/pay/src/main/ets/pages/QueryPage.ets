import { CommonHeader, RouterMap, RouterModule, WindowUtil } from 'common';
import { QueryPayPageVM } from '../viewmodels/QueryPayPageVM';
import { QueryKeyboard } from 'module_license_keyboard';

@ComponentV2
export struct QueryPage {
  vm: QueryPayPageVM = QueryPayPageVM.instance;

  getBgColor(license: string, canDelete: boolean): ResourceStr {
    if (canDelete) {
      return $r('sys.color.background_primary');
    } else if (license.length < 8) {
      return $r('sys.color.brand');
    }
    return '';
  }

  build() {
    NavDestination() {
      /** 标题栏 **/
      CommonHeader({ title: '停车缴费' })

      QueryKeyboard({
        myLicenses: this.vm.licenseInfo.all,
        click: (license) => {
          RouterModule.push({ url: RouterMap.PAY_PAGE, param: license });
        },
      })
        .layoutWeight(1)
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.system_color_background_gray'))
    .padding({ bottom: WindowUtil.getAvoidArea().bottom })
  }
}

@Builder
export function queryPageBuilder() {
  QueryPage()
}