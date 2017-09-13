//
//  HBOrderingCarViewController.h
//  CarApp
//
//  Created by 管理员 on 2016/12/7.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBRootViewController.h"
#import "HBSeriesOfcarModel.h"
#import "HBCarStoreDetailModel.h"
#import "HBStoreCarModel.h"
@interface HBOrderingCarViewController : UIViewController
@property(nonatomic, strong) HBCarStoreDetailModel *CarStoreDetailModel;
@property(nonatomic, strong) HBStoreCarModel *StoreCarModel;
@property(nonatomic, strong) HBSeriesOfcarModel *SeriesOfcarModel;
@end
