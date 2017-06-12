//
//  HBBadgeView.h
//  CarApp
//
//  Created by 管理员 on 2017/6/8.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBBadgeView : UIView
- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string;

- (instancetype)initWithFrame:(CGRect)frame withString:(NSString *)string withTextColor:(UIColor *)textColor;

@property(nonatomic, strong) NSString *badgeValue;

@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UILabel *textLabel;

@end
