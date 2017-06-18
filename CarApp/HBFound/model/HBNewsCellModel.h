//
//  HBNewsCellModel.h
//  CarApp
//
//  Created by 管理员 on 2017/6/17.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBModel.h"

@interface HBNewsCellModel : HBModel
@property(nonatomic, strong) NSString <Optional> *cid;
@property(nonatomic, strong) NSString <Optional> *date;
@property(nonatomic, strong) NSString <Optional> *descriptions;
@property(nonatomic, strong) NSString <Optional> *image;
@property(nonatomic, strong) NSString <Optional> *linkNum;
@property(nonatomic, strong) NSString <Optional> *nid;
@property(nonatomic, strong) NSString <Optional> *ntitle;
@end
