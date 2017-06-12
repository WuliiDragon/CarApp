//
//  HBSeriesOfCarCell.m
//  CarApp
//
//  Created by 管理员 on 2016/12/6.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBSeriesOfCarCell.h"
#import "UIImageView+WebCache.h"
#import "HBAuxiliary.h"

@implementation HBSeriesOfCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)loadmodel:(HBSeriesOfcarModel *)model {
    _mname.text = model.mname;
    _gprice.text = [[HBAuxiliary makeprice:model.gprice] stringByAppendingString:@"万"];
    _guidegprice.text = [[HBAuxiliary makeprice:model.guidegprice] stringByAppendingString:@"万"];
    _activity.text = model.mtitle;


    NSString *str = mainUrl;
    NSString *urlStr = [str stringByAppendingFormat:@"%@", model.mshowImage];
    [_mshowImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
}
@end
