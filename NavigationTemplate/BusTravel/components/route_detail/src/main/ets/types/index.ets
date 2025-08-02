export interface SearchSet {
  // 线路名称，比如1路
  lineName: string;
  // 起始站点名称
  startStation: string;
  // 终点站名称
  endStation: string;
  // 横纵坐标，与经纬度值相同
  coordX: number;
  coordY: number;
  // 当前站点名称
  stationName: string;
  // 站点顺序
  sequence: number
}

export interface LineSet {
  // 线路名称，比如1路
  lineName: string;
  startStation: string;
  endStation: string;
  lon: number;
  lat: number;
  orders: number
}