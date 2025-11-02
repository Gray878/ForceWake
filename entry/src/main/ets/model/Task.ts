/**
 * 任务数据模型
 */
export enum TaskType {
  MATH = 'math', // 数学题
  MEMORY = 'memory', // 记忆游戏
  BARCODE = 'barcode', // 条形码/二维码
  PHOTO = 'photo', // 拍照
  SHAKE = 'shake' // 摇晃
}

export enum TaskCategory {
  BRAIN = 'brain', // 唤醒大脑
  BODY = 'body' // 唤醒身体
}

export interface Task {
  id: string; // 唯一标识
  type: TaskType; // 任务类型
  category: TaskCategory; // 任务分类
  name: string; // 任务名称
  icon: string; // 图标资源
  difficulty: number; // 难度级别 (1=简单, 2=中等, 3=困难)
  config: TaskConfig; // 任务配置
}

export interface TaskConfig {
  // 数学题配置
  mathCount?: number; // 题目数量
  mathLevel?: number; // 难度等级
  
  // 记忆游戏配置
  memoryPairs?: number; // 配对数量
  
  // 条形码/二维码配置
  barcodeValue?: string; // 保存的条形码值
  
  // 拍照配置
  photoPath?: string; // 预设照片路径
  
  // 摇晃配置
  shakeCount?: number; // 摇晃次数
  shakeThreshold?: number; // 加速度阈值
}

