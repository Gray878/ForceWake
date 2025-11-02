/**
 * 工具函数类
 */
export interface NextAlarmTime {
  hours: number;
  minutes: number;
}

export class Utils {
  /**
   * 格式化时间显示
   */
  static formatTime(hour: number, minute: number): string {
    const h = hour.toString().padStart(2, '0');
    const m = minute.toString().padStart(2, '0');
    return `${h}:${m}`;
  }
  
  /**
   * 格式化日期显示
   */
  static formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
  }
  
  /**
   * 计算距离下次响铃的时间
   */
  static calculateNextAlarmTime(alarms: any[]): NextAlarmTime | null {
    if (!alarms || alarms.length === 0) {
      return null;
    }
    
    const now = new Date();
    const currentMinutes = now.getHours() * 60 + now.getMinutes();
    
    let nextAlarm: any = null;
    let minDiff = Infinity;
    
    for (const alarm of alarms) {
      if (!alarm.isEnabled) continue;
      
      const alarmMinutes = alarm.hour * 60 + alarm.minute;
      let diff = alarmMinutes - currentMinutes;
      
      // 如果是重复闹钟，需要检查今天是否匹配
      if (alarm.repeatDays && alarm.repeatDays.length > 0) {
        const today = now.getDay();
        if (!alarm.repeatDays.includes(today)) {
          // 今天不响铃，找下一个匹配的日期
          continue;
        }
      }
      
      // 如果时间已过，考虑明天的同一时间
      if (diff < 0) {
        diff += 24 * 60; // 加一天
      }
      
      if (diff < minDiff) {
        minDiff = diff;
        nextAlarm = alarm;
      }
    }
    
    if (nextAlarm) {
      const hours = Math.floor(minDiff / 60);
      const minutes = minDiff % 60;
      return { hours, minutes };
    }
    
    return null;
  }
  
  /**
   * 格式化距离下次响铃时间文本
   */
  static formatNextAlarmTime(nextTime: NextAlarmTime | null): string {
    if (!nextTime) {
      return '暂无闹钟';
    }
    return `闹钟会在${nextTime.hours}小时${nextTime.minutes}分钟后响铃`;
  }
  
  /**
   * 格式化重复周期显示
   */
  static formatRepeatDays(repeatDays: number[]): string {
    if (!repeatDays || repeatDays.length === 0) {
      return '一次性';
    }
    if (repeatDays.length === 7) {
      return '每天';
    }
    const weekDays = ['日', '一', '二', '三', '四', '五', '六'];
    return repeatDays.map(day => weekDays[day]).join('');
  }
  
  /**
   * 生成唯一ID
   */
  static generateId(): string {
    return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
}

