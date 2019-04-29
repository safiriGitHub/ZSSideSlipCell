//
//  ZSSideSlipCellProxy.h
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSSideSlipCellProxy : NSProxy

@property (nonatomic, weak) UITableView *target;

@end

NS_ASSUME_NONNULL_END
