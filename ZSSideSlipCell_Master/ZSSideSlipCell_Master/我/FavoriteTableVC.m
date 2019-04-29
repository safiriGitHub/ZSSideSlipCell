//
//  FavoriteTableVC.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "FavoriteTableVC.h"
#import "FavoriteModel.h"
#import "FavoriteLinkCell.h"

@interface FavoriteTableVC ()<ZSSideSlipCellDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FavoriteTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];;
    [FavoriteLinkCell registerCellWithTableView:self.tableView];
    _dataArray = [FavoriteModel dataForFavoriteList];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FavoriteLinkCell *cell = [FavoriteLinkCell cellWithTableView:tableView forIndexPath:indexPath];
    cell.cellDelegate = self;
    [cell bindModel:_dataArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSArray<ZSSideSlipAction *> *)sideSlipCell:(ZSSideSlipCell *)cell editActionsAtIndexPath:(NSIndexPath *)indexPath {
    ZSSideSlipAction *tagAction = [ZSSideSlipAction actionWithStyle:ZSSideslipCellActionStyleNormal title:nil handler:^(ZSSideSlipAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击打标签按钮");
        [cell hideAllSideSlip];
    }];
    tagAction.backgroundColor = [UIColor clearColor];
    tagAction.image = [UIImage imageNamed:@"Fav_Edit_Tag"];
    tagAction.margin = 10;
    
    ZSSideSlipAction *deleteAction = [ZSSideSlipAction actionWithStyle:ZSSideslipCellActionStyleNormal title:nil handler:^(ZSSideSlipAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击的删除按钮");
        [cell hideAllSideSlip];
    }];
    deleteAction.backgroundColor = [UIColor clearColor];
    deleteAction.image = [UIImage imageNamed:@"Fav_Edit_Delete"];
    deleteAction.margin = 10;
    
    return @[tagAction, deleteAction];
}

@end
