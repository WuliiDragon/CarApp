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
- (instancetype)initTypes:(NSString *)types modelArr:(NSMutableArray*)modelArr totalPrice:(float)totalPrice;

typedef void (^ablock)(HBCouponsModel *model ,NSMutableArray *modelArr);
@property(nonatomic, copy) ablock block;
@end
