//
//  HBCouponsViewController.h
//  CarApp
//
//  Created by 管理员 on 2017/4/17.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCouponsModel.h"
#import "HBCleanCellModel.h"

@interface HBCouponsViewController : UIViewController
-(instancetype)initWithCouponsArr:(HBCleanCellModel  *)model;

typedef void (^ablock)( HBCouponsModel *model);
@property (nonatomic, copy) ablock block;
@end
