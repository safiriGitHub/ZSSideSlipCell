
//
//  ChatModel.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

+ (NSMutableArray *)requestDataArray {
    NSArray *images = @[@"chat1", @"chat2", @"chat3", @"chat4", @"chat5",@"chat_public",@"chat_subscribe"];
    NSArray *names = @[@"Louis", @"大东", @"大腾", @"飞飞", @"Joe",@"丰巢智能柜",@"订阅号消息"];
    NSArray *times = @[@"下午3:45", @"下午23:45", @"昨天", @"星期五", @"2019/4/9",@"下午3:28",@"下午3:50"];
    NSArray *lastMessages = @[@"[视频通话]",
                             @"今天天气很好啊, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?",
                             @"五一提前购 苏宁更优惠[拳头][拳头]🎉🎉",
                             @"飞哥不懂啊[快哭了]",
                             @"What can i do for you?",
                             @"取件通知",
                             @"人民日报：全球首发！动画版阿卡贝拉《植物总动员》"];
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSInteger i = 0; i < images.count; i++) {
        ChatModel *model = [[ChatModel alloc] init];
        model.iconName = images[i];
        model.userName = names[i];
        model.timeString = times[i];
        model.lastMessage = lastMessages[i];
        model.messageType = ChatCellTypeMessage;
        if (i == 5) model.messageType = ChatCellTypePubliction;
        if (i == 6) model.messageType = ChatCellTypeSubscription;
        [mArray addObject:model];
        
    }

    return mArray;
}

@end
