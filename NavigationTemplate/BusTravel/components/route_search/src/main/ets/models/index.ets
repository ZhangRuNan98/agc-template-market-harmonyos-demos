export class LineInfo {
  lineName: string
  direction: string
  startStation: string
  endStation: string
  distance: string
  countDown: string

  constructor(lineName: string = '', direction: string = '', startStation: string = '', endStation: string = '',
    distance: string = '', countDown: string = '') {
    this.lineName = lineName
    this.direction = direction
    this.startStation = startStation
    this.endStation = endStation
    this.distance = distance
    this.countDown = countDown
  }
}