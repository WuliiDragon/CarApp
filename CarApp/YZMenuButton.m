//
//  YZMenuButton.m
//  CarApp
//
//  Created by 管理员 on 2017/7/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "YZMenuButton.h"

@implementation YZMenuButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.imageView.x < self.titleLabel.x) {
        self.titleLabel.x = self.imageView.x;
        self.imageView.x = self.titleLabel.maxX + 10  ;
    }
}

@end
