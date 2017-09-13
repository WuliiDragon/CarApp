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
@property(nonatomic, strong) HBStoreCarModel *StoreCarModel;
@property(nonatomic, strong) HBSeriesOfcarModel *SeriesOfcarModel;
@property(strong, nonatomic) HBCarStoreDetailModel *CarStoreDetailModel;

@property(strong, nonatomic) NSString *bid;


@end
