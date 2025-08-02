import { mapCommon } from '@kit.MapKit'

function getDis(a: mapCommon.LatLng, b: mapCommon.LatLng) {
  return (a.longitude - b.longitude) * (a.longitude - b.longitude) +
    (a.latitude - b.latitude) * (a.latitude - b.latitude)
}

export function getIndex(baseNumber: number, lastStation: mapCommon.LatLng, nextStation: mapCommon.LatLng,
  bus: mapCommon.LatLng) {
  if (baseNumber < 0) {
    return 0
  }
  let dis = getDis(nextStation, lastStation)
  if (dis === 0) {
    return 0
  }
  let res = getDis(bus, lastStation) / dis
  if (res > 0 && res < 1) {
    return baseNumber + res
  } // bus在两站之间
  if (res < 0) {
    return baseNumber
  } // bus在lastStation之前
  if (res > 1) {
    return baseNumber + 0.99
  } // bus在lastStation之后 公交车已过
  return 0
}
