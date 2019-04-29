//
//  UITableView+ZSSideSlip.h
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZSSideSlipCellProxy, ZSSideSlipCell;
@interface UITableView (ZSSideSlip)

@property (nonatomic, assign) BOOL isSlip;
@property (nonatomic) ZSSideSlipCellProxy *sideSlipCellProxy;

/**
  隐藏所有cell的侧滑按钮
 */
- (void)hideAllSideSlip;

/**
 隐藏出指定cell外所有cell的侧滑按钮

 @param cell 不隐藏侧滑按钮的指定cell
 */
- (void)hideOtherSideSlip:(ZSSideSlipCell *)cell;

@end

NS_ASSUME_NONNULL_END
