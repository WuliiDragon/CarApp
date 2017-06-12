//
//  HBPayWayCell.m
//  CarApp
//
//  Created by 管理员 on 2017/4/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBPayWayCell.h"

@implementation HBPayWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)imgName:(NSString *)imgName payWay:(NSString *)payWay {
    _payImg.image = [UIImage imageNamed:imgName];
    _payWay.text = payWay;
}


@end
