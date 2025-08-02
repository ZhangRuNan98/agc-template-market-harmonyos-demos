import { mapCommon } from '@kit.MapKit';
import { image } from '@kit.ImageKit';
import { AreaHouse } from '../model/Index';

export class ClusterOverlayParamsMore implements mapCommon.ClusterOverlayParams {
  clusterItems: mapCommon.ClusterItem[] = [];
  distance: number = 0;
  areaHouse: AreaHouse = new AreaHouse();
  private offCanvas: OffscreenCanvas = new OffscreenCanvas(62, 62);
  private settings: RenderingContextSettings = new RenderingContextSettings(true);

  constructor(clusterItems: mapCommon.ClusterItem[], distance: number, areaHouse: AreaHouse) {
    this.clusterItems = clusterItems;
    this.distance = distance;
    this.areaHouse = areaHouse;
  }

  async getCustomIcon(clusterItems: mapCommon.ClusterItem[]): Promise<image.PixelMap> {
    let offContext = this.offCanvas.getContext('2d', this.settings);

    offContext.clearRect(0, 0, 62, 62);
    // 绘制圆形
    offContext.fillStyle = '#64BB5C';
    offContext.beginPath();
    offContext.arc(31, 31, 30, 0, 6.28);
    offContext.stroke();
    offContext.fill();
    offContext.save();

    // 在圆形内绘制文本，文本信息为区名+房源数
    offContext.font = '12vp sans-serif';
    offContext.textAlign = 'center';
    offContext.textBaseline = 'middle';
    offContext.fillStyle = '#ffffff';
    offContext.fillText(this.areaHouse.area + '\n' + this.areaHouse.locations.length + '个', 31, 31);
    offContext.restore();
    let iconPixelMap = offContext.getPixelMap(0, 0, 62, 62);
    return iconPixelMap;
  }
}