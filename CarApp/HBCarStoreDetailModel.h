//
//  HBCarStoreDetailModel.h
//  CarApp
//
//  Created by 管理员 on 2016/11/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBModel.h"

@interface HBCarStoreDetailModel : HBModel
@property (nonatomic ,copy)NSString<Optional> *gid;
@property (nonatomic ,copy)NSString<Optional> *gshowImage;
@property (nonatomic ,copy)NSString<Optional> *gname;
@property (nonatomic ,copy)NSString<Optional> *maxprice;
@property (nonatomic ,copy)NSString<Optional> *minprice;
@property (nonatomic ,copy)NSString<Optional> *title;
@property (nonatomic ,copy)NSString<Optional> *stages;

@end
