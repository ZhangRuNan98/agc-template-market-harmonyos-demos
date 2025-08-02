

export class Formatter {

  public static padZero(value: number, width: number = 2): string {
    return value.toString().padStart(width, '0');
  }

}
