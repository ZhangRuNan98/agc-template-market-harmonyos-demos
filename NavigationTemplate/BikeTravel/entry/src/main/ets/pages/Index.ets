import {
  CustomScanPage,
  Cycling,
  FaultReportingPage,
  FeedbackPage,
  ManualInput,
  NewHomePage,
  UserGuidePage
} from 'bike_home';
import {
  BackID,
  CycleRecordPage,
  DataCollectionPage,
  DataSharingPage,
  FrontID,
  LoginWithHuaweiIDComponent,
  MinePage,
  PersonalInfo,
  PrivacyPolicyPage,
  RealNameAuth,
  SettingPage,
  TripDetail,
  UserAgreementPage
} from 'bike_mine';
import { RouterPageEnum, UserInfoStorage } from 'common';
import { PersistenceV2 } from '@kit.ArkUI';


@Entry
@ComponentV2
struct Index {
  @Provider('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  @Local userInfoStorage: UserInfoStorage = PersistenceV2.connect(UserInfoStorage, 'UserInfoStorage', () => new UserInfoStorage())!
  private interceptedRouterList: string[] = [
    RouterPageEnum.REAL_NAME_AUTH_ROUTER,
    RouterPageEnum.CUSTOM_SCAN_ROUTER,
    RouterPageEnum.FEEDBACK_ROUTER,
    RouterPageEnum.CYCLE_RECORD_ROUTER,
    RouterPageEnum.FAULT_REPORTING_ROUTER,
  ]

  aboutToAppear(): void {
    this.registerInterception()
    this.pageInfos.replacePathByName(RouterPageEnum.NEW_HOME_ROUTER, null)
  }

  // 路由拦截
  registerInterception() {
    this.pageInfos.setInterception({
      willShow: (from: NavDestinationContext | 'navBar', to: NavDestinationContext | 'navBar',
        operation: NavigationOperation, animated: boolean) => {
        if (typeof to === 'string') {
          console.log('target page is navigation home page.');
          return;
        }
        // 将跳转到PageTwo的路由重定向到PageOne
        console.log('trying to intercept',this.userInfoStorage.isLogin)
        let target: NavDestinationContext = to as NavDestinationContext;
        if (!this.userInfoStorage.isLogin) {
          if( this.interceptedRouterList.includes(target.pathInfo.name) ){
            target.pathStack.pop();
            target.pathStack.pushPathByName(RouterPageEnum.QUICK_LOGIN_ROUTER, null);
          }
        }
      }
    })
  }

  @Builder
  routerMap(name: string) {
    if (name === RouterPageEnum.NEW_HOME_ROUTER) {
      NewHomePage()
    } else if (name === RouterPageEnum.FAULT_REPORTING_ROUTER) {
      FaultReportingPage()
    } else if (name === RouterPageEnum.CUSTOM_SCAN_ROUTER) {
      CustomScanPage()
    } else if (name === RouterPageEnum.FEEDBACK_ROUTER) {
      FeedbackPage()
    } else if (name === RouterPageEnum.USER_GUIDE_ROUTER) {
      UserGuidePage()
    } else if (name === RouterPageEnum.MINE_ROUTER) {
      MinePage()
    } else if (name === RouterPageEnum.CYCLE_RECORD_ROUTER) {
      CycleRecordPage()
    } else if (name === RouterPageEnum.BACK_ID_ROUTER) {
      BackID()
    } else if (name === RouterPageEnum.FRONT_ID_ROUTER) {
      FrontID()
    } else if (name === RouterPageEnum.REAL_NAME_AUTH_ROUTER) {
      RealNameAuth()
    } else if (name === RouterPageEnum.TRIP_DETAIL_ROUTER) {
      TripDetail()
    } else if (name === RouterPageEnum.PERSONAL_INFO_ROUTER) {
      PersonalInfo()
    } else if (name === RouterPageEnum.QUICK_LOGIN_ROUTER) {
      LoginWithHuaweiIDComponent()
    } else if (name === RouterPageEnum.MANUAL_INPUT_ROUTER) {
      ManualInput()
    } else if (name === RouterPageEnum.CYCLING_ROUTER) {
      Cycling()
    } else if (name === RouterPageEnum.SETTING_ROUTER) {
      SettingPage()
    } else if (name === RouterPageEnum.PRIVACY_POLICY_ROUTER) {
      PrivacyPolicyPage()
    } else if (name === RouterPageEnum.USER_AGREEMENT_ROUTER) {
      UserAgreementPage()
    } else if (name === RouterPageEnum.DATA_SHARING_ROUTER) {
      DataSharingPage()
    } else if (name === RouterPageEnum.DATA_COLLECTION_ROUTER) {
      DataCollectionPage()
    }
  }

  build() {
    Navigation(this.pageInfos)
      .hideNavBar(true)
      .hideTitleBar(true)
      .mode(NavigationMode.Stack)
      .width('100%')
      .height('100%')
      .navDestination(this.routerMap)
  }
}

