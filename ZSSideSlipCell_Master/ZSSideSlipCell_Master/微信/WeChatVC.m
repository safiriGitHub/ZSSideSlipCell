//
//  WeChatVC.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "WeChatVC.h"
#import "ZSSideSlipCell.h"
#import "ChatModel.h"
#import "ChatCell.h"

@interface WeChatVC ()<ZSSideSlipCellDelegate, UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSIndexPath *indexPath;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WeChatVC {
    UIImageView *_logoImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    UIColor *c = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.backgroundColor = c;
    self.tableView.separatorColor = c;
    self.tableView.rowHeight = 70;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ChatCell registerCellWithTableView:self.tableView];
    _dataArray = [ChatModel requestDataArray];
    
    _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
    _logoImageView.contentMode = UIViewContentModeCenter;
    _logoImageView.alpha = 0.7;
    [self.tableView addSubview:_logoImageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"点击滑动" style:UIBarButtonItemStyleDone target:self action:@selector(clickSideSlip)];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _logoImageView.frame = CGRectMake(0, -100, self.tableView.frame.size.width, 100);
}

- (void)clickSideSlip {
    ChatCell *cell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.isSlip) {
        [cell hideCellSideSlip];
    }else {
        [cell manualShowCellSideSlip];
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [ChatCell cellWithTableView:tableView forIndexPath:indexPath];
    cell.cellDelegate = self;
    [cell bindModel:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.preservesSuperviewLayoutMargins = NO;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 65, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 65, 0, 0)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];;
        _tableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:235/255.0 blue:243/255.0 alpha:1];
        _tableView.rowHeight = 70;
        _tableView.separatorColor = [UIColor lightGrayColor];
    }
    return _tableView;
}

#pragma mrak -ZSSideSlipCellDelegate

- (NSArray<ZSSideSlipAction *> *)sideSlipCell:(ZSSideSlipCell *)cell editActionsAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *model = _dataArray[indexPath.row];
    ZSSideSlipAction *action1 = [ZSSideSlipAction actionWithStyle:ZSSideslipCellActionStyleNormal title:@"不再关注" handler:^(ZSSideSlipAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"不再关注");
        [cell hideAllSideSlip];
    }];
    
    ZSSideSlipAction *action2 = [ZSSideSlipAction actionWithStyle:ZSSideslipCellActionStyleDestructive title:@"删除" handler:^(ZSSideSlipAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击删除");
    }];
    action2.tag = 1001;
    
    ZSSideSlipAction *action3 = [ZSSideSlipAction actionWithStyle:ZSSideslipCellActionStyleNormal title:@"置顶" handler:^(ZSSideSlipAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"置顶");
        [cell hideAllSideSlip];
    }];
    ZSSideSlipAction *action4 = [ZSSideSlipAction actionWithStyle:ZSSideslipCellActionStyleNormal title:@"标为未读" handler:^(ZSSideSlipAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"标为未读");
        [cell hideAllSideSlip];
    }];
    
    NSArray *array = @[];
    switch (model.messageType) {
        case ChatCellTypeMessage:
            array = @[action4,action2];
            break;
        case ChatCellTypeSubscription:
            array = @[action1,action2];
            break;
        case ChatCellTypePubliction:
            array = @[action3, action2];
            break;
        default:
            break;
    }
    return array;
}
- (BOOL)sideSlipCell:(ZSSideSlipCell *)cell canSlipAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UIView *)sideSlipCell:(ZSSideSlipCell *)cell didSelectedAtIndexPath:(nonnull NSIndexPath *)indexPath didClickedAction:(nonnull ZSSideSlipAction *)action actionIndex:(NSInteger)index {
    if (action.tag == 1001) {
        self.indexPath = indexPath;
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 135, 0)];
        view.titleLabel.textAlignment = NSTextAlignmentCenter;
        view.titleLabel.font = [UIFont systemFontOfSize:17];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setTitle:@"确认删除" forState:UIControlStateNormal];
        view.backgroundColor = [UIColor redColor];
        [view addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    return nil;
}

- (void)delBtnClick {
    [_dataArray removeObjectAtIndex:self.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
@end
