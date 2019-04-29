//
//  ZSSideSlipContainerView.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/26.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ZSSideSlipContainerView.h"
#import "ZSSideSlipAction.h"

void ZS_setH(UIView *v, CGFloat h) {
    CGRect frame = v.frame;
    frame.size.height = h;
    v.frame = frame;
};

@interface ZSSideSlipContainerView ()

@property (nonatomic, strong) NSMutableArray <NSNumber *>*originWidths;
@property (nonatomic, strong, readwrite) NSArray *originSubViews;
@property (nonatomic, assign, readwrite) CGFloat totalWidth;

@property (nonatomic, strong, readwrite) NSArray *subButtons;

@property (nonatomic, assign) CGFloat currentSubViewHeight;

@end

@implementation ZSSideSlipContainerView


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.frame.size.height != self.currentSubViewHeight) {
        //修改子View高度
        for (UIView *btnBgView in self.subviews) {
            //同步一下新的高度
            ZS_setH(btnBgView, CGRectGetHeight(self.frame));
            btnBgView.frame = CGRectMake(btnBgView.frame.origin.x, btnBgView.frame.origin.y, btnBgView.frame.size.width, self.frame.size.height);
            if (btnBgView.subviews.firstObject) {
                btnBgView.subviews.firstObject.frame = CGRectMake(0, btnBgView.subviews.firstObject.frame.origin.y, btnBgView.subviews.firstObject.frame.size.width, self.frame.size.height);
            }
        }
        self.currentSubViewHeight = self.frame.size.height;
    }
}

- (instancetype)initWithActions:(NSArray<ZSSideSlipAction *> *)actions {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor clearColor];
        for (NSInteger i = 0; i < actions.count; i++) {
            ZSSideSlipAction *action = actions[i];
            UIView *btnBgView = [[UIView alloc] init];
            btnBgView.backgroundColor = action.backgroundColor;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.adjustsImageWhenHighlighted = NO;
            [btn setTitle:action.title forState:UIControlStateNormal];
            [btn setTitleColor:action.titleColor forState:UIControlStateNormal];
            if (action.image) [btn setImage:action.image forState:UIControlStateNormal];
            if (action.font) btn.titleLabel.font = action.font;
            
            CGFloat width = [action.title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : btn.titleLabel.font} context:nil].size.width;
            width += (action.image ? action.image.size.width : 0);
            CGFloat finalWidth = width + action.margin*2;
            btnBgView.frame = CGRectMake(i ? [_originWidths[i-1] floatValue]:0, 0, finalWidth, 0);
            btn.frame = CGRectMake(0, 0, finalWidth, 0);
            //需要对初始的宽度进行保存。在形变等操作后恢复
            [self.originWidths addObject:@(finalWidth)];
            //需要对总宽度进行保存
            _totalWidth += finalWidth;
            btn.tag = i;
            [btn addTarget:self action:@selector(actionBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnBgView addSubview:btn];
            [self addSubview:btnBgView];
        }
        self.originSubViews = [self.subviews copy];
        self.frame = CGRectMake(self.frame.size.width, 0, _totalWidth, 0);
        [self subButtons];
    }
    return self;
}

- (void)actionBtnDidClick:(UIButton *)btn {
    if ([self.containerDelegate respondsToSelector:@selector(actionBtnDidClicked:)]) {
        [self.containerDelegate performSelector:@selector(actionBtnDidClicked:) withObject:btn];
    }
}

- (void)restorationToOriginWidth {
    NSUInteger count = self.subviews.count;
    CGFloat currentX = 0;
    for (NSInteger i = 0; i < count; i++) {
        UIView *s = self.subviews[i];
        //NSLog(@"%lf",s.frame.size.width);
        
        CGRect sframe = s.frame;
        sframe.origin.x = currentX;
        sframe.size.width = [_originWidths[i] floatValue];
        s.frame = sframe;
        //下一个X起点=上一个起点+上一个宽度
        currentX += [_originWidths[i] floatValue];
    }
}

- (void)stretchToWidth:(CGFloat)width {
    CGFloat needExpandWidth = width - self.totalWidth;
    NSUInteger count = _originSubViews.count;
    CGFloat currentX = 0;
    for (int i = 0; i < count; i++) {
        UIView *s = _originSubViews[i];
        CGRect sframe = s.frame;
        sframe.origin.x = currentX;
        CGFloat sneedExpandWidth = (needExpandWidth * [_originWidths[i] floatValue]/_totalWidth);
        sframe.size.width = [_originWidths[i] floatValue] + sneedExpandWidth;
        s.frame = sframe;
        //下一个X起点=上一个起点+上一个宽度
        currentX += sframe.size.width;
    }
}

- (NSMutableArray<NSNumber *> *)originWidths {
    if (!_originWidths) {
        _originWidths = [NSMutableArray array];
    }
    return _originWidths;
}

- (NSArray *)subButtons {
    if (!_subButtons) {
        NSMutableArray *array = [NSMutableArray array];
        for (UIView *v in self.subviews) {
            if (v.subviews.firstObject) {
                [array addObject:v.subviews.firstObject];
            }
        }
        _subButtons = [array copy];
    }
    return _subButtons;
}
@end
