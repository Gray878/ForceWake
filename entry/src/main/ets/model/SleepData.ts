/**
 * 睡眠数据模型
 */
export interface SleepReminder {
  isEnabled: boolean; // 是否启用
  hour: number; // 提醒小时
  minute: number; // 提醒分钟
}

export interface SleepRecord {
  date: string; // 日期 YYYY-MM-DD
  sleepTime: number; // 睡眠时长（分钟）
  sleepEfficiency: number; // 睡眠效率（百分比）
  snoringCount: number; // 打鼾次数
}

export interface MorningFeeling {
  date: string; // 日期
  feeling: EmotionType; // 感觉类型
  note?: string; // 备注
}

export enum EmotionType {
  HAPPY = 'happy', // 开心
  NORMAL = 'normal', // 一般
  SAD = 'sad', // 难过
  TIRED = 'tired' // 疲惫
}

export interface WakeUpScore {
  date: string; // 日期
  score: number; // 得分 (0-100)
  completedTasks: number; // 完成任务数
  totalTasks: number; // 总任务数
  completionTime: number; // 完成任务耗时（秒）
}

