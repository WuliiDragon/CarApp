//
//  HBPayresult.h
//  CarApp
//
//  Created by 管理员 on 2017/4/22.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPayresult : UIViewController

- (instancetype)initWithResInfo:(id)data qid:(NSString *)qid resultCode:(NSString *)resultCode;

@end
