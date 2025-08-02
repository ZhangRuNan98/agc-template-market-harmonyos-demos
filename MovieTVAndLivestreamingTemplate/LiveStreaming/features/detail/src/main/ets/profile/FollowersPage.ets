import { NavDestinationModifier } from '@kit.ArkUI'
import { RouterMap, RouterModule } from '@agctemplate/router_module'
import { Audience } from 'live_interaction'
import { jumpProfilePage } from './ProfilePage'
import { addFollowing, deleteFollowing, getFollowers } from '../models/AudienceData'
import { BarVM } from '@agctemplate/widgets'
import { EmptyContent } from './EmptyContent'

@ComponentV2
export struct FollowersPage {
  @Local audienceList: Array<Audience> = []
  navDestinationModifier: NavDestinationModifier = new NavDestinationModifier()
  @Local params: routerParams = {} as routerParams
  @Event closeDialog: () => void

  async aboutToAppear() {
    this.params = RouterModule.getNavParam<routerParams>({ url: RouterMap.FOLLOWERS_PAGE })!
    const idList = this.params.idList
    const mutualFollow = this.params.mutualFollow
    this.audienceList = await getFollowers(idList)
    this.audienceList.forEach(item=>{
      if (mutualFollow?.includes(item.id)) {
        item.isFocused = true
      }
    })
  }

  build() {
    NavDestination() {
      Column() {
        this.title()
        if (this.audienceList.length > 0) {
          List() {
            ForEach(this.audienceList, (item: Audience) => {
              ListItem() {
                Row() {
                  Row() {
                    Image(item.avatar)
                      .width(40)
                      .height(40)
                      .borderRadius(20)
                    Text(item.nickName)
                      .height(21)
                      .fontSize(16)
                      .fontWeight(400)
                      .fontColor('#000')
                      .margin({ left: 8 })
                  }
                  .height(40)
                  .onClick(() => {
                    jumpProfilePage(item)
                    this.closeDialog()
                  })

                  if (this.params.isMyself) {
                    Text(item.isFocused ? '互相关注' : '回关')
                      .textStyle()
                      .fontColor(item.isFocused ? '#EE5D1A' : '#fff')
                      .backgroundColor(item.isFocused ? $r('app.color.focused_background') : '#EE5D1A')
                      .onClick(() => {
                        item.isFocused = !item.isFocused
                        if (item.isFocused) {
                          addFollowing(item.id)
                        } else {
                          deleteFollowing(item.id)
                        }
                      })
                  } else {
                    Text(item.isFocused ? '已关注' : '关注')
                      .textStyle()
                      .fontColor(item.isFocused ? '#EE5D1A' : '#fff')
                      .backgroundColor(item.isFocused ? $r('app.color.focused_background') : '#EE5D1A')
                      .onClick(() => {
                        item.isFocused = !item.isFocused
                        if (item.isFocused) {
                          addFollowing(item.id)
                        } else {
                          deleteFollowing(item.id)
                        }
                      })
                  }
                }
                .width('100%')
                .height(64)
                .justifyContent(FlexAlign.SpaceBetween)
              }
            })
          }
          .margin({ bottom: 30 })
          .scrollBar(BarState.Off)
        } else {
          EmptyContent({ text: '空空如也~' })
        }
      }
      .padding({ left: 16, right: 16 })
      .width('100%')
      .height('100%')
    }
    .padding({ top: BarVM.instance.staBarH, bottom: BarVM.instance.aiBarH })
    .hideTitleBar(true)
    .attributeModifier(this.navDestinationModifier)
    .onBackPressed(() => {
      RouterModule.pop('result')
      return true
    })
  }

  @Builder
  title() {
    Row() {
      Image($r('app.media.ic_backward2'))
        .width(40)
        .aspectRatio(1)
        .margin({ right: 8 })
        .onClick(() => {
          RouterModule.pop('result')
        })

      Text(this.getTitle())
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .height(27)
    }
    .height(40)
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .margin({ top: 8, bottom: 8 })
  }

  getTitle() {
    if (!this.params.isMyself) {
      return $r('app.string.ta_fans')
    } else {
      return $r('app.string.my_fans')
    }
  }
}

@Extend(Text)
function textStyle() {
  .width(72)
  .height(28)
  .borderRadius(14)
  .textAlign(TextAlign.Center)
  .fontSize(14)
  .fontWeight(500)
}

export interface routerParams {
  idList: string[]
  isMyself: boolean
  mutualFollow?: string[]
}

export function jumpFollowersPage(liveInfo?: routerParams, callback?: (popInfo: PopInfo) => void) {
  RouterModule.push({
    url: RouterMap.FOLLOWERS_PAGE,
    param: liveInfo,
    onPop: callback
  })
}

@Builder
export function FollowersPageBuilder() {
  FollowersPage()
}
