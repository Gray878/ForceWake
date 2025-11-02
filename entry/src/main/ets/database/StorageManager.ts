/**
 * 数据持久化管理类
 * 使用Preference存储应用数据
 */
import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';
import { Alarm } from '../model/Alarm';
import { Constants } from '../common/Constants';
import { SleepReminder } from '../model/SleepData';

export class StorageManager {
  private static instance: StorageManager;
  private dataPreferences: preferences.Preferences | null = null;
  private context: Context | null = null;
  
  private constructor() {}
  
  /**
   * 获取单例实例
   */
  static getInstance(): StorageManager {
    if (!StorageManager.instance) {
      StorageManager.instance = new StorageManager();
    }
    return StorageManager.instance;
  }
  
  /**
   * 初始化Preference
   */
  async init(context: Context): Promise<void> {
    this.context = context;
    try {
      this.dataPreferences = await preferences.getPreferences(context, 'alarm_data');
    } catch (error) {
      console.error('Failed to init preferences:', error);
    }
  }
  
  /**
   * 确保Preference已初始化
   */
  private ensureInitialized(): boolean {
    if (!this.dataPreferences || !this.context) {
      console.error('StorageManager not initialized');
      return false;
    }
    return true;
  }
  
  /**
   * 获取所有闹钟
   */
  async getAlarms(): Promise<Alarm[]> {
    if (!this.ensureInitialized()) {
      return [];
    }
    try {
      const alarmsJson = await this.dataPreferences.get(Constants.STORAGE_KEY_ALARMS, '[]');
      return JSON.parse(alarmsJson as string);
    } catch (error) {
      console.error('Failed to get alarms:', error);
      return [];
    }
  }
  
  /**
   * 保存所有闹钟
   */
  async saveAlarms(alarms: Alarm[]): Promise<boolean> {
    if (!this.ensureInitialized()) {
      return false;
    }
    try {
      await this.dataPreferences.put(Constants.STORAGE_KEY_ALARMS, JSON.stringify(alarms));
      await this.dataPreferences.flush();
      return true;
    } catch (error) {
      console.error('Failed to save alarms:', error);
      return false;
    }
  }
  
  /**
   * 添加闹钟
   */
  async addAlarm(alarm: Alarm): Promise<boolean> {
    const alarms = await this.getAlarms();
    alarms.push(alarm);
    return await this.saveAlarms(alarms);
  }
  
  /**
   * 更新闹钟
   */
  async updateAlarm(alarm: Alarm): Promise<boolean> {
    const alarms = await this.getAlarms();
    const index = alarms.findIndex(a => a.id === alarm.id);
    if (index >= 0) {
      alarms[index] = alarm;
      return await this.saveAlarms(alarms);
    }
    return false;
  }
  
  /**
   * 删除闹钟
   */
  async deleteAlarm(alarmId: string): Promise<boolean> {
    const alarms = await this.getAlarms();
    const filtered = alarms.filter(a => a.id !== alarmId);
    return await this.saveAlarms(filtered);
  }
  
  /**
   * 获取睡眠提醒设置
   */
  async getSleepReminder(): Promise<SleepReminder> {
    if (!this.ensureInitialized()) {
      return { isEnabled: false, hour: 23, minute: 0 };
    }
    try {
      const reminderJson = await this.dataPreferences.get(Constants.STORAGE_KEY_SLEEP_REMINDER, '{"isEnabled":false,"hour":23,"minute":0}');
      return JSON.parse(reminderJson as string);
    } catch (error) {
      console.error('Failed to get sleep reminder:', error);
      return { isEnabled: false, hour: 23, minute: 0 };
    }
  }
  
  /**
   * 保存睡眠提醒设置
   */
  async saveSleepReminder(reminder: SleepReminder): Promise<boolean> {
    if (!this.ensureInitialized()) {
      return false;
    }
    try {
      await this.dataPreferences.put(Constants.STORAGE_KEY_SLEEP_REMINDER, JSON.stringify(reminder));
      await this.dataPreferences.flush();
      return true;
    } catch (error) {
      console.error('Failed to save sleep reminder:', error);
      return false;
    }
  }
  
  /**
   * 获取通用设置
   */
  async getSettings(): Promise<any> {
    if (!this.ensureInitialized()) {
      return {};
    }
    try {
      const settingsJson = await this.dataPreferences.get(Constants.STORAGE_KEY_SETTINGS, '{}');
      return JSON.parse(settingsJson as string);
    } catch (error) {
      console.error('Failed to get settings:', error);
      return {};
    }
  }
  
  /**
   * 保存通用设置
   */
  async saveSettings(settings: any): Promise<boolean> {
    if (!this.ensureInitialized()) {
      return false;
    }
    try {
      await this.dataPreferences.put(Constants.STORAGE_KEY_SETTINGS, JSON.stringify(settings));
      await this.dataPreferences.flush();
      return true;
    } catch (error) {
      console.error('Failed to save settings:', error);
      return false;
    }
  }
}

