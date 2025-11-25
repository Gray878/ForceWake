import { AxiosRequestConfig, HttpStatusCode } from '@ohos/axios';
import { instance } from '../apis/HttpRequest';
import { AxiosMock } from './AxiosMock';
import { FeedBack } from '../model/FeedBacks';
import { AppStorageBank } from '../utils/AppStorageBank';

const mock: AxiosMock = new AxiosMock(instance, {
  delayResponse: 300,
});

mock.onPost('/feedback/add').reply(async (config: AxiosRequestConfig) => {
  const data = JSON.parse(config.data) as FeedBack;
  AppStorageBank.addFeedback(data)
  return {
    status: HttpStatusCode.Ok,
  };
});

mock.onGet('/feedback/list').reply(async (config: AxiosRequestConfig) => {
  return {
    status: HttpStatusCode.Ok,
    data: AppStorageBank.getFeedBacks()
  };
});