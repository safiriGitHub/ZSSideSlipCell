//
//  ZSSideSlipContainerView.h
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/26.
//  Copyright © 2019 safiri. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol SlipContainerDelegate <NSObject>
@optional
/**
 侧滑按钮点击代理回调方法
 
 @param btn 按钮
 */
- (void)actionBtnDidClicked:(UIButton *)btn;

@end

@class ZSSideSlipAction;
@interface ZSSideSlipContainerView : UIView

/**
 初始化

 @param actions actions数组
 @return 实例
 */
- (instancetype)initWithActions:(NSArray<ZSSideSlipAction *> *)actions;

@property (nonatomic, weak) id <SlipContainerDelegate>containerDelegate;//这个属性会在cell中被调用

/**
 总宽度
 不要修改这个东西，会引发布局错误
 */
@property (nonatomic, assign, readonly) CGFloat totalWidth;

/**
 内部button数组
 作用,目前这里你可以比较方便的拿到每个视图的信息。但如果要修改他们的frame，没有做进一步变化的适配
 */
@property (nonatomic, strong, readonly) NSArray *subButtons;
@property (nonatomic, strong, readonly) NSArray <UIView *>*originSubViews;

/**
 拉伸自己形变到指定宽度

 @param width 指定宽度
 */
- (void)stretchToWidth:(CGFloat)width;

/**
 复原到拉伸前原有宽度
 */
- (void)restorationToOriginWidth;

@end

NS_ASSUME_NONNULL_END
