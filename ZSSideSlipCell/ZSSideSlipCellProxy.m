//
//  ZSSideSlipCellProxy.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ZSSideSlipCellProxy.h"
#import "ZSSideSlipCell.h"
#import "UITableView+ZSSideSlip.h"

@interface ZSSideSlipCell ()
@property (nonatomic, assign) BOOL isSlip;
@end

@interface ZSSideSlipCellProxy ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, weak) id <UIScrollViewDelegate, UITableViewDelegate>tbDelegate;
@property (nonatomic, weak) id <UITableViewDataSource>tbDataSource;
@end

@implementation ZSSideSlipCellProxy

// MARK: 代理拦截转发

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.tbDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.tbDataSource numberOfSectionsInTableView:tableView];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tbDataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.tbDataSource tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.tbDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tbDelegate respondsToSelector:@selector(cellForRowAtIndexPath:)]) {
        return [self.tbDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        return [self.tbDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.tbDelegate tableView:tableView heightForHeaderInSection:section];
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.tbDelegate tableView:tableView viewForFooterInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.tbDelegate tableView:tableView heightForFooterInSection:section];
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.tbDelegate tableView:tableView viewForHeaderInSection:section];
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.target.isSlip) {
        [self.target hideAllSideSlip];
    }
    
    if ([self.tbDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tbDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.target.isSlip) {
        [self.target hideAllSideSlip];
    }
    
    if ([self.tbDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.tbDelegate scrollViewWillBeginDragging:scrollView];
    }
    
}
- (void)setTarget:(UITableView *)target {
    _target = target;
    target.sideSlipCellProxy = self;//这里需要让tableView强引用proxy防止释放
    self.tbDelegate = target.delegate;//保存tableView原本的delegate，进行转发
    self.tbDataSource = target.dataSource;//保存tableView原本的dataSource，进行转发
    target.delegate = self;//修改tableView.delegate拦截代理事件
}
//重写实现
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector] || [self.tbDataSource respondsToSelector:aSelector];
}
- (BOOL)isKindOfClass:(Class)aClass {//提供isKindOfClass实现
    return [NSStringFromClass(aClass) isEqualToString:@"ZSSideSlipCellProxy"];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return nil;
}

@end
