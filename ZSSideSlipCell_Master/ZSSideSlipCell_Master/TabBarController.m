//
//  TabBarController.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "TabBarController.h"
#import "WeChatVC.h"
#import "ContactsVC.h"
#import "DiscoverVC.h"
#import "MineVC.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTabbarViewControllers];
}
#pragma mark - add ViewControllers
- (void)addTabbarViewControllers {
    WeChatVC *chatVC = [[WeChatVC alloc] init];
    ContactsVC *contactsVC = [[ContactsVC alloc] init];
    DiscoverVC *discoverVC = [[DiscoverVC alloc] init];
    MineVC *mineVC = [[MineVC alloc] init];
    
    [self addViewController:chatVC title:@"微信" imageName:@"tabbar_chat" selectedImageName:@"tabbar_chatHL"];
    [self addViewController:contactsVC title:@"通讯录" imageName:@"tabbar_contacts" selectedImageName:@"tabbar_contactsHL"];
    [self addViewController:discoverVC title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
    [self addViewController:mineVC title:@"我的" imageName:@"tabbar_chat" selectedImageName:@"tabbar_chatHL"];
}
- (void)addViewController:(UIViewController *)viewController title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    viewController.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
//    if ([[UIDevice currentDevice] isPad]) {
//        viewController.tabBarItem.titlePositionAdjustment = UIOffsetZero;
//    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navigationController];
}

@end
