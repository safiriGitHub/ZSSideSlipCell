//
//  ZSSideSlipAction.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/26.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ZSSideSlipAction.h"

@interface ZSSideSlipAction ()



@end

@implementation ZSSideSlipAction

+ (instancetype)actionWithStyle:(ZSSideslipCellActionStyle)style title:(NSString *)title handler:(ActionHandler)handler {
    ZSSideSlipAction *action = [[ZSSideSlipAction alloc] init];
    action.style = style;
    action.title = title;
    action.handler = handler;
    return action;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titleColor = [UIColor whiteColor];
        _font = [UIFont systemFontOfSize:17];
        self.style = ZSSideslipCellActionStyleDefault;
    }
    return self;
}

- (void)setStyle:(ZSSideslipCellActionStyle)style {
    _style = style;
    if (style == ZSSideslipCellActionStyleDefault) {
        self.backgroundColor = [UIColor redColor];
    }
    else if (style == ZSSideslipCellActionStyleNormal) {
        self.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:205/255.0 alpha:1];
    }
}

- (CGFloat)margin {
    return _margin == 0 ? 15 : _margin;
}

@end
