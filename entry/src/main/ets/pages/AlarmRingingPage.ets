/**
 * 闹钟响铃页面
 */
@Component
export struct AlarmRingingPage {
  build() {
    Column() {
      Text('闹钟响铃页面')
        .fontSize(24)
        .fontColor($r('app.color.text_primary'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
    .justifyContent(FlexAlign.Center)
  }
}

