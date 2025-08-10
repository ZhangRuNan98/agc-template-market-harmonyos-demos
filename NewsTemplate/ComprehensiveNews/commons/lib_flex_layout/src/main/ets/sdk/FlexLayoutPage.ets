import { PersistenceV2 } from '@kit.ArkUI';
import { UserInfoModel } from 'lib_common';
import { LayoutSetting, NewsResponse } from 'lib_news_api';
import { FrameController } from './factory/FrameNodeFactory';

@ComponentV2
export struct FlexLayoutPage {
  @Param setting: LayoutSetting = new LayoutSetting()
  @Param articles: NewsResponse[] = []
  @Param extraInfo: Record<string, string | boolean | Record<string, string | boolean>[]> = {}
  @Local firstLevelClassificationData: LayoutSetting = new LayoutSetting()
  @Local count: number = 0
  @Local isSwiperDisabled: boolean = false
  @Param resource:string = ''
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;

  aboutToAppear(): void {
    this.settingDataHandler()
  }

  getAreaQueryVos(children: LayoutSetting[]) {
    let result: LayoutSetting[] = []
    if (children) {
      for (let index = 0; index < children.length; index++) {
        if (children[index].type === 'swiper') {
          this.getNativeCount(children[index].children as LayoutSetting[])
        }
        result.push({
          type: children[index].type,
          showType: children[index].showType ?? null,
          style: children[index].style,
          children: this.getAreaQueryVos(children[index].children),
        })
      }
    } else {
      return []
    }
    return result
  }

  settingDataHandler() {
    let result: LayoutSetting = new LayoutSetting()
    result.type = this.setting.type
    result.children = this.getAreaQueryVos(this.setting.children as LayoutSetting[])
    result.style = this.setting.style
    this.firstLevelClassificationData = result
  }

  getNativeCount(children: LayoutSetting []) {
    if (children) {
      for (let i = 0; i < children.length; i++) {
        if (children[i].type === 'native') {
          this.count++
        }
        this.getNativeCount(children[i].children as LayoutSetting [])
      }
    }
  }

  @Builder
  buildVNode() {
    if (this.firstLevelClassificationData.type === 'view') {
      NodeContainer(new FrameController(this.firstLevelClassificationData, this.articles, this.extraInfo))
    }
  }

  build() {
    this.buildVNode()
  }
}