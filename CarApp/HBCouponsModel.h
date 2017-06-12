//
//  HBCouponsModel.h
//  CarApp
//
//  Created by 管理员 on 2017/4/18.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBModel.h"

@interface HBCouponsModel : HBModel

@property(nonatomic, strong) NSString <Optional> *createdate;
@property(nonatomic, strong) NSString <Optional> *pastdate;
@property(nonatomic, strong) NSString <Optional> *price;
@property(nonatomic, strong) NSString <Optional> *rid;
@property(nonatomic, strong) NSString <Optional> *rname;
@property(nonatomic, strong) NSString <Optional> *status;
@property(nonatomic, strong) NSString <Optional> *type;
@property(nonatomic, strong) NSString <Optional> *condition;
@end
