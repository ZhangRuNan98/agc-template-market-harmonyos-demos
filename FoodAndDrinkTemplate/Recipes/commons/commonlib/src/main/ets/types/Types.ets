export interface UserInfo {
  id: number;
  avatar: string;
  name: string;
  nickname: string;
  sex: string;
  cellphone: string;
  birthday: string;
  code: string;
  isLogin: boolean;
  isMembership: boolean;
}

export interface DialogParams {
  title: string,
  confirmFunc?: () => void
  cancelFunc?: () => void
}