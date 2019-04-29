
//
//  FavoriteModel.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "FavoriteModel.h"

@implementation FavoriteModel

+ (NSArray *)dataForFavoriteList {
    
    NSArray *images = @[@"f_cocoa",@"chat_public",@"chat1"];
    NSArray *titles = @[@"iOSer：我是如何6天面试了6家硅谷顶级公司并拿下了6份Offer的？",
                        @"手机了一些好看又超实用的工具资料",
                        @"f卫生间用淋浴房还是浴帘？"];
    NSArray *authors = @[@"Cocoa开发者社区",@"Larry",@"装修学"];
    NSArray *times = @[@"2019/2/6",@"2018/11/30",@"2018/5/14"];
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
        FavoriteModel *model = [[FavoriteModel alloc] init];
        model.iconName = images[i];
        model.title = titles[i];
        model.author = authors[i];
        model.time = times[i];
        model.type = FavoriteTypeLink;
        [mArray addObject:model];
    }
    
    return [mArray copy];
}
@end
