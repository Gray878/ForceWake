import { AxiosRequestConfig, HttpStatusCode } from '@ohos/axios';
import { axiosInstance } from '../apis/HttpRequest';
import { AxiosMock } from './AxiosMock';
import {
  addCustomFood,
  addDietPlans,
  getFoodCategory,
  queryDietPlan,
  queryDietPlans,
  searchFoodByName,
} from './MockData/Calories';
import { CustomFoodBody, DietPlanBody } from '../model/Calories';

const mock: AxiosMock = new AxiosMock(axiosInstance, {
  delayResponse: 300,
});

mock.onGet('/calories/food-category').reply(async (config: AxiosRequestConfig) => {
  let list = getFoodCategory();
  return {
    status: HttpStatusCode.Ok,
    data: list,
  };
});
mock.onPost('/calories/add-diet-plans').reply(async (config: AxiosRequestConfig) => {
  const data = JSON.parse(config.data) as DietPlanBody;
  addDietPlans(data);
  return {
    status: HttpStatusCode.Ok,
  };
});
mock.onGet('/calories/diet-plans').reply(async (config: AxiosRequestConfig) => {
  return {
    status: HttpStatusCode.Ok,
    data: queryDietPlans(),
  };
});
mock.onGet('/calories/diet-plan').reply(async (config: AxiosRequestConfig) => {
  const menuId = Number(config.params.menuId);
  return {
    status: HttpStatusCode.Ok,
    data: queryDietPlan(menuId),
  };
});
mock.onGet('/calories/search').reply(async (config: AxiosRequestConfig) => {
  const name: string = config.params.name;
  return {
    status: HttpStatusCode.Ok,
    data: searchFoodByName(name),
  };
});
mock.onPost('/calories/food').reply(async (config: AxiosRequestConfig) => {
  const data = JSON.parse(config.data) as CustomFoodBody;
  addCustomFood(data);
  return {
    status: HttpStatusCode.Ok,
  };
});