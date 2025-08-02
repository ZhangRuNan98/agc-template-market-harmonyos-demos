import { CheckinPage } from './pages/CheckinPage';
import { Any, CheckinContext } from './common/CustomTypes';

const CHECKIN_PAGE: string = 'CheckinPage';

export function goToCheckinPage(stack: NavPathStack, ctx: CheckinContext): void {
  stack.pushPathByName(CHECKIN_PAGE, ctx);
}

@Builder
export function buildPageByName(pageName: string, ctx: Any): void {
  if (pageName === CHECKIN_PAGE) {
    CheckinPage({ checkinContext: ctx as CheckinContext });
  }
}
