import { AxiosResponse } from '@ohos/axios';
import { axiosInstance } from './HttpRequest';
import '../mocks/RequestMock';
import {
  CustomFoodBody,
  DietPlanBody,
  DietPlans,
  FoodCalories,
  FoodCategory,
  FoodPlanCaloriesBody,
} from '../model/Calories';

// 查询饮食列表
export const queryFoodCategory = (): Promise<AxiosResponse<Array<FoodCategory>, void>> => {
  const url = '/calories/food-category';
  return axiosInstance.get(url);
};

// 查询饮食计划列表
export const queryDietPlans = (): Promise<AxiosResponse<Array<DietPlans>, void>> => {
  const url = '/calories/diet-plans';
  return axiosInstance.get(url);
};

// 根据id查询饮食计划
export const queryDietPlan = (menuId: number): Promise<AxiosResponse<DietPlans, void>> => {
  const url = '/calories/diet-plan';
  return axiosInstance.get(url, { params: { menuId } });
};

// 查询饮食计划
export const addDietPlans =
  (menuId: number, name: string, foodList: FoodPlanCaloriesBody[]): Promise<AxiosResponse<number, void>> => {
    const url = '/calories/add-diet-plans';
    const data: DietPlanBody = {
      menuId,
      name,
      foodList,
    };
    return axiosInstance.post(url, data);
  };

// 搜索食物
export const searchFoodByName = (name: string): Promise<AxiosResponse<Array<FoodCalories>, void>> => {
  const url = '/calories/search';
  return axiosInstance.get(url, { params: { name } });
};

// 添加自定义食物
export const addCustomFood = (data: CustomFoodBody): Promise<AxiosResponse<void, CustomFoodBody>> => {
  const url = '/calories/food';
  return axiosInstance.post(url, data);
};
