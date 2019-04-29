//
//  ChatModel.h
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ChatCellType) {
    ChatCellTypeMessage,
    ChatCellTypePubliction,
    ChatCellTypeSubscription
};

NS_ASSUME_NONNULL_BEGIN

@interface ChatModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *lastMessage;

@property (nonatomic, assign) ChatCellType messageType;

+ (NSMutableArray *)requestDataArray;

@end

NS_ASSUME_NONNULL_END
