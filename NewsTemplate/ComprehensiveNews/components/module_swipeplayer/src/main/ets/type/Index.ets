export enum AVPlayerState {
  IDLE = 'idle',
  INITIALIZED = 'initialized',
  PREPARED = 'prepared',
  PLAYING = 'playing',
  PAUSED = 'paused',
  COMPLETED = 'completed',
  STOPPED = 'stopped',
  RELEASED = 'released',
  ERROR = 'error'
}

export interface VideoPlayerData {
  getVideoId: () => string;
  getVideoUrl: () => string;
  getCoverUrl: () => ResourceStr | undefined;
  getVideoTitle: () => string;
  getVideoDuration: () => number;
}