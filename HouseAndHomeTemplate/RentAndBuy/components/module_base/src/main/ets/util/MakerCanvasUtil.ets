export class MakerCanvasUtil {
  private static _instance: MakerCanvasUtil;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private offCanvas: OffscreenCanvas = new OffscreenCanvas(200, 32);

  public static get instance() {
    if (!MakerCanvasUtil._instance) {
      MakerCanvasUtil._instance = new MakerCanvasUtil();
    }
    return MakerCanvasUtil._instance;
  }

  getMakerIcon(text: string): PixelMap {
    let offContext = this.offCanvas.getContext('2d', this.settings);

    offContext.clearRect(0, 0, 200, 32);

    let radius = 8; //圆角弧度
    let x = 0; //左上角坐标x
    let y = 0; //左上角坐标y
    let width = 200; //矩形宽
    let height = 32; //矩形高
    offContext.fillStyle = '#64BB5C';
    offContext.strokeStyle = '#64BB5C';
    offContext.beginPath();
    offContext.moveTo(x + radius, y);
    offContext.lineTo(x + width - radius, y);
    offContext.arcTo(x + width, y, x + width, y + radius, radius);
    offContext.lineTo(x + width, y + height - radius);
    offContext.arcTo(x + width, y + height, x + width - radius, y + height, radius);
    offContext.lineTo(x + radius, y + height);
    offContext.arcTo(x, y + height, x, y + height - radius, radius);
    offContext.lineTo(x, y + radius);
    offContext.arcTo(x, y, x + radius, y, radius);
    offContext.stroke();
    offContext.fill();
    offContext.save();
    offContext.closePath();

    offContext.font = '12vp sans-serif';
    offContext.textAlign = 'center';
    offContext.textBaseline = 'middle';
    offContext.fillStyle = '#ffffff';
    offContext.fillText(text, 100, 16, 200);
    offContext.restore();
    let iconPixelMap = offContext.getPixelMap(0, 0, 200, 32);
    return iconPixelMap;
  }
}