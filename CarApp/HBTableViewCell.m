//
//  HBTableViewCell.m
//  CarApp
//
//  Created by 管理员 on 2016/11/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)putdata:(HBSelectCarModel *)model {
    _bane.text = model.name;
    [_image sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
}
@end
