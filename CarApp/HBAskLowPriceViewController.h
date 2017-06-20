//
//  AskLowPriceViewController.h
//  CarApp
//
//  Created by 管理员 on 2016/11/27.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBRootViewController.h"
#import "HBCarStoreDetailModel.h"
#import "HBStoreCarModel.h"
#import "HBSeriesOfcarModel.h"

@interface HBAskLowPriceViewController : UIViewController
@property(nonatomic, strong) HBStoreCarModel *storeCarModel;
@property(nonatomic, strong) HBSeriesOfcarModel *seriesOfCarModel;
@property(strong, nonatomic) HBCarStoreDetailModel *carStoreDetailModel;

@property(strong, nonatomic) NSString *bid;
@property(strong, nonatomic) NSString *mid;
@property(strong, nonatomic) NSString *carinfo;
@property(strong, nonatomic) NSString *distanceStr;
@end
