//
//  ZSSideSlipCell.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/26.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ZSSideSlipCell.h"
#import "UITableView+ZSSideSlip.h"
#import "ZSSideSlipCellProxy.h"
#import "ZSSideSlipAction.h"

CGFloat ZS_getX(UIView *v) {
    return v.frame.origin.x;
};

CGFloat ZS_getW(UIView *v) {
    return v.frame.size.width;
};

void ZS_setX(UIView *v, CGFloat x) {
    CGRect frame = v.frame;
    frame.origin.x = x;
    v.frame = frame;
};

void ZS_setW(UIView *v, CGFloat w) {
    CGRect frame = v.frame;
    frame.size.width = w;
    v.frame = frame;
};

typedef NS_ENUM(NSInteger, ZSSideSlipCellState) {
    ZSSlipCellStateNormal,
    ZSSlipCellStateAnimating,
    ZSSlipCellStateOpen
};

@interface ZSSideSlipCell () <UIGestureRecognizerDelegate, SlipContainerDelegate>

@property (nonatomic, assign, readwrite) BOOL isSlip; //当前cell的侧滑是否被展示中

@property (nonatomic, assign) ZSSideSlipCellState state; //当前cell的状态

@property (nonatomic, strong) UIView *nextShowView; //点击侧滑按钮后，若有需要持有用户返回的新View

@property (nonatomic, strong) NSArray <ZSSideSlipAction *>*actions;

@end

@implementation ZSSideSlipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSideSlipCell];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configSideSlipCell];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configSideSlipCell {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureOfContentView:)];
    pan.delegate = self;
    [self.contentView addGestureRecognizer:pan];
    
    [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews {
    CGFloat x = 0;
    if (self.isSlip) x = self.contentView.frame.origin.x;
    
    [super layoutSubviews];
    ZS_setW(self.contentView, ZS_getW(self));
    //侧滑状态旋转屏幕时，保持侧滑
    if (self.isSlip) ZS_setX(self.contentView, x);
}

- (void)prepareForReuse {
    //cell被重用调用
    [super prepareForReuse];
    if (self.isSlip) [self hideSlipNoAnimation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context  {
    if ([keyPath isEqualToString:@"frame"]) {
        if (self.buttonContainerView) {
            ZS_setX(self.buttonContainerView, self.contentView.frame.size.width + self.contentView.frame.origin.x);
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate 手势处理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view.superview isKindOfClass:ZSSideSlipCell.class]) {
        ZSSideSlipCell *cell = (ZSSideSlipCell *)gestureRecognizer.view.superview;
        if (cell.isSlip) return YES;// 还是已经侧滑的cell,不做处理
        
        [self hideAllSideSlip];//隐藏已经侧滑的其他cell
    }
    
    
    UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint translation = [gesture translationInView:gesture.view];
    //如果手势相对于水平方向的角度大于45°, 则不触发侧滑
    if (fabs(translation.y) >= fabs(translation.x)) {
        return NO;
    }
    
    //询问代理是否允许侧滑
    if ([self.cellDelegate respondsToSelector:@selector(sideSlipCell:canSlipAtIndexPath:)]) {
        if (![self.cellDelegate sideSlipCell:self canSlipAtIndexPath:self.indexPathOfTableView]) {
            return NO;
        }
    }
    
    //向代理获取侧滑展示内容数组
    if ([self.cellDelegate respondsToSelector:@selector(sideSlipCell:editActionsAtIndexPath:)]) {
        NSArray *actions = [self.cellDelegate sideSlipCell:self editActionsAtIndexPath:[self indexPathOfTableView]];
        if (actions.count == 0) return NO;
        self.actions = actions;
    }else { return NO; }
    
    return YES;
}

- (void)panGestureOfContentView:(UIPanGestureRecognizer *)pan {
    
    CGPoint point = [pan translationInView:pan.view];
    UIGestureRecognizerState state = pan.state;
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (self.nextShowView) {
        [self.nextShowView removeFromSuperview];
        self.nextShowView = nil;
        //防止在0.2s动画执行完之前又开始滑动
        [self.buttonContainerView.subButtons setValue:@NO forKey:@"hidden"];
    }
    
    if (state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.contentView.frame;
        CGRect cframe = self.buttonContainerView.frame;
        CGFloat containerWidth = fabs(self.buttonContainerView.totalWidth);
        if (frame.origin.x + point.x <= -containerWidth) {
            //超过最大距离，加滑动阻尼效果
            CGFloat hindrance = point.x/5;//注意是负数
            if (frame.origin.x + hindrance <= -containerWidth) {
                frame.origin.x += hindrance;
                cframe.origin.x += hindrance;
                cframe.size.width -= hindrance;
            }else {
                //这里修复了一个当滑动过快时，导致最初减速时闪动的bug
                frame.origin.x = - containerWidth;
                cframe.origin.x = self.contentView.frame.size.width - containerWidth;
            }
        }else {
            //未到最大距离，正常拖拽
            frame.origin.x += point.x;
            cframe.origin.x += point.x;
        }
        
        //不允许右滑
        if (frame.origin.x > 0) {
            frame.origin.x = 0;
        }
        self.contentView.frame = frame;
        //self.btnContainView.frame = cframe;
        [self.buttonContainerView stretchToWidth:fabs(frame.origin.x)];
    }
    else if (state == UIGestureRecognizerStateEnded) {
        CGPoint v = [pan velocityInView:pan.view];//手势速度 向左负数
        CGFloat cx = self.contentView.frame.origin.x;
        if (cx == 0) {
            self.state = ZSSlipCellStateNormal;
            return;
        }
        else if (cx > 5) {
            [self hideWithBounceAnimation];
        }
        else if (fabs(cx) >= 40 && v.x <= 0) {
            [self showCellSideSlip];
        }else {
            [self hideCellSideSlip];
        }
    }
    else if (state == UIGestureRecognizerStateCancelled) {
        [self hideAllSideSlip];
    }
}

//MARK: SlipContainerDelegate
- (void)actionBtnDidClicked:(UIButton *)btn {
    if (self.nextShowView) {
        [self.nextShowView removeFromSuperview];
        self.nextShowView = nil;
    }
    if ([self.cellDelegate respondsToSelector:@selector(sideSlipCell:didSelectedAtIndexPath:didClickedAction:actionIndex:)]) {
        self.nextShowView = [self.cellDelegate sideSlipCell:self didSelectedAtIndexPath:self.indexPathOfTableView didClickedAction:self.actions[btn.tag] actionIndex:btn.tag];
        
         //将需要继续展示的View，一般是确认删除，覆盖到侧滑容器上，并且重新以新的View作为基础进行布局
        if (self.nextShowView) {
            [self.buttonContainerView addSubview:self.nextShowView];
            CGRect frame = CGRectMake(0, 0, self.nextShowView.frame.size.width, self.contentView.frame.size.height);
            
            self.nextShowView.frame = CGRectMake(self.buttonContainerView.originSubViews.lastObject.frame.origin.x, 0, self.nextShowView.frame.size.width, self.contentView.frame.size.height);
            self.nextShowView.hidden = YES;
            
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.nextShowView.frame = frame;
                self.buttonContainerView.frame = frame;
                self.nextShowView.hidden = NO;
                [self.buttonContainerView.subButtons setValue:@(YES) forKeyPath:@"hidden"];
                ZS_setX(self.contentView, -ZS_getW(self.nextShowView));
                [self.buttonContainerView stretchToWidth:self.nextShowView.frame.size.width];
            } completion:^(BOOL finished) {
                [self.buttonContainerView.subButtons setValue:@(NO) forKeyPath:@"hidden"];
            }];
        }
    }
    
    if (btn.tag < self.actions.count) {
        ZSSideSlipAction *action = self.actions[btn.tag];
        if (action.handler) action.handler(action, self.indexPathOfTableView);
    }
    [self hideOtherSideSlip];
}

#pragma mark - 滑动相关操作方法

- (void)hideOtherSideSlip {
    [self.tableView hideOtherSideSlip:self];
}
- (void)hideAllSideSlip {
    [self.tableView hideAllSideSlip];
}
- (void)hideSlipNoAnimation {
    if (self.contentView.frame.origin.x == 0) return;
    self.isSlip = NO;
    self.state = ZSSlipCellStateAnimating;
    ZS_setX(self.contentView, 0);
    [self.buttonContainerView removeFromSuperview];
    self.buttonContainerView = nil;
    self.state = ZSSlipCellStateNormal;
}
- (void)hideCellSideSlip {
    if (self.contentView.frame.origin.x == 0) return;
    self.isSlip = NO;
    self.state = ZSSlipCellStateAnimating;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        ZS_setX(self.contentView, 0);
    } completion:^(BOOL finished) {
        [self.buttonContainerView removeFromSuperview];
        self.buttonContainerView = nil;
        self.state = ZSSlipCellStateNormal;
    }];
}
- (void)hideWithBounceAnimation {
    self.state = ZSSlipCellStateAnimating;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        ZS_setX(self.contentView, -10);
    } completion:^(BOOL finished) {
        [self hideCellSideSlip];
    }];
}
- (void)showCellSideSlip {
    //尝试添加拦截器
    [self bindProxy];
    //修改cell以及tableView为侧滑按钮展示状态
    self.isSlip = YES;
    self.tableView.isSlip = YES;
    self.state = ZSSlipCellStateAnimating;
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        ZS_setX(self.contentView, -self.buttonContainerView.totalWidth);
        [self.buttonContainerView restorationToOriginWidth];
    } completion:^(BOOL finished) {
        self.state = ZSSlipCellStateOpen;
    }];
}


//尝试绑定proxy进行代理拦截转发
- (void)bindProxy {
    UITableView * tableView = [self tableView];
    if ([tableView isKindOfClass:[UITableView class]]) {
        if (![tableView.delegate isKindOfClass:[ZSSideSlipCellProxy class]]) {
            //保证一个tableView只会设置一次proxy
            ZSSideSlipCellProxy *proxy = [ZSSideSlipCellProxy alloc];
            proxy.target = tableView; //这里。proxy的target是weak属性，并不会造成循环引用
        }
    }
}
#pragma mark - getters setters

- (void)setState:(ZSSideSlipCellState)state {
    _state = state;
    if (state == ZSSlipCellStateNormal) {
        //这里可以防止循环引用VC，前提cell已经恢复默认状态。
        self.actions = nil;
    }
}
- (void)setActions:(NSArray<ZSSideSlipAction *> *)actions {
    _actions = actions;
    
    if (self.buttonContainerView) {
        [self.buttonContainerView removeFromSuperview];
        self.buttonContainerView = nil;
    }
    
    self.buttonContainerView = [[ZSSideSlipContainerView alloc] initWithActions:actions];
    self.buttonContainerView.frame = CGRectMake(self.contentView.frame.size.width, 0, _buttonContainerView.frame.size.width, self.contentView.frame.size.height);
    self.buttonContainerView.containerDelegate = self;
    [self insertSubview:self.buttonContainerView belowSubview:self.contentView];
}

- (UITableView *)tableView {
    id view = self.superview;
    while (view && ![view isKindOfClass:[UITableView class]]) {
        view = [view superview];
    }
    if ([view isKindOfClass:[UITableView class]]) {
        return view;
    }else {
        return nil;
    }
}

- (NSIndexPath *)indexPathOfTableView {
    return [self.tableView indexPathForCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
