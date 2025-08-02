export interface TabListItem {
  label: string;
  icon: Resource;
  iconChecked: Resource;
  component: WrappedBuilder<[]>;
}

export interface UserInfoResp {
  id: number;
  name?: string;
  nickname?: string;
  sex?: string;
  cellphone?: string;
  birthday?: string;
  userHeadImg?: string;
}
