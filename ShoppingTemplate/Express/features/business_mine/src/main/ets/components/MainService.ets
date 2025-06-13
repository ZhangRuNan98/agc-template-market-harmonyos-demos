import { RouterModule } from 'lib_foundation'
import { RouterMap } from 'module_base'
import { mainServiceList } from '../constants'
import { IMainServiceItem } from '../types'
import { MinePageVM } from '../viewModels/MinePageVM'

@ComponentV2
export struct MainService {
  vm: MinePageVM = MinePageVM.instance

  @Builder
  mainServiceBuilder(text: string, image: ResourceStr, func: Function) {
    Column() {
      Image(image)
        .width(32)
        .height(32)
        .margin({ bottom: 8 })
      Text(text)
        .fontSize(12)
        .fontWeight(FontWeight.Regular)
        .fontColor($r('sys.color.font_primary'))
    }
    .onClick(() => {
      if (!this.vm.isLogin) {
        RouterModule.push({ url: RouterMap.QUICK_LOGIN_PAGE })
        return
      }
      func(this.vm)
    })
  }

  build() {
    Row() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        ForEach(mainServiceList, (mainService: IMainServiceItem) => {
          this.mainServiceBuilder(mainService.text, mainService.image, mainService.func)
        }, (item: IMainServiceItem[]) => JSON.stringify(item))
      }
    }
    .width('100%')
    .height(80)
    .backgroundColor(Color.White)
    .margin({ bottom: 12 })
    .padding({
      left: 12,
      right: 12
    })
    .borderRadius(16)
  }
}