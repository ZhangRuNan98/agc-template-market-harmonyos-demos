import { sceneMap } from '@kit.MapKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export async function getCascadeInfo(context: common.UIAbilityContext) {
  let district: string = '';
  let districtSelectOptions: sceneMap.DistrictSelectOptions = {
    countryCode: 'CN',
  };

  return new Promise<string>((resolve, reject) => {
    sceneMap.selectDistrict(context, districtSelectOptions).then((data) => {
      for (let i = 1; i < data.districts.length; i++) {
        if (i < data.districts.length - 1) {
          district += data.districts[i].name + '/';
        } else {
          district += data.districts[i].name;
        }
      }
      resolve(district);
    }).catch((err: BusinessError) => {
      reject('');
    });
  });
}