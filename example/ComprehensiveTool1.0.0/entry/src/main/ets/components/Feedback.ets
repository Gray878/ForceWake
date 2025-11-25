/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { FeedbackItemType } from '../model/FeedbackRecordModel';
import { fileSelect, getDateStringWithTimeStamp } from '../utils/FileSelect';
import { display } from '@kit.ArkUI';

@ComponentV2
export struct Feedback {
  text?: ResourceStr;
  //输入的内容
  @Local content: string = '';
  //传入问题描述的最大字数
  @Param des: number = 100;
  //传入问题截图需要的最大数量
  @Param num: number = 3;
  //监听问题描述输入的长度
  @Local desLength: number = 0;
  //监听电话号码输入的长度
  @Local phoneLength: number = 0;
  //获取选择图片后的url数组
  @Local stageImageUris: Array<string> = [];
  @Local imageUris: Array<string> = [];
  @Local phoneValue: string = '';
  @Local picWidth: number = 0;
  @Local feedList: FeedbackItemType = {
    description: '',
    stageImageUris: [],
    phone: '',
    time: '',
  };
  @Event butOnClick: (feedList: FeedbackItemType) => void;

  aboutToAppear(): void {
    let displayClass: display.Display | null = null;
    try {
      displayClass = display.getDefaultDisplaySync();
      let widthByVp = px2vp(displayClass.width);
      this.picWidth = Math.floor((widthByVp - 32 - ((this.num - 1) * 8)) / this.num);
    } catch (exception) {
      console.error(`Failed to get default display. Code: ${exception.code}, message: ${exception.message}`);
    }
  }

  build() {
    Column() {
      Row().height(8).width('100%').backgroundColor($r('sys.color.background_secondary'));
      // 问题描述
      Column({ space: 24 }) {
        this.feedDes();
        // 问题截图
        this.feedPic();
      };

      Row().height(8).width('100%').backgroundColor($r('sys.color.background_secondary'));

      // 联系方式
      this.feedPhone();

      // 提交按钮
      this.submitButton();
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 16, right: 16 });
  }

  // 选择图像
  async selectImage() {
    let uris = await fileSelect(this.stageImageUris, this.num - this.feedList.stageImageUris.length);
    this.imageUris.push(...uris);
  }

  // 提交按钮
  @Builder
  submitButton() {
    Row() {
      Button('提交反馈')
        .borderRadius(20)
        .fontColor($r('sys.color.font_on_primary'))
        .backgroundColor($r('sys.color.comp_background_emphasize'))
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Medium)
        .opacity(this.content.length ? 1 : 0.4)
        .enabled(this.content.length ? true : false)
        .height(40)
        .width('100%')
        .onClick(async () => {
          if (this.feedList.description.length > 0) {
            if (this.phoneLength === 0 || this.phoneLength === 11) {
              //获取当前时间
              this.feedList.stageImageUris = this.imageUris;
              this.feedList.time = getDateStringWithTimeStamp();
              this.butOnClick(this.feedList);
              // 清空提交内容
              this.content = '';
              this.text = '';
              this.imageUris = [];
            } else {
              this.getUIContext().getPromptAction().showToast({ message: '请输入11位正确的电话号码', duration: 2000 });
            }
          } else {
            this.getUIContext().getPromptAction().showToast({ message: '请填写问题描述', duration: 2000 });
          }
        });
    }.width('100%').padding({ left: 16, right: 16 }).position({ x: 0, y: '80%' });
  }

  // 问题描述
  @Builder
  feedDes() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      TextArea({ placeholder: '请详细描述您的问题（必填）', text: this.content })
        .placeholderFont({ size: $r('sys.float.Body_S'), weight: 'regular' })
        .width('100%')
        .height(150)
        .backgroundColor($r('sys.color.comp_background_list_card'))
        .maxLength(this.des)
        .onChange((value: string) => {
          this.content = value;
          this.feedList.description = value;
          this.desLength = value.length;
        })
        .gesture(
          LongPressGesture({ repeat: true })// 由于repeat设置为true，长按动作存在时会连续触发，触发间隔为duration（默认值500ms）
            .onAction((event: GestureEvent) => {
              console.info('LongPressGesture start');
            })// 长按动作一结束触发
            .onActionEnd((event: GestureEvent) => {
              console.info('LongPressGesture end');
            }),
        );

      Text(`${this.desLength}/${this.des}`)
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Regular)
        .fontColor($r('sys.color.font_secondary'));
    }.backgroundColor($r('sys.color.comp_background_primary'))
    .padding({ right: 12, bottom: 12, top: 12 }).borderRadius(16);
  }

  // 问题截图
  @Builder
  feedPic() {
    Column({ space: 8 }) {
      Text('上传图片').fontSize(14).opacity(0.6).width('100%').textAlign(TextAlign.Start);

      List({ space: 8 }) {
        ForEach(this.imageUris, (item: string, index: number) => {
          ListItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item ? item : $r('app.media.ic_close_circle'))
                .width(this.picWidth)
                .height(this.picWidth)
                .objectFit(ImageFit.Cover)
                .borderRadius(5);
              Image($r('app.media.ic_close_circle'))
                .width(22)
                .height(22)
                .margin({ top: 2, right: 2 })
                .onClick(() => {
                  this.imageUris.splice(index, 1);
                  this.feedList.stageImageUris.splice(index, 1);
                });
            };
          };
        }, (item: string, index: number) => item + index);

        ListItem() {
          if (this.imageUris.length < this.num) {
            Row() {
              Image($r('app.media.add_pic')).size({ height: this.picWidth, width: this.picWidth });
            }
            .backgroundColor($r('sys.color.background_secondary'))
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.selectImage();
            });
          }
        };
      }
      .width('100%')
      .height(this.picWidth)
      .borderRadius(16)
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off);
    };
  }

  // 联系方式
  @Builder
  feedPhone() {
    Column({ space: 12 }) {
      Row() {
        Text('请留下您的联系方式')
          .fontSize(14).opacity(0.6)
          .fontColor($r('sys.color.font_primary'));
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween);

      TextInput({ placeholder: '手机号码（选填）', text: this.text })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .type(InputType.PhoneNumber)
        .maxLength(11)
        .onChange((value: string) => {
          this.phoneLength = value.length;
          this.phoneValue = value;
        })
        .gesture(
          LongPressGesture({ repeat: true })// 由于repeat设置为true，长按动作存在时会连续触发，触发间隔为duration（默认值500ms）
            .onAction((event: GestureEvent) => {
              console.info('LongPressGesture start');
            })// 长按动作一结束触发
            .onActionEnd((event: GestureEvent) => {
              console.info('LongPressGesture end');
            }),
        )
        .onBlur(() => {
          if (this.phoneLength === 11 || this.phoneLength === 0) {
            this.feedList.phone = this.phoneValue;
          } else {
            this.getUIContext().getPromptAction().showToast({ message: '请输入11位正确的电话号码', duration: 2000 });
          }
        })
        .onWillInsert((info: InsertValue) => {
          // 在将要输入时调用的回调。在返回true时，表示正常插入，返回false时，表示不插入。
          if (info.insertValue.startsWith(' ')) {
            return false;
          } else {
            return true;
          }
        });
    };
  }
}

@Builder
export function FeedbackBuilder() {
  Feedback();
}
