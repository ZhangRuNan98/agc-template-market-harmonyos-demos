import { loginComponentManager } from '@hms.core.account.LoginComponent';

export interface IPrivacyText extends loginComponentManager.PrivacyText {
  extraParams?: Record<string, string>;
}
