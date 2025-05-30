import { ClubEnvironmentDetail } from '../pages/ClubEnvironmentDetail';
import { SportDetail } from '../pages/SportDetail';

@Builder
export function SportDetailBuilder() {
  SportDetail();
}

@Builder
export function ClubEnvironmentDetailBuilder() {
  ClubEnvironmentDetail();
}

