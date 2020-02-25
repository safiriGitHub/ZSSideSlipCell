//
//  ZSSideSlipCell.h
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/26.
//  Copyright © 2019 safiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSSideSlipConfig.h"
#import "ZSSideSlipAction.h"
#import "ZSSideSlipContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSSideSlipCell : UITableViewCell

@property (nonatomic, weak) id <ZSSideSlipCellDelegate> cellDelegate;

/**
 侧滑展示的按钮容器视图
 */
@property (nonatomic, strong, nullable) ZSSideSlipContainerView *buttonContainerView;

/**
 当前cell的侧滑是否被展示中
 */
@property (nonatomic, assign, readonly) BOOL isSlip;

/**
 隐藏所有侧滑按钮
 */
- (void)hideAllSideSlip;

/**
 隐藏当前cell的侧滑按钮
 */
- (void)hideCellSideSlip;

/**
 手动展示当前cell的侧滑按钮，调用该方法就左滑
 */
- (void)manualShowCellSideSlip;

@end

NS_ASSUME_NONNULL_END
