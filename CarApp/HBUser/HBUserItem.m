//
//  HBUserItem.m
//  CarApp
//
//  Created by 管理员 on 2017/4/1.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBUserItem.h"



@implementation HBUserItem


+ (void)saveUser:(HBUserItem *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:user.uid forKey:@"uid"];
    [userDefaults setInteger:user.status forKey:@"status"];

    [userDefaults setObject:user.token forKey:@"token"];
    [userDefaults setObject:user.ucreate forKey:@"ucreate"];
    [userDefaults setObject:user.uphone forKey:@"uphone"];
    [userDefaults setObject:user.ulogin forKey:@"ulogin"];
    [userDefaults setObject:user.uname forKey:@"uname"];

    [userDefaults setObject:user.mname forKey:@"mname"];
    [userDefaults setObject:user.gname forKey:@"gname"];
    
    [userDefaults setObject:user.uimage forKey:@"uimage"];
    [userDefaults setObject:user.mname forKey:@"mname"];
    [userDefaults setObject:user.gname forKey:@"gname"];
    [userDefaults setObject:user.uemail forKey:@"uemail"];
    [userDefaults setObject:user.uname forKey:@"uname"];
    [userDefaults setObject:user.uaddress forKey:@"uaddress"];
    
    [userDefaults synchronize];
}

@end
