import { Logger } from './Logger';

export class FormatUtil {
  public static distanceDisplay(distanceInMeters: number): string {
    if (distanceInMeters < 1000) {
      return `${Math.floor(distanceInMeters)}m`;
    }
    const distanceInKilometers = (distanceInMeters / 1000).toFixed(2);
    return `${distanceInKilometers}km`;
  }

  public static getComplementPercentage(input: string): string {
    const match = input.match(/^(\d+(?:\.\d+)?)%$/);
    if (!match) {
      Logger.error('输入格式必须为数字后跟百分号(例如：8%)');
      return '';
    }
    const value = parseFloat(match[1]);
    if (value < 0 || value > 100) {
      Logger.error('百分比值必须在 0% 到 100% 之间');
      return '';
    }
    const complement = 100 - value;
    const decimalPlaces = match[1].includes('.') ? match[1].split('.')[1].length : 0;
    return `${complement.toFixed(decimalPlaces)}%`;
  }
}