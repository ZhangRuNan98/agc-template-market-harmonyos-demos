import { map, mapCommon, site } from '@kit.MapKit';

export class CycleRecordData {
  id: number = 0
  bike: string = ''
  duration: string = '5分9秒'
  cost: number = 4.5
  start: string = '故宫'
  end: string = '国家大剧院'
}

@ObservedV2
export class CycleRecordDatas {
  @Trace data: CycleRecordData[] = [];
}

// mock数据
export function getGeocode(query: string): Promise<mapCommon.LatLng> {
  let params: site.GeocodeParams = {
    // 地址信息
    'query': query,
    'language': 'zh_CN'
  };
  return new Promise(async (resolve) => {
    const res = await site.searchByText(params);
    console.info('Succeeded in geocoding.');

    // 安全取值：取第一个结果 + 空值判断
    if (!res.sites || res.sites.length === 0) {
      throw new Error('No matching geographic coordinates found');
    }
    const targetSite = res.sites[0];
    // 坐标转换（WGS84转GCJ02）
    const convertedPos = map.convertCoordinateSync(
      mapCommon.CoordinateType.WGS84,
      mapCommon.CoordinateType.GCJ02,
      targetSite.location
    );

    // return convertedPos;
    resolve(convertedPos)
  })
}