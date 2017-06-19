//
//  HBUserItem.h
//  CarApp
//
//  Created by 管理员 on 2017/4/1.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBModel.h"

@interface HBUserItem : HBModel
@property(nonatomic, assign) long uid;
@property(nonatomic, assign) long status;

@property(nonatomic, strong) NSString <Optional> *ucreate;
@property(nonatomic, strong) NSString <Optional> *uphone;
@property(nonatomic, strong) NSString <Optional> *ulogin;
@property(nonatomic, strong) NSString <Optional> *token;

@property(nonatomic, strong) NSString <Optional> *uimage;
@property(nonatomic, strong) NSString <Optional> *mname;
@property(nonatomic, strong) NSString <Optional> *gname;
@property(nonatomic, strong) NSString <Optional> *uemail;

@property(nonatomic, strong) NSString <Optional> *uname;
@property(nonatomic, strong) NSString <Optional> *uaddress;


+ (void)saveUser:(HBUserItem *)user;
@end
