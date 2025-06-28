import { AddressDTO } from '../model/AddressDTO';
import { Api } from '../http/Api';

export async function getDefaultAddress(): Promise<AddressDTO | undefined> {
  return Api.listAddresses().then(list => list.find(item => item.isDefault));
}
