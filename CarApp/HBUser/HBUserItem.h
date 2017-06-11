//
//  HBUserItem.h
//  CarApp
//
//  Created by 管理员 on 2017/4/1.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBModel.h"
@interface HBUserItem  : HBModel
@property (nonatomic, assign) long uid;
@property (nonatomic, assign) long status;

@property (nonatomic, copy)   NSString <Optional>  *ucreate;
@property (nonatomic, strong) NSString <Optional>  *phone;
@property (nonatomic, strong) NSString <Optional>  *ulogin;
@property (nonatomic, strong) NSString <Optional>  *token;
@property (nonatomic, strong) NSString <Optional>  *uname;


+ (void)saveUser:(HBUserItem *)user;
@end
