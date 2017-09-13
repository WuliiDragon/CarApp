//
//  UIView+Extension.h
//  CarApp
//
//  Created by 管理员 on 2016/11/23.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TouchCallBackBlock)(void);

@interface UIView (Extension)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize  size;
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGFloat maxX;

@property (nonatomic, copy) TouchCallBackBlock touchCallBackBlock;
- (void)addActionWithblocks:(TouchCallBackBlock)block;
- (void)addTargets:(id)targest actions:(SEL)action;

@end
