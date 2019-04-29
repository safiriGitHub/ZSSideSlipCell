//
//  UITableView+ZSSideSlip.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "UITableView+ZSSideSlip.h"
#import <objc/runtime.h>
#import "ZSSideSlipCell.h"

@implementation UITableView (ZSSideSlip)

- (void)setSideSlipCellProxy:(ZSSideSlipCellProxy *)sideSlipCellProxy {
    objc_setAssociatedObject(self, @selector(sideSlipCellProxy), sideSlipCellProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZSSideSlipCellProxy *)sideSlipCellProxy {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIsSlip:(BOOL)isSlip {
    objc_setAssociatedObject(self, @selector(isSlip), [NSNumber numberWithBool:isSlip], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isSlip {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)hideOtherSideSlip:(ZSSideSlipCell *)cell {
    self.isSlip = NO;
    for (ZSSideSlipCell *c in self.visibleCells) {
        if (c == cell) {
            self.isSlip = YES;
        }
        else if ([c isKindOfClass:ZSSideSlipCell.class] && c.isSlip) {
            [c hideCellSideSlip];
        }
    }
}

- (void)hideAllSideSlip {
    self.isSlip = NO;
    for (ZSSideSlipCell *cell in self.visibleCells) {
        if ([cell isKindOfClass:ZSSideSlipCell.class] && cell.isSlip) {
            [cell hideCellSideSlip];
        }
    }
}

@end
