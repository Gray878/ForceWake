/**
 * 应用常量定义
 */
export class Constants {
  // 存储键名
  static readonly STORAGE_KEY_ALARMS = 'alarms';
  static readonly STORAGE_KEY_SLEEP_REMINDER = 'sleep_reminder';
  static readonly STORAGE_KEY_SETTINGS = 'settings';
  
  // 星期标签
  static readonly WEEK_DAYS = ['日', '一', '二', '三', '四', '五', '六'];
  
  // 任务类型配置
  static readonly TASK_TYPES = {
    MATH: {
      name: '数学题',
      category: 'brain',
      icon: 'assets/icons/math.png'
    },
    MEMORY: {
      name: '记忆游戏',
      category: 'brain',
      icon: 'assets/icons/memory.png'
    },
    BARCODE: {
      name: '条形码/二维码',
      category: 'body',
      icon: 'assets/icons/barcode.png'
    },
    SHAKE: {
      name: '甩甩',
      category: 'body',
      icon: 'assets/icons/shake.png'
    },
    PHOTO: {
      name: '拍照',
      category: 'body',
      icon: 'assets/icons/photo.png'
    }
  };
  
  // 默认设置
  static readonly DEFAULT_VOLUME = 80;
  static readonly DEFAULT_VIBRATION = true;
  static readonly DEFAULT_SOUND = 'Orkney';
  
  // 颜色主题
  static readonly COLORS = {
    PRIMARY: '#FF3D3D',
    BACKGROUND: '#000000',
    CARD_BACKGROUND: '#1C1C1E',
    TEXT_PRIMARY: '#FFFFFF',
    TEXT_SECONDARY: '#8E8E93',
    ACCENT_BLUE: '#007AFF',
    ACCENT_PURPLE: '#AF52DE'
  };
}

