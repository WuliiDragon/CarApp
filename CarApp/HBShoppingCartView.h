//
//  HBShoppingCartView.h
//  CarApp
//
//  Created by 管理员 on 2017/6/8.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBadgeView.h"
#import "HBGoodsListView.h"
#import "HBOverlayView.h"

@interface HBShoppingCartView : UIView


@property(nonatomic, strong) HBBadgeView *badge;
//@property (nonatomic,retain) HBOverlayView *OverlayView;//遮罩图层
@property(nonatomic, strong) HBGoodsListView *OrderList;//选择的订单列表
@property(strong, nonatomic) UIButton *shoppingCartBtn;

@property(strong, nonatomic) UILabel *money;//价格

@property(strong, nonatomic) UIButton *payButton;//选好了

@property(nonatomic, assign) NSUInteger minFreeMoney;//最低起送价

@property(strong, nonatomic) UILabel *line; //分割线

@property(nonatomic, strong) UIView *parentView;//背景图层

@property(nonatomic, assign) NSInteger nTotal;//总价

@property(nonatomic, assign) BOOL open;

@property(nonatomic, assign) NSInteger badgeValue;

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)parentView;

- (void)dismissAnimated:(BOOL)animated;

- (void)setTotalMoney:(NSInteger)nTotal;

- (void)updateFrame:(HBGoodsListView *)orderListView;

@end
