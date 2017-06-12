//
//  HBCarDetailViewController.h
//  CarApp
//
//  Created by 管理员 on 2016/12/9.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBRootViewController.h"
#import "HBCarStoreDetailModel.h"
#import "HBStoreCarModel.h"
#import "HBSeriesOfcarModel.h"
#import "HBRecommendModel.h"

@interface HBCarDetailViewController : UIViewController
@property(strong, nonatomic) HBCarStoreDetailModel *carStoreDetailModel;
@property(nonatomic, strong) HBStoreCarModel *carstoreModel;
@property(strong, nonatomic) HBSeriesOfcarModel *seriesOfCarModel;

@property(nonatomic) BOOL *isRecommend;
@property(nonatomic) NSString *mid;
@end
