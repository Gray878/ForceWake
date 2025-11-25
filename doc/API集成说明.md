# API集成说明

本文档记录了已集成的HarmonyOS系统API及其实现方式。

## 1. 扫码API集成（ScanKit）

### 功能
实现条形码/二维码扫描任务（BarcodeTask）

### 实现位置
`entry/src/main/ets/components/tasks/BarcodeTask.ets`

### 参考文档
- [ScanKit 官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/scan-introduction)
- [官方示例项目](example/scan-kit_-sample-code_-clientdemo_-arkts)

### 使用的API
- `@kit.ScanKit` - 扫码能力包
- `scanBarcode.startScanForResult()` - 启动默认界面扫码（推荐方式）
- `scanCore.ScanType` - 扫码类型枚举
- `scanCore.ScanErrorCode` - 扫码错误码枚举

### 权限要求
- `ohos.permission.CAMERA` - 相机权限（已在module.json5中配置）

### 实现方式
采用ScanKit的**默认界面扫码**方式（推荐）：
- 调用`scanBarcode.startScanForResult()`直接启动系统默认扫码界面
- 系统自动管理扫码界面和资源生命周期
- 通过Promise返回扫码结果，代码简洁高效

### 实现要点
1. **导入模块**：
   ```typescript
   import { scanBarcode, scanCore } from '@kit.ScanKit';
   ```

2. **获取页面上下文**：
   ```typescript
   const context = getContext(this) as common.UIAbilityContext;
   ```

3. **调用扫码API**：
   ```typescript
   const result = await scanBarcode.startScanForResult(context, {
     scanTypes: [scanCore.ScanType.ALL], // 支持所有码类型
     enableMultiMode: false, // 单码模式
     enableAlbum: false // 不启用相册入口
   });
   ```

4. **处理扫码结果**：
   - `result.originalValue` - 扫码结果字符串
   - `result.scanType` - 码类型
   - 验证结果是否匹配目标值

5. **错误处理**：
   - `scanCore.ScanErrorCode.SCAN_SERVICE_CANCELED` - 用户取消扫码
   - 其他错误需要提示用户

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
1. **系统默认界面**：`startScanForResult()`会自动打开系统默认的扫码界面，用户体验一致
2. **资源管理**：系统自动管理扫码资源，无需手动释放，代码更简洁
3. **权限检查**：确保已授予相机权限，否则扫码会失败
4. **错误处理**：用户取消扫码时不会抛出异常，返回`SCAN_SERVICE_CANCELED`错误码
5. **异步处理**：扫码是异步操作，使用async/await或Promise处理结果

### 代码示例
```typescript
// 获取页面上下文
const context = getContext(this) as common.UIAbilityContext;

// 调用默认界面扫码API
const result: scanBarcode.ScanResult = await scanBarcode.startScanForResult(context, {
  scanTypes: [scanCore.ScanType.ALL], // 支持所有码类型
  enableMultiMode: false, // 单码模式，只返回第一个扫码结果
  enableAlbum: false // 不启用相册入口
});

// 处理扫码结果
if (result && result.originalValue) {
  const scannedValue = result.originalValue;
  // 验证是否匹配目标值
  if (targetValue === '' || scannedValue === targetValue) {
    // 匹配成功，完成任务
  }
}

// 错误处理
catch (error: BusinessError) {
  if (error.code === scanCore.ScanErrorCode.SCAN_SERVICE_CANCELED) {
    // 用户取消扫码，不显示错误
  } else {
    // 其他错误，提示用户
  }
}
```

### 优势
相比自定义界面扫码方式，默认界面扫码具有以下优势：
1. **代码简洁**：无需创建控制器、注册回调、手动释放资源
2. **系统管理**：扫码界面和资源由系统自动管理
3. **用户体验**：使用系统统一的扫码界面，体验一致
4. **维护成本低**：代码量少，出错概率低

---

## 2. 相机API集成（MediaLibraryKit）

### 功能
实现拍照任务（PhotoTask）

### 实现位置
`entry/src/main/ets/components/tasks/PhotoTask.ets`

### 参考文档
- [MediaLibraryKit 官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-photoAccessHelper)
- 参考示例：`example/ComprehensiveTool1.0.0/entry/src/main/ets/utils/FileSelect.ets`

### 使用的API
- `@kit.MediaLibraryKit` - 媒体库能力包
- `photoAccessHelper.PhotoViewPicker` - 图片选择器
- `photoAccessHelper.PhotoSelectOptions` - 照片选择选项
- `photoPicker.select()` - 选择照片（支持拍照和相册选择）

### 权限要求
- `ohos.permission.CAMERA` - 相机权限（已在module.json5中配置）
- `ohos.permission.READ_MEDIA` - 媒体读取权限（已在module.json5中配置）

### 实现方式
采用MediaLibraryKit的**图片选择器**方式：
- 使用`PhotoViewPicker`创建图片选择器
- 配置`PhotoSelectOptions`设置选择参数
- 调用`select()`方法打开图片选择界面
- 用户可以选择拍照或从相册选择图片

### 实现要点
1. **创建选择选项**：
   ```typescript
   let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
   photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
   photoSelectOptions.maxSelectNumber = 1; // 最多选择1张
   ```

2. **创建选择器并调用**：
   ```typescript
   let photoPicker = new photoAccessHelper.PhotoViewPicker();
   let photoSelectResult = await photoPicker.select(photoSelectOptions);
   ```

3. **处理选择结果**：
   - 检查`photoSelectResult.photoUris`是否为空
   - 验证URI格式（`media/Photo`或`file://`）
   - 保存照片路径到`photoPath`和`photoUri`

4. **用户取消处理**：
   - 如果用户取消选择，`photoSelectResult`可能为空或`photoUris`为空
   - 不显示错误信息，静默处理

5. **照片验证**：
   - 当前简化处理：只要有照片就认为匹配
   - 后续可接入图像识别API进行相似度比较

### 优势
相比直接调用相机API，图片选择器方式具有以下优势：
1. **用户体验好**：用户可以选择拍照或从相册选择，更灵活
2. **代码简洁**：无需管理相机预览、拍照会话等复杂逻辑
3. **系统管理**：图片选择界面由系统提供，体验一致
4. **权限处理**：系统自动处理权限申请

### 代码示例
```typescript
// 设置图片选择选项
let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
photoSelectOptions.maxSelectNumber = 1;

// 创建图片选择器
let photoPicker = new photoAccessHelper.PhotoViewPicker();

// 选择图片（用户可以选择拍照或从相册选择）
let photoSelectResult = await photoPicker.select(photoSelectOptions);

// 处理结果
if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
  const selectedUri = photoSelectResult.photoUris[0];
  // 保存照片路径
  this.photoPath = selectedUri;
  this.photoUri = selectedUri;
}
```

### 注意事项
1. **URI格式**：选择器返回的URI格式可能是`media/Photo`或`file://`，需要验证
2. **用户取消**：用户取消选择时，`photoSelectResult`可能为空，需要妥善处理
3. **权限检查**：确保已授予相机和媒体读取权限
4. **图片验证**：当前简化处理，后续可接入图像识别API

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

