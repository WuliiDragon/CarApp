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
@property(nonatomic, strong) HBCarStoreDetailModel *CarStoreDetailModel;
@property(nonatomic, strong) HBStoreCarModel *StoreCarModel;
@property(nonatomic, strong) HBSeriesOfcarModel *SeriesOfcarModel;
@property(nonatomic, strong) NSString  *bid;

@property(nonatomic) BOOL *isRecommend;
@end
