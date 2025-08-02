import * as wxopensdk from '@tencent/wechat_open_sdk';

export { LoginService } from './src/main/ets/pages/LoginService';

export { LoginType } from './src/main/ets/common/Constant';

export { wXEventHandler} from './src/main/ets/model/WXApiWrap'

export { Channel} from './src/main/ets/model/Index'

export const wXApi = wxopensdk.WXAPIFactory.createWXAPI('wx05b3e2e9fc730840')