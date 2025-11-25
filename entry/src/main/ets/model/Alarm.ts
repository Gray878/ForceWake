/**
 * 闹钟数据模型
 */
import { TaskConfig } from './Task';

export interface Alarm {
  id: string; // 唯一标识
  hour: number; // 小时 (0-23)
  minute: number; // 分钟 (0-59)
  isEnabled: boolean; // 是否启用
  repeatDays: number[]; // 重复日期 [0=周日, 1=周一, ..., 6=周六]，空数组表示一次性
  label: string; // 闹钟标签/名称
  volume: number; // 音量 (0-100)
  isVibrationEnabled: boolean; // 是否震动
  soundName: string; // 铃声名称
  tasks: string[]; // 绑定的任务ID列表
  taskConfigs?: Record<string, TaskConfig>; // 任务配置映射，key为任务ID，value为任务配置
  createdAt: number; // 创建时间戳
  updatedAt: number; // 更新时间戳
}

export enum AlarmRepeatType {
  ONCE = 'once', // 一次性
  WEEKLY = 'weekly' // 每周重复
}

