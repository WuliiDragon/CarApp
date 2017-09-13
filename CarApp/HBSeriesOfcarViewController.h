//
//  HBSeriesOfcarViewController.h
//  CarApp
//
//  Created by 管理员 on 2016/12/6.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCarStoreDetailModel.h"
#import "HBStoreCarModel.h"

@interface HBSeriesOfcarViewController : UIViewController
@property(nonatomic, strong) HBCarStoreDetailModel *CarStoreDetailModel;
@property(nonatomic, strong) HBStoreCarModel *StoreCarModel;
@property(nonatomic, strong) NSString *bid;
@end
