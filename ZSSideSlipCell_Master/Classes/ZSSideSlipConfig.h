//
//  ZSSideSlipConfig.h
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/26.
//  Copyright © 2019 safiri. All rights reserved.
//

#ifndef ZSSideSlipConfig_h
#define ZSSideSlipConfig_h

/**
 侧滑样式

 - ZSSideslipCellActionStyleDefault: 默认 删除 红底
 - ZSSideslipCellActionStyleDestructive: 默认 删除 红底
 - ZSSideslipCellActionStyleNormal:正常 灰底
 */
typedef NS_ENUM(NSInteger, ZSSideslipCellActionStyle) {
    ZSSideslipCellActionStyleDefault = 0,
    ZSSideslipCellActionStyleDestructive = ZSSideslipCellActionStyleDefault,
    ZSSideslipCellActionStyleNormal
};

NS_ASSUME_NONNULL_BEGIN

@class ZSSideSlipCell, ZSSideSlipAction;
@protocol ZSSideSlipCellDelegate <NSObject>

@optional;

/**
 是否允许侧滑

 @param cell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @return YES-表示当前cell可以侧滑, NO-不可以
 */
- (BOOL)sideSlipCell:(ZSSideSlipCell *)cell canSlipAtIndexPath:(NSIndexPath *)indexPath;

/**
 侧滑内容action配置

 @param cell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @return action数组，若为空，则没有侧滑事件
 */
- (nullable NSArray<ZSSideSlipAction *> *)sideSlipCell:(ZSSideSlipCell *)cell editActionsAtIndexPath:(NSIndexPath *)indexPath;

/**
 选中了侧滑按钮

 @param cell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @param index 点击的action序号
 @return 如果你想展示另一个View，那么返回他。如果返回nil，则会直接收起侧滑菜单
         需要注意如果你返回了一个View，那么整个侧滑容器将会对其进行适配(宽度)
 */
- (UIView *)sideSlipCell:(ZSSideSlipCell *)cell didSelectedAtIndexPath:(NSIndexPath *)indexPath didClickedAction:(ZSSideSlipAction *)action actionIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
#endif /* ZSSideSlipConfig_h */
