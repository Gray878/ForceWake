# API集成说明

本文档记录了已集成的HarmonyOS系统API及其实现方式。

## 1. 扫码API集成（ScanKit）

### 功能
实现条形码/二维码扫描任务（BarcodeTask）

### 实现位置
`entry/src/main/ets/components/tasks/BarcodeTask.ets`

### 参考文档
- [ScanKit 官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/scan-introduction)

### 使用的API
- `@kit.ScanKit` - 扫码能力包
- `scan.createScanController()` - 创建扫码控制器
- `scan.ScanController.on('result')` - 监听扫码结果
- `scan.ScanController.startScan()` - 启动扫码（使用系统默认界面）
- `scan.ScanController.stopScan()` - 停止扫码
- `scan.ScanController.destroy()` - 销毁控制器

### 权限要求
- `ohos.permission.CAMERA` - 相机权限（已在module.json5中配置）

### 实现方式
采用ScanKit的**自定义界面扫码**方式：
- 调用`scan.createScanController()`创建控制器
- 调用`startScan()`启动扫码（不传入surfaceId时，系统会提供默认扫码界面）
- 通过事件回调监听扫码结果

### 实现要点
1. 使用`getContext(this)`获取页面上下文（`common.UIAbilityContext`）
2. 创建`ScanConfig`配置扫码参数：
   - `scanTypes: [scan.ScanType.ALL]` - 支持所有码类型（QR Code、条形码等）
   - `resultType: scan.ScanResultType.STRING` - 返回字符串结果
3. 注册`result`事件回调处理扫码结果
4. 验证扫码结果是否匹配目标值：
   - 如果未设置目标值（`targetValue === ''`），扫描任意码即可通过
   - 如果设置了目标值，必须完全匹配才能通过
5. 完善的错误处理：
   - 捕获创建控制器异常
   - 处理扫码过程中的错误
   - 显示友好的错误提示

### 支持的码类型
ScanKit支持以下码制式的识别：
- QR Code
- Data Matrix
- PDF417
- Aztec
- EAN-8、EAN-13
- UPC-A、UPC-E
- Codabar
- Code 39、Code 93、Code 128
- ITF-14
- MULTIFUNCTIONAL CODE（仅识别）

### 注意事项
1. **系统默认界面**：当不传入`surfaceId`调用`startScan()`时，ScanKit会打开系统默认的扫码界面，用户在该界面完成扫码后，结果会通过回调返回
2. **资源释放**：在组件销毁时（`aboutToDisappear`）必须调用`stopScan()`和`destroy()`释放资源
3. **权限检查**：确保已授予相机权限，否则扫码会失败
4. **错误处理**：扫码失败时会通过回调返回错误，需要妥善处理并提示用户

### 代码示例
```typescript
// 创建扫码配置
const scanConfig: scan.ScanConfig = {
  scanTypes: [scan.ScanType.ALL],
  resultType: scan.ScanResultType.STRING
};

// 创建控制器
this.scanController = await scan.createScanController(context, scanConfig);

// 注册结果回调
this.scanController.on('result', (err: BusinessError, result: scan.ScanResult) => {
  if (err) {
    // 处理错误
    return;
  }
  if (result && result.value) {
    // 处理扫码结果
  }
});

// 启动扫码（系统默认界面）
await this.scanController.startScan();
```

---

## 2. 相机API集成（CoreFileKit）

### 功能
实现拍照任务（PhotoTask）

### 实现位置
`entry/src/main/ets/components/tasks/PhotoTask.ets`

### 使用的API
- `@kit.CoreFileKit` - 文件能力包
- `picker.PhotoSelectOptions` - 照片选择选项
- `picker.select()` - 选择照片

### 权限要求
- `ohos.permission.CAMERA` - 相机权限
- `ohos.permission.READ_MEDIA` - 媒体读取权限（已在module.json5中配置）

### 实现要点
1. 使用照片选择器而非直接调用相机（更符合HarmonyOS规范）
2. 处理用户取消选择的情况
3. 验证照片（当前简化处理，后续可接入图像识别）

---

## 3. 传感器API集成（SensorKit）

### 功能
实现摇晃检测任务（ShakeTask）

### 实现位置
`entry/src/main/ets/components/tasks/ShakeTask.ets`

### 使用的API
- `@kit.SensorKit` - 传感器能力包
- `sensor.getSensorManager()` - 获取传感器管理器
- `sensor.getDefaultSensor(sensor.SensorId.ACCELEROMETER)` - 获取加速度传感器
- `sensorManager.on()` - 注册传感器监听

### 实现要点
1. 监听加速度传感器的变化
2. 计算加速度变化量（delta）
3. 当变化量超过阈值时，判断为一次摇晃
4. 添加时间间隔限制，防止误触发
5. 在组件销毁时释放传感器资源

### 摇晃检测算法
- 使用三维加速度差的平方和开方计算总变化量
- 阈值可配置（默认15.0）
- 最小间隔300毫秒，防止连续触发

---

## 4. 音频播放API集成（multimedia.media）

### 功能
实现闹铃声音播放

### 实现位置
`entry/src/main/ets/common/AlarmService.ets`

### 使用的API
- `@ohos.multimedia.media` - 媒体能力包
- `media.createAudioPlayer()` - 创建音频播放器
- `audioPlayer.setSource()` - 设置音频源
- `audioPlayer.prepare()` - 准备播放
- `audioPlayer.play()` - 播放音频
- `audioPlayer.stop()` - 停止播放

### 实现要点
1. 单例模式管理音频播放
2. 支持音量控制（根据闹钟设置）
3. 支持循环播放
4. 支持震动配合（TODO：需要接入vibrator）
5. 在闹钟响铃页显示时自动播放
6. 任务完成后自动停止

### 注意事项
- 音频文件需要放在`resources/rawfile`目录
- 当前使用占位URI，需要替换为实际铃声文件路径

---

## 5. 防作弊机制实现

### 功能
阻止用户在任务完成前关闭闹铃

### 实现位置
`entry/src/main/ets/pages/AlarmRingingPage.ets`

### 实现方式
使用`onBackPress()`生命周期方法阻止返回键

```typescript
onBackPress(): boolean | number {
  // 如果任务未完成，阻止返回
  if (!this.allTasksCompleted) {
    return true; // 返回true表示阻止返回
  }
  return false; // 允许返回
}
```

### 限制说明
1. ✅ **已实现**：阻止返回键
2. ⏳ **需要系统权限**：阻止应用切换到后台（需要系统级权限）
3. ⏳ **需要系统权限**：阻止关机/重启（需要系统级权限，可能需要root或特殊签名）

### 注意事项
- 阻止后台切换和阻止关机需要系统级权限，普通应用无法实现
- 实际部署时可能需要特殊权限申请或系统级签名

---

## 6. 权限配置

### 已配置的权限（module.json5）
```json
"requestPermissions": [
  {
    "name": "ohos.permission.CAMERA",
    "reason": "$string:camera_permission_reason"
  },
  {
    "name": "ohos.permission.READ_MEDIA",
    "reason": "$string:media_permission_reason"
  },
  {
    "name": "ohos.permission.MICROPHONE",
    "reason": "$string:microphone_permission_reason"
  },
  {
    "name": "ohos.permission.VIBRATE",
    "reason": "$string:vibrate_permission_reason"
  }
]
```

### 权限说明资源
已添加到`entry/src/main/resources/base/element/string.json`：
- `camera_permission_reason`: "需要相机权限以完成拍照任务"
- `media_permission_reason`: "需要媒体权限以访问照片"
- `microphone_permission_reason`: "需要麦克风权限以播放闹铃声音"
- `vibrate_permission_reason`: "需要震动权限以提供震动反馈"

---

## 7. 待完善功能

### 震动功能
- 位置：`AlarmService.ets`中的`startVibration()`和`stopVibration()`方法
- 需要接入：`@ohos.vibrator`模块
- 状态：已标记TODO，待实现

### 图像相似度匹配
- 位置：`PhotoTask.ets`中的`checkPhotoMatch()`方法
- 当前：简化处理，只要拍照就认为匹配
- 建议：使用图像识别API进行相似度比较

### 音频文件管理
- 需要：将实际铃声文件放到`resources/rawfile`目录
- 需要：根据`soundName`动态加载对应铃声文件
- 当前：使用占位URI

---

## 8. 常见问题

### Q: 为什么StorageManager中有`@kit.ArkData`和`@kit.AbilityKit`的导入错误？
A: 这可能是IDE索引问题或SDK版本问题。实际运行时应该正常。如果确实有问题，检查：
1. DevEco Studio SDK版本是否正确
2. 是否已安装相关Kit
3. 尝试同步项目或重新构建

### Q: 扫码功能如何测试？
A: 确保已授予相机权限，然后：
1. 在任务选择页选择"条形码/二维码"任务
2. 在闹钟设置中绑定该任务
3. 当闹钟响铃时，点击"开始扫描"按钮
4. 扫描任意条形码或二维码

### Q: 摇晃检测不灵敏怎么办？
A: 可以调整`ShakeTask`中的参数：
- `shakeThreshold`: 降低可以更敏感（默认15.0）
- `shakeInterval`: 减小可以更快响应（默认300毫秒）

---

## 9. 参考文档

- [ScanKit API文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/scan-introduction)
- [SensorKit API文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/sensor-service-api)
- [媒体API文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/media-kit-intro)
- [后台任务API文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-reminderagentmanager)

