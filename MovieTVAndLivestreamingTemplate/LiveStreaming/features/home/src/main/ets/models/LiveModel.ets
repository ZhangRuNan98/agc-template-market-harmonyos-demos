export interface LiveCard {
  id: string
  cover: ResourceStr
  title: string
  streamer: string
  category: string
  status: string
  watching: number
  avatar: ResourceStr
}

export class LiveCardModel {
  id: string
  cover: ResourceStr
  title: string
  streamer: string
  category: string
  status: string
  watching: number
  avatar: ResourceStr

  constructor(item: LiveCard) {
    this.id = item.id
    this.cover = item.cover
    this.title = item.title
    this.streamer = item.streamer
    this.category = item.category
    this.status = item.status
    this.watching = item.watching
    this.avatar = item.avatar
  }
}