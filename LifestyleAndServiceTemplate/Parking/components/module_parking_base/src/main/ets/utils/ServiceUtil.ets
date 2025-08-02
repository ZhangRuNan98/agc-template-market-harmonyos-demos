import { mapCommon, site } from '@kit.MapKit';
import { BasicParkInfo } from '../types/ParkSpot';
import { CommonUtil } from './CommonUtil';
import { LocationUtil } from './LocationUtil';
import { Logger } from './Logger';

const TAG = '[ServiceUtil]';

export class ServiceUtil {
  /** 搜索停车场 **/
  public static async searchParking(center: mapCommon.LatLng) {
    try {
      let params: site.SearchByTextParams = {
        query: '停车场',
        location: center,
        poiTypes: ['PARKING_LOT'],
        language: 'zh',
      };
      const result = await site.searchByText(params);
      if (result.sites) {
        // mock 车位信息
        const newSpots: BasicParkInfo[] = [];
        for (let i = 0; i < result.sites.length; i++) {
          const item = result.sites[i];
          const distance = await LocationUtil.calDistanceFromMy(item.location!);
          const totalSpots = CommonUtil.generateRandomInRange(30, 50);
          const leftSpots = CommonUtil.generateRandomInRange(0, totalSpots);
          let chargeSpots = 0;
          let leftChargeSpots = 0;
          const canCharge = CommonUtil.generateRandomBoolean();
          if (canCharge) {
            chargeSpots = Math.floor(totalSpots / CommonUtil.generateRandomInRange(2, 3));
            leftChargeSpots = CommonUtil.generateRandomInRange(0, Math.min(leftSpots, chargeSpots));
          }
          const spot = {
            siteId: item.siteId,
            name: item.name,
            addr: item.formatAddress,
            location: item.location,
            distance: distance,
            totalSpots: totalSpots,
            leftSpots: leftSpots,
            chargeSpots: chargeSpots,
            leftChargeSpots: leftChargeSpots,
          } as BasicParkInfo;
          newSpots.push(spot);
        }
        Logger.info(TAG, 'Succeeded in searching by text.');
        return newSpots;
      }
      return [];
    } catch (error) {
      Logger.error(TAG, 'Failed in searching by text:' + JSON.stringify(error));
      return [];
    }
  }
}