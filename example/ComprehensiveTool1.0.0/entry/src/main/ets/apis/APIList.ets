import { AxiosResponse } from '@ohos/axios';
import { instance } from './HttpRequest';
import '../mocks/RequestMock';
import { FeedBackBody, FeedBacks } from '../model/FeedBacks';

// 提交问题反馈
export const addFeedBack = (data: FeedBackBody): Promise<AxiosResponse<void, FeedBackBody>> => {
  const url = '/feedback/add';
  return instance.post(url, data);
};

// 查询问题反馈
export const queryFeedBack = (): Promise<AxiosResponse<FeedBacks, void>> => {
  const url = '/feedback/list';
  return instance.get(url);
};
