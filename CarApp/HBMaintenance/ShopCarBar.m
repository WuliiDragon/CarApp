//
//  ShopCarBar.m
//  CarApp
//
//  Created by 管理员 on 2017/6/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "ShopCarBar.h"

@interface ShopCarBar ()

@end


@implementation ShopCarBar


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"ShopCarBar" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

@end
