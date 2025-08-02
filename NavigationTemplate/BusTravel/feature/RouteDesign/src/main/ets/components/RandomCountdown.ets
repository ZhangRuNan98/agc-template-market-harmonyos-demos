import { cryptoFramework } from '@kit.CryptoArchitectureKit';

export class RandomCountdown {
  public generateRandomNumber(minNum: number, maxNum: number): number { // 整数随机数
    let rand = cryptoFramework.createRandom();
    let randData = rand.generateRandomSync(4)
    if(randData!==null){
      let randBuffer = new Uint32Array(randData.data.buffer);
      let randomValue = randBuffer[0] / 0xFFFFFFFF;
      return Math.floor(randomValue * (maxNum - minNum + 1)) + minNum
    }else{
      return 0;
    }
  }

  public generateRandomDecimalNumber(minNum: number, maxNum: number, decimalPlaces: number): number { // 小数随机数
    let rand = cryptoFramework.createRandom();
    const randomBytes = rand.generateRandom(16);
    const random = Number(rand.generateRandomSync(2))
    const range = maxNum - minNum;
    const multiplier = Math.pow(10, decimalPlaces);
    return Math.round(Math.floor((random * (range + 1)) * multiplier) / multiplier + minNum);
  }

  public line: string = ''
  public nearestFirstStation: number = this.generateRandomNumber(2, 7)
  public nearestFirstMin: number = this.generateRandomNumber(2, 10)
  public nearestFirstDis: number = this.generateRandomNumber(2, 10)
  public nearestSecondStation: number = this.generateRandomNumber(7, 10)
  public nearestSecondMin: number = this.generateRandomNumber(10, 15)
  public nearestSecondDis: number = this.generateRandomNumber(10, 15)
  public nearestThirdStation: number = this.generateRandomNumber(15, 20)
  public nearestThirdMin: number = this.generateRandomNumber(15, 20)
  public nearestThirdDis: number = this.generateRandomNumber(15, 20)

  constructor(line: string = '') {
    this.line = line;
  }
}