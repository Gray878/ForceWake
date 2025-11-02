/**
 * 闹钟服务和音频播放管理
 */
import { Alarm } from '../model/Alarm';
import media from '@ohos.multimedia.media';
import common from '@ohos.app.ability.common';

export class AlarmService {
  private static instance: AlarmService | null = null;
  private audioPlayer: media.AudioPlayer | null = null;
  private context: common.Context | null = null;
  
  static getInstance(): AlarmService {
    if (!AlarmService.instance) {
      AlarmService.instance = new AlarmService();
    }
    return AlarmService.instance;
  }
  
  setContext(context: common.Context) {
    this.context = context;
  }
  
  /**
   * 播放闹铃声音
   */
  async playAlarmSound(alarm: Alarm): Promise<void> {
    try {
      // 停止之前的播放
      await this.stopAlarmSound();
      
      // 创建音频播放器
      const audioPlayerOptions: media.AudioPlayerOptions = {
        loop: true, // 循环播放
        volume: alarm.volume / 100.0
      };
      
      // TODO: 使用实际的铃声文件路径
      // 这里需要将铃声文件放在 resources/rawfile 目录下
      const uri = 'file:///data/storage/el2/base/haps/entry/files/alarm_sound.mp3';
      
      this.audioPlayer = await media.createAudioPlayer();
      
      // 设置播放选项
      this.audioPlayer.on('prepare', () => {
        this.audioPlayer?.play();
      });
      
      this.audioPlayer.on('error', (error: Error) => {
        console.error('AudioPlayer error:', error);
      });
      
      // 设置音频源（简化处理，实际需要根据soundName加载对应文件）
      await this.audioPlayer.setSource(uri);
      await this.audioPlayer.prepare();
      
      // 如果有震动
      if (alarm.isVibrationEnabled) {
        this.startVibration();
      }
    } catch (error) {
      console.error('Failed to play alarm sound:', error);
    }
  }
  
  /**
   * 停止闹铃声音
   */
  async stopAlarmSound(): Promise<void> {
    try {
      if (this.audioPlayer) {
        await this.audioPlayer.stop();
        await this.audioPlayer.release();
        this.audioPlayer = null;
      }
      this.stopVibration();
    } catch (error) {
      console.error('Failed to stop alarm sound:', error);
    }
  }
  
  /**
   * 开始震动
   */
  private async startVibration(): Promise<void> {
    try {
      // TODO: 实现震动功能
      // 需要导入 vibrator 模块
      // import vibrator from '@ohos.vibrator';
      // await vibrator.startVibration({type: 'time', duration: 1000}, {id: 0});
    } catch (error) {
      console.error('Failed to start vibration:', error);
    }
  }
  
  /**
   * 停止震动
   */
  private async stopVibration(): Promise<void> {
    try {
      // TODO: 实现停止震动
      // import vibrator from '@ohos.vibrator';
      // await vibrator.stopVibration({id: 0});
    } catch (error) {
      console.error('Failed to stop vibration:', error);
    }
  }
}

