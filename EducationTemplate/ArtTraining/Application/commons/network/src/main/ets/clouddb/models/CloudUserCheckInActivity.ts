import { CloudCheckInActivity } from './CloudCheckInActivity';

class CloudUserCheckInActivity extends CloudCheckInActivity {
  public id: string;
  public userId: string;
  public status: number;
  public orderTime: string;

  public naturalbase_ClassName(): string {
    return 'CloudUserCheckInActivity';
  }
}

export { CloudUserCheckInActivity };
