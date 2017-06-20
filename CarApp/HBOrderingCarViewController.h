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

@interface HBOrderingCarViewController : UIViewController
@property(nonatomic, strong) HBSeriesOfcarModel *seriesOfCarModel;
@property(strong, nonatomic) HBCarStoreDetailModel *carStoreDetailModel;
@end
