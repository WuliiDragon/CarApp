//
//  HBPayInfoCell.m
//  CarApp
//
//  Created by 管理员 on 2017/4/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBPayInfoCell.h"

@implementation HBPayInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)ItemString :(NSString *)item InfoString:(NSString *)info {
    _info.text = info;
    _item.text = item;
}

@end
