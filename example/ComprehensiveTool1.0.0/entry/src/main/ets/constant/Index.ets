/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { SettingModule, ToolTypeModule } from '../model/Index';
import { Category, SettingType, ToolType } from './Enum';

export const stack: NavPathStack = new NavPathStack();

export const TOOL_TYPE_MODULES: ToolTypeModule[] = [
  {
    id: ToolType.ALL,
    category: Category.ALL,
    title: '全部',
    icon: $r('app.media.almanac'),
    url: '',
  },
  {
    id: ToolType.ALMANAC,
    category: Category.LIFE,
    title: '黄历',
    icon: $r('app.media.almanac'),
    url: 'AlmanacView',
  },
  {
    id: ToolType.CALCULATOR,
    title: '计算器',
    category: Category.CALCULATE,
    icon: $r('app.media.calculator'),
    url: 'HomePage',
  },
  {
    id: ToolType.DATE_CALCULATOR,
    title: '日期计算',
    category: Category.CALCULATE,
    icon: $r('app.media.date'),
    url: 'DateCalculatorPage',
  },
  {
    id: ToolType.EXCHANGE_RATE,
    title: '汇率计算',
    category: Category.CALCULATE,
    icon: $r('app.media.exchange'),
    url: 'ExchangeRateCalculatorPage',
  },
  {
    id: ToolType.CALORIES,
    title: '热量计算',
    category: Category.LIFE,
    icon: $r('app.media.calories'),
    url: 'CaloriesPage',
  },
  {
    id: ToolType.PERSONAL_INCOME_TAX_CALCULATOR,
    title: '个税计算器',
    category: Category.CALCULATE,
    icon: $r('app.media.income'),
    url: 'IncomePage',
  },
  {
    id: ToolType.REMOTE_CONTROLLER,
    title: '万能空调遥控器',
    category: Category.LIFE,
    icon: $r('app.media.remote'),
    url: 'RemotePage',
  },
  {
    id: ToolType.MORTGAGE_CALCULATOR,
    title: '房贷计算器',
    category: Category.CALCULATE,
    icon: $r('app.media.mortgage'),
    url: 'MortgageCalculationHome',
  },
];

export const SETTING_TYPE_MODULES: SettingModule[] = [
  {
    id: SettingType.FEEDBACK,
    title: '问题反馈',
    icon: $r('app.media.feedback'),
    click: () => {
      stack.pushPathByName('SubmitFeedBack', null);
    },
  },
  {
    id: SettingType.TERMS_OF_SERVICE,
    title: '用户协议',
    icon: $r('app.media.service'),
    click: () => {
      stack.pushPathByName('TermsOfServicePage', null);
    },
  },
  {
    id: SettingType.PRIVACY_POLICY,
    title: '隐私政策',
    icon: $r('app.media.privacy'),
    click: () => {
      stack.pushPathByName('PrivacyPolicyPage', null);
    },
  },
];
