@ObservedV2
export class FeedBack {
  @Trace date: string = '';
  @Trace content: string = '';
  @Trace imgUrls: string[] = [];
}

@ObservedV2
export class FeedBacks {
  @Trace contents: FeedBack[] = [];
}

export interface FeedBackBody {
  date: string;
  content: string;
  imgUrls: string[];
}