import { AddressDTO } from '../model/AddressDTO';
import { ParsedAddressDTO } from '../model/ParsedAddressDTO';
import { Api } from '../http/Api';

export function getDefaultAddress(): Promise<AddressDTO | undefined> {
  return Api.listAddresses().then(list => list.find(item => item.isDefault));
}

export function parseAddressByText(text: string): Promise<ParsedAddressDTO> {
  return Api.parseAddressByText(text);
}
