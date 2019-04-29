//
//  MineVC.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "MineVC.h"
#import "FavoriteTableVC.h"

@interface MineVC ()

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"收藏" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(favorite) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake((self.view.frame.size.width-100)/2, (self.view.frame.size.height-45)/2, 100, 45)];
    [self.view addSubview:btn];
}

- (void)favorite {
    FavoriteTableVC *vc = [[FavoriteTableVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
