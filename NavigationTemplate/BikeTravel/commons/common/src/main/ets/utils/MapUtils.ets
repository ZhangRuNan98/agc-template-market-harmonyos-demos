import { map, mapCommon, navi } from '@kit.MapKit';
import { Logger } from './Logger';


export class MapUtils {
  public static async walkingRoutes(position: mapCommon.LatLng, myPosition?: mapCommon.LatLng) {
    let params: navi.RouteParams = {
      origins: [myPosition!],
      destination: position,
      language: 'zh_CN'
    };
    try {
      const result = await navi.getWalkingRoutes(params);
      Logger.info('naviDemo', 'getWalkingRoutes success result =' + JSON.stringify(result));
      return result;
    } catch (err) {
      Logger.error('naviDemo', 'getWalkingRoutes fail err =' + JSON.stringify(err));
    }
    return undefined;
  }

  public static async cycleRoutes(position: mapCommon.LatLng, myPosition?: mapCommon.LatLng) {
    let params: navi.RouteParams = {
      origins: [myPosition!],
      destination: position,
      language: 'zh_CN'
    };
    try {
      const result = await navi.getCyclingRoutes(params);
      Logger.info('naviDemo', 'getCyclingRoutes success result =' + JSON.stringify(result));
      return result;
    } catch (err) {
      Logger.error('naviDemo', 'getCyclingRoutes fail err =' + JSON.stringify(err));
    }
    return undefined;
  }

  public static async paintRoute(routeResult: navi.RouteResult, mapPolyline?: map.MapPolyline,
    mapController?: map.MapComponentController) {
    mapPolyline?.remove();
    let polylineOption: mapCommon.MapPolylineOptions = {
      points: routeResult.routes[0].overviewPolyline!,
      clickable: true,
      startCap: mapCommon.CapStyle.BUTT,
      endCap: mapCommon.CapStyle.BUTT,
      geodesic: false,
      jointType: mapCommon.JointType.BEVEL,
      visible: true,
      width: 20,
      zIndex: 10,
      gradient: false,
      color: 0xFF2970FF
    }
    mapPolyline = await mapController?.addPolyline(polylineOption);
  }
}