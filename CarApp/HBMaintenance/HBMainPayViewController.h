//
//  HBMainPayViewController.h
//  CarApp
//
//  Created by 管理员 on 2017/4/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCleanCellModel.h"
#import "HBMiantenanceCarHomeModel.h"

@interface HBMainPayViewController : UIViewController

- (instancetype)initWithOrderArr:(NSArray *)orderList totalPrice:(float)totalPrice payName:(NSString *)payName maintanaceInfo:(HBMiantenanceCarHomeModel *)maintanaceModel;


@end
