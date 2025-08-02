import { PersonalInfoModule, PersonalInfoType, RouterModule, SettingInfoModule, SettingType } from 'foundation';

export const PERSONAL_INFO_ITEMS: PersonalInfoModule[] = [
  {
    type: PersonalInfoType.FOLLOW,
    icon: $r('app.media.follow'),
    name: '我的关注',
    clickEvent: () => {
      RouterModule.stack.pushPathByName('MyFollow', null);
    },
  },
  {
    type: PersonalInfoType.HISTORY,
    icon: $r('app.media.history'),
    name: '浏览记录',
    clickEvent: () => {
      RouterModule.stack.pushPathByName('History', null);
    },
  },
  {
    type: PersonalInfoType.FOLLOW,
    icon: $r('app.media.setting'),
    name: '个人设置',
    clickEvent: () => {
      RouterModule.stack.pushPathByName('Setting', null);
    },
  },
];

export const SETTING_INFO_ITEMS: SettingInfoModule[] = [
  {
    type: SettingType.PRIVACY_POLICY,
    clickEvent: () => {
      RouterModule.stack.pushPathByName('PrivacyPolicyPage', null);
    },
  },
  {
    type: SettingType.TERMS_OF_SERVICE,
    clickEvent: () => {
      RouterModule.stack.pushPathByName('TermsOfServicePage', null);
    },
  }
]