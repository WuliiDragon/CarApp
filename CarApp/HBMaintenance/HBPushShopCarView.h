//
//  HBPushShopCarView.h
//  CarApp
//
//  Created by 管理员 on 2017/6/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPushShopCarView : UIView

@property(strong, nonatomic) UIView *bgView;
@property(nonatomic, strong) UITableView *tableViewShopCar;
@property(nonatomic, strong) NSMutableArray *ShopCarData;


- (void)removeView;

- (float)updateFrame;

@end
