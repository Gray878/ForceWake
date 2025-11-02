/**
 * 早上页面
 */
@Component
export struct MorningPage {
  build() {
    Column() {
      // 标题
      Text($r('app.string.morning'))
        .fontSize(24)
        .fontColor($r('app.color.text_primary'))
        .fontWeight(FontWeight.Bold)
        .alignSelf(ItemAlign.Start)
        .margin({ left: 16, top: 16, bottom: 24 })
      
      Scroll() {
        Column() {
          // 起床得分卡片
          Column() {
            Row() {
              Text($r('app.string.wake_up_score'))
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
                .fontWeight(FontWeight.Medium)
              
              Blank()
              
              Text('>')
                .fontSize(16)
                .fontColor($r('app.color.text_secondary'))
            }
            .width('100%')
            .margin({ bottom: 16 })
            
            // 闹钟图标（模拟）
            Column() {
              Text('⏰')
                .fontSize(60)
                .margin({ bottom: 8 })
              
              Text('早上见')
                .fontSize(14)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .padding({ top: 24, bottom: 24 })
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 16 })
          
          // 早晨感觉卡片
          Row() {
            Text($r('app.string.morning_feeling'))
              .fontSize(16)
              .fontColor($r('app.color.text_primary'))
              .fontWeight(FontWeight.Medium)
            
            Blank()
            
            Text('😊')
              .fontSize(24)
              .margin({ right: 8 })
            
            Text('>')
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .backgroundColor($r('app.color.card_background'))
          .borderRadius(12)
          .margin({ left: 16, right: 16 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
}
