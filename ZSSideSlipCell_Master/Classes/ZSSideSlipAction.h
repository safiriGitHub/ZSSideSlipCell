//
//  ZSSideSlipAction.h
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/26.
//  Copyright © 2019 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZSSideSlipConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class ZSSideSlipAction;
/**
 点击action回调

 @param action 传递action实例
 @param indexPath 所操作cell的indexPath
 */
typedef void(^ActionHandler)(ZSSideSlipAction *action, NSIndexPath *indexPath);

/**
 侧滑按钮配置action，需要在cell代理中返回。
 */
@interface ZSSideSlipAction : NSObject

/**
 初始化Actione类方法

 @param style 样式
 @param title title
 @param handler 回调
 @return instancetype
 */
+ (instancetype)actionWithStyle:(ZSSideslipCellActionStyle)style
                             title:(nullable NSString *)title
                           handler:(ActionHandler)handler;

@property (nonatomic, assign) ZSSideslipCellActionStyle style;

/**
 按钮标题文字
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
 按钮图片，默认nil
 */
@property (nonatomic, strong, nullable) UIImage *image;

/**
 字体设置，默认17
 */
@property (nonatomic, strong, nullable) UIFont *font;

/**
 文字颜色，默认白色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 背景颜色，默认redColor
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 左右内容间距，默认15
 */
@property (nonatomic, assign) CGFloat margin;

/**
 点击action回调
 */
@property (nonatomic, copy) ActionHandler handler;

@property (nonatomic) NSInteger tag;// default is 0
@end

NS_ASSUME_NONNULL_END
