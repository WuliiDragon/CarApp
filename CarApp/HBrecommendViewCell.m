//
//  HBrecommendViewCell.m
//  CarApp
//
//  Created by 管理员 on 2016/12/19.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBrecommendViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HBrecommendViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadmodel:(HBRecommendModel *)model {
    //_mname.textColor =  [UIColor colorWithRed:219/255.f green:33.f/255.f blue:76.f/255.f alpha:1.f];
    _mname.text = model.mname;
    _mtitle.text = model.mtitle;
    _guidegprice.text = [NSString stringWithFormat:@"%@%@", @"指导价", model.guidegprice];
    NSString *str = mainUrl;
    NSString *urlStr = [str stringByAppendingFormat:@"%@", model.mshowImage];
    [_mshowImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
}
@end
