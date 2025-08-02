import { TCRouter } from 'common'
import { PushKit } from 'custom_push'


@ComponentV2
export struct messagePage{

  @Local navPathStack:NavPathStack = TCRouter.getStack()
  build() {
    NavDestination(){
      PushKit({
        navPathStack:this.navPathStack
      })
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }


}