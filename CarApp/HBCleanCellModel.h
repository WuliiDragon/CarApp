//
//  HBCleanCellModel.h
//  CarApp
//
//  Created by 管理员 on 2017/3/20.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBModel.h"

@interface HBCleanCellModel : HBModel
@property (nonatomic ,strong) NSString <Optional> *mbid;
@property (nonatomic ,strong) NSString <Optional> *newprice;
@property (nonatomic ,strong) NSString <Optional> *oldprice;
@property (nonatomic ,strong) NSString <Optional> *sdesc;
@property (nonatomic ,strong) NSString <Optional> *sid;
@property (nonatomic ,strong) NSString <Optional> *sname;
@property (nonatomic ,strong) NSString <Optional> *type;




@property (nonatomic ,strong) NSString <Optional> *count;
@property (nonatomic ,strong) NSString <Optional> *reduceStatus;
@property (nonatomic ,strong) NSString <Optional> *countLabStatus;


-(void)initVar;
@end
