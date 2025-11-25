import { promptAction } from '@kit.ArkUI';
import { addFeedBack, queryFeedBack } from '../apis/APIList';
import { FeedbackItemType } from '../model/FeedbackRecordModel';
import { FeedBackBody, FeedBacks } from '../model/FeedBacks';

@ObservedV2
export class MineVM {
  @Trace feedbacks: FeedBacks = new FeedBacks();
  private static _instance: MineVM;

  public static get instance() {
    if (!MineVM._instance) {
      MineVM._instance = new MineVM();
    }
    return MineVM._instance;
  }

  queryFeedbacks() {
    queryFeedBack().then((res) => {
      this.feedbacks = res.data;
    });
  }

  submit(item: FeedbackItemType) {
    let param: FeedBackBody = {
      date: item.time,
      content: item.description,
      imgUrls: item.stageImageUris,
    };
    addFeedBack(param).then((res) => {
      if (res.status === 200) {
        promptAction.showToast({ message: '提交成功，感谢您的反馈~', duration: 1000 });
      }
    });
  }
}