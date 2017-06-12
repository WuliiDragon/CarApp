//
//  HBUserItem.m
//  CarApp
//
//  Created by 管理员 on 2017/4/1.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBUserItem.h"

NSString *const Huid = @"uid";
NSString *const Huname = @"uname";
NSString *const Hstatus = @"status";
NSString *const Htoken = @"token";
NSString *const Hucreate = @"ucreate";
NSString *const Hphone = @"phone";
NSString *const Hulogin = @"ulogin";


NSString *const kUserID = @"userID";

@implementation HBUserItem


+ (void)saveUser:(HBUserItem *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setInteger:user.uid forKey:Huid];
    [userDefaults setInteger:user.status forKey:Hstatus];

    [userDefaults setObject:user.token forKey:Htoken];
    [userDefaults setObject:user.ucreate forKey:Hucreate];
    [userDefaults setObject:user.phone forKey:Hphone];
    [userDefaults setObject:user.ulogin forKey:Hulogin];
    [userDefaults setObject:user.uname forKey:Huname];

    [userDefaults synchronize];
}

@end
