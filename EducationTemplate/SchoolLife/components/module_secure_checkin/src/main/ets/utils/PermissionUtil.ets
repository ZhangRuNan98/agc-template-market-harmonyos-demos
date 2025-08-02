import { PermissionStatus } from '../common/CustomTypes';

import bundleManager from '@ohos.bundle.bundleManager';
import common from '@ohos.app.ability.common';
import abilityAccessCtrl, { PermissionRequestResult, Permissions } from '@ohos.abilityAccessCtrl';

const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

export class PermissionUtil {

  public static async requestPermissions(context: common.UIAbilityContext,
    permissionsList: Permissions[]
  ): Promise<boolean> {
    try {
      // 过滤掉已经获取的权限
      const needAuthorized: Permissions[] = [];
      for (const permissions of permissionsList) {
        const isGranted: boolean = await PermissionUtil.checkPermissions(permissions);
        if (!isGranted) {
          needAuthorized.push(permissions);
        }
      }
      // 判断是否有权限需要申请
      if (!needAuthorized.length) {
        return true;
      }
      // 向用户申请权限
      const result: PermissionRequestResult = await atManager.requestPermissionsFromUser(context, needAuthorized);
      // 校验权限申请结果
      const authResults: number[] = result.authResults;
      const deniedPermissions: Permissions[] = [];
      for (let i = 0; i < authResults.length; i++) {
        if (authResults[i] === PermissionStatus.DENIED) {
          deniedPermissions.push(needAuthorized[i]);
        } else if (authResults[i] === PermissionStatus.UNKNOWN) {
          return false;
        }
      }
      // 如果存在曾经被拒绝过的权限，通过发起二次申请再次尝试获取
      if (deniedPermissions.length > 0) {
        const grantStatusList: abilityAccessCtrl.GrantStatus[] = await atManager.requestPermissionOnSetting(
          context,
          deniedPermissions
        );
        for (const grantStatus of grantStatusList) {
          if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
            return false;
          }
        }
      }
      return true;
    } catch {
      return false;
    }
  }

  private static async checkPermissions(permissions: Permissions): Promise<boolean> {
    // 获取 accessTokenId
    const bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoForSelfSync(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
    );
    const accessTokenId: number = bundleInfo.appInfo.accessTokenId;
    // 校验权限是否已经被授予
    const grantStatus: abilityAccessCtrl.GrantStatus = await atManager.checkAccessToken(accessTokenId, permissions);
    return grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
  }
}
