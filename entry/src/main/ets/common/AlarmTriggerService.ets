/**
 * 闹钟触发服务
 * 使用HarmonyOS ReminderManager API实现系统级闹钟提醒
 * 
 * 参考文档：
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-reminderAgent-0000001477981205
 */
import { reminderAgent } from '@kit.NotificationManagerKit';
import { common } from '@kit.AbilityKit';
import { Alarm } from '../model/Alarm';
import { BusinessError } from '@kit.BasicServicesKit';
import { WantAgent } from '@kit.AbilityKit';

export class AlarmTriggerService {
  private static instance: AlarmTriggerService | null = null;
  private context: common.Context | null = null;
  
  // 存储闹钟ID到提醒ID的映射
  private alarmReminderMap: Map<string, number> = new Map();
  
  static getInstance(): AlarmTriggerService {
    if (!AlarmTriggerService.instance) {
      AlarmTriggerService.instance = new AlarmTriggerService();
    }
    return AlarmTriggerService.instance;
  }
  
  setContext(context: common.Context) {
    this.context = context;
  }
  
  /**
   * 注册闹钟提醒
   * @param alarm 闹钟对象
   */
  async registerAlarm(alarm: Alarm): Promise<boolean> {
    if (!alarm.isEnabled) {
      // 如果闹钟未启用，取消注册
      return await this.unregisterAlarm(alarm.id);
    }
    
    if (!this.context) {
      console.error('Context not available');
      return false;
    }
    
    try {
      // 先取消旧的提醒（如果存在）
      await this.unregisterAlarm(alarm.id);
      
      // 计算提醒时间
      const reminderTime = this.calculateReminderTime(alarm);
      if (!reminderTime) {
        console.error('Failed to calculate reminder time for alarm:', alarm.id);
        return false;
      }
      
      // 创建WantAgent，用于跳转到响铃页面
      const wantAgentInfo: WantAgent.WantAgentInfo = {
        wants: [{
          bundleName: this.context.applicationInfo.name,
          abilityName: 'EntryAbility',
          action: 'action.alarm.ring',
          parameters: {
            alarmId: alarm.id
          }
        }],
        operationType: WantAgent.OperationType.START_ABILITY,
        requestCode: parseInt(alarm.id.replace(/\D/g, '')) || Date.now(),
        wantAgentFlags: [WantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      
      const wantAgent = await WantAgent.getWantAgent(this.context, wantAgentInfo);
      
      // 创建提醒信息
      const reminderInfo: reminderAgent.ReminderRequest = {
        reminderType: reminderAgent.ReminderType.TIMER,
        actionButton: {
          title: '完成',
          wantAgent: wantAgent
        },
        wantAgent: wantAgent,
        maxScreenWantAgent: wantAgent,
        title: alarm.label || '闹钟',
        content: `时间到了，该起床了！`,
        snoozeTimes: 0, // 不允许小睡
        timeInterval: 0,
        notificationId: parseInt(alarm.id.replace(/\D/g, '')) || Date.now(),
        slotType: reminderAgent.SlotType.CONTENT_INFORMATION
      };
      
      // 设置提醒时间（Unix时间戳，单位：秒）
      reminderInfo.reminderTime = reminderTime;
      
      // 如果是重复闹钟，设置重复规则
      if (alarm.repeatDays && alarm.repeatDays.length > 0) {
        // 注意：ReminderManager的重复规则可能需要特殊处理
        // 这里先实现基本的一次性提醒，后续可以优化为重复提醒
        // 对于重复闹钟，系统会在每次响铃后重新注册下一次提醒
      }
      
      // 添加提醒
      const reminderId = await reminderAgent.addReminder(this.context, reminderInfo);
      this.alarmReminderMap.set(alarm.id, reminderId);
      
      console.info('Alarm registered successfully:', alarm.id, 'Reminder ID:', reminderId);
      return true;
    } catch (error) {
      const err = error as BusinessError;
      console.error('Failed to register alarm:', JSON.stringify(err));
      return false;
    }
  }
  
  /**
   * 取消注册闹钟提醒
   */
  async unregisterAlarm(alarmId: string): Promise<boolean> {
    if (!this.context) {
      return false;
    }
    
    try {
      const reminderId = this.alarmReminderMap.get(alarmId);
      if (reminderId !== undefined) {
        await reminderAgent.removeReminder(this.context, reminderId);
        this.alarmReminderMap.delete(alarmId);
        console.info('Alarm unregistered successfully:', alarmId);
        return true;
      }
      return true; // 如果没有注册，也算成功
    } catch (error) {
      console.error('Failed to unregister alarm:', error);
      return false;
    }
  }
  
  /**
   * 批量注册所有启用的闹钟
   */
  async registerAllAlarms(alarms: Alarm[]): Promise<void> {
    if (!this.context) {
      console.error('Context not available');
      return;
    }
    
    for (const alarm of alarms) {
      if (alarm.isEnabled) {
        await this.registerAlarm(alarm);
      }
    }
  }
  
  /**
   * 计算提醒时间（返回Unix时间戳，单位：秒）
   */
  private calculateReminderTime(alarm: Alarm): number | null {
    const now = new Date();
    const currentMinutes = now.getHours() * 60 + now.getMinutes();
    const alarmMinutes = alarm.hour * 60 + alarm.minute;
    
    let targetDate = new Date();
    targetDate.setHours(alarm.hour, alarm.minute, 0, 0);
    
    // 如果是重复闹钟
    if (alarm.repeatDays && alarm.repeatDays.length > 0) {
      const today = now.getDay();
      const alarmDay = alarm.repeatDays.find(day => day === today);
      
      if (alarmDay === undefined) {
        // 今天不在重复列表中，找下一个匹配的日期
        let daysToAdd = 1;
        let found = false;
        
        for (let i = 0; i < 7; i++) {
          const checkDay = (today + daysToAdd) % 7;
          if (alarm.repeatDays.includes(checkDay)) {
            found = true;
            break;
          }
          daysToAdd++;
        }
        
        if (found) {
          targetDate.setDate(targetDate.getDate() + daysToAdd);
        } else {
          // 没有找到匹配的日期（理论上不会发生）
          return null;
        }
      } else if (alarmMinutes <= currentMinutes) {
        // 今天已经过了闹钟时间，找下一个匹配的日期
        let daysToAdd = 1;
        let found = false;
        
        for (let i = 0; i < 7; i++) {
          const checkDay = (today + daysToAdd) % 7;
          if (alarm.repeatDays.includes(checkDay)) {
            found = true;
            break;
          }
          daysToAdd++;
        }
        
        if (found) {
          targetDate.setDate(targetDate.getDate() + daysToAdd);
        }
      }
    } else {
      // 一次性闹钟
      if (alarmMinutes <= currentMinutes) {
        // 今天已经过了，设置明天
        targetDate.setDate(targetDate.getDate() + 1);
      }
    }
    
    // 返回Unix时间戳（秒）
    return Math.floor(targetDate.getTime() / 1000);
  }
  
  /**
   * 获取提醒ID
   */
  getReminderId(alarmId: string): number | undefined {
    return this.alarmReminderMap.get(alarmId);
  }
}

