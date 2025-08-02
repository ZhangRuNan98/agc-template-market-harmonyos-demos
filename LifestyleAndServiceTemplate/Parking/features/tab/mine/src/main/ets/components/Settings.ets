import { CommonConstants, CONTAINER_STYLE, RouterMap, RouterModule, TelUtil } from 'common';
import { AssociateUtil } from 'network';
import { SettingItem } from '../types/Types';
import { MinePageVM } from '../viewmodels/MinePageVM';

@ComponentV2
export struct Settings {
  vm: MinePageVM = MinePageVM.instance;

  build() {
    List({ space: 12 }) {
      ForEach(this.vm.getSettingGroupList(), (group: SettingItem[]) => {
        ListItemGroup({ space: 24 }) {
          ForEach(group, (item: SettingItem) => {
            this.settingListItemBuilder(item)
          }, (item: SettingItem, index) => JSON.stringify(item) + '_' + index)
        }
        .divider({ strokeWidth: 1, color: $r('app.color.divider_gray') })
        .attributeModifier(CONTAINER_STYLE)
      }, (group: SettingItem, index) => JSON.stringify(group) + '_' + index)
    }
  }

  @Builder
  settingListItemBuilder(item: SettingItem) {
    ListItem() {
      Row() {
        Image(item.icon).width(16).margin({ right: $r('app.string.margin_16') })
        Text(item.label)
          .flexGrow(1)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.font_primary'))
        Image($r('app.media.ic_arrow')).width(16)
      }
      .width(CommonConstants.FULL_WIDTH)
    }
    .onClick(() => {
      if (item.url === 'CallPhone') {
        TelUtil.open({ title: '联系客服', phoneNum: '01201000100' });
        return;
      }
      if (item.url === RouterMap.PRIVACY_POLICY) {
        RouterModule.push({ url: RouterMap.PRIVACY_POLICY });
      } else {
        AssociateUtil.checkBindPhone(() => {
          RouterModule.push({ url: item.url });
        });
      }
    })
  }
}