/* eslint-disable */
import { AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { AccountUtil } from 'module_base';
import { AxiosHttpModel } from './AxiosHttpModel';

const request = new AxiosHttpModel(
  {
    /*
    :todo 网络请求base url，真实网络请求可以替换请求地址
    */
    baseURL: '',
    timeout: 10 * 3000,
    headers: {},
    interceptorHooks: {
      requestInterceptor: async (config: InternalAxiosRequestConfig) => {
        config.headers.set('authorization', AccountUtil.getAuthorization());
        return config;
      },
      requestInterceptorCatch: (err: BusinessError) => {
        return err;
      },
      responseInterceptor: (response: AxiosResponse) => {
        if (response.status === 200 && response.data.code === 0) {
          return Promise.resolve(response.data);
        } else {
          return Promise.reject(response);
        }
      },
      responseInterceptorCatch: (error: BusinessError) => {
        return error;
      },
    },
  },
  /*
  :todo 这里是mock数据参数位置，真实网络请求可以删除这里的参数true
  */
  true,
);

export default request;
