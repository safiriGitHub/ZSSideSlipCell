# ZSCircleChartView

### 项目介绍

iOS仿微信左滑删除和收藏左滑效果

iOS11之后，仿微信左滑删除，可以通过对系统方法进行改造的方式实现。这篇文章 https://www.jianshu.com/p/aa6ff5d9f965

学习自https://www.jianshu.com/p/a08b6db47014，本代码有改动。

![eee](/example.gif)

### 简单介绍

#### ZSSideSlipAction

侧滑按钮配置action，需要在cell代理中返回

#### ZSSideSlipContainerView

侧滑菜单容器View：根据 ZSSideSlipAction 类创建对应的菜单Button。提供类似微信菜单左滑的按钮粘性拉伸及恢复效果。

#### ZSSideSlipCell

`ZSSideSlipCell` 自定义cell继承此类，使用所有功能。

**用法**

```
...

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [ChatCell cellWithTableView:tableView forIndexPath:indexPath];
    cell.cellDelegate = self;
    [cell bindModel:_dataArray[indexPath.row]];
    return cell;
}
...

ZSSideSlipCellDelegate:实现代理方法，来实现左滑菜单配置。--具体用法见Demo--

```

**绑定proxy进行代理拦截转发**

```
...ZSSideSlipCell.m:
- (void)bindProxy {
    UITableView * tableView = [self tableView]; //根据cell的superView获取
    if ([tableView isKindOfClass:[UITableView class]]) {
        if (![tableView.delegate isKindOfClass:[ZSSideSlipCellProxy class]]) {
        	//如果tableView的代理还没有进行拦截
            //保证一个tableView只会设置一次proxy
            ZSSideSlipCellProxy *proxy = [ZSSideSlipCellProxy alloc];
            proxy.target = tableView; //这里。proxy的target是weak属性，并不会造成循环引用
        }
    }
}
...

```


#### ZSSideSlipCellProxy

继承自 NSProxy ，实现代理拦截转发。

**滚动时收起侧滑菜单**

```
通过NSProxy对tableView的滑动代理进行拦截

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.target.isSlip) {
        [self.target hideAllSideSlip];
    }
    
    if ([self.tbDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.tbDelegate scrollViewWillBeginDragging:scrollView];
    }
    
}

```

**点击时收起侧滑菜单**

```
过NSProxy对tableView的didSelectRowAtIndexPath代理进行拦截

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.target.isSlip) {
        [self.target hideAllSideSlip];
    }
    
    if ([self.tbDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tbDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
```

**拦截器实现**

```
- (void)setTarget:(UITableView *)target {
    _target = target;
    target.sideSlipCellProxy = self;//这里需要让tableView强引用proxy防止释放
    self.tbDelegate = target.delegate;//保存tableView原本的delegate，进行转发
    self.tbDataSource = target.dataSource;//保存tableView原本的dataSource，进行转发
    target.delegate = self;//修改tableView.delegate拦截代理事件
}

```

#### UITableView+ZSSideSlip.h

通过runtime实现 isSlip、拦截器sideSlipCellProxy 的持有属性
```
@property (nonatomic, assign) BOOL isSlip;
@property (nonatomic) ZSSideSlipCellProxy *sideSlipCellProxy;

```

#### 效果

**微信确认删除按钮的实现**

在侧滑按钮点击代理事件中，返回要显示的View，将其放到侧滑容器上，并进行布局的适配。

```
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

```

