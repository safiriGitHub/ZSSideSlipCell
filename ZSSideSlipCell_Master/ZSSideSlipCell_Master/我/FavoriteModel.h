//
//  FavoriteModel.h
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FavoriteType) {
    FavoriteTypeLink,
    FavoriteTypePicture,
    FavoriteTypeFile,
};
NS_ASSUME_NONNULL_BEGIN

@interface FavoriteModel : NSObject

@property (nonatomic, assign) FavoriteType type;

//FavoriteTypeLink
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *time;

+ (NSArray *)dataForFavoriteList;
@end

NS_ASSUME_NONNULL_END
