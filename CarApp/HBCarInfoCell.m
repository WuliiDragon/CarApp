//
//  HBCarInfoCell.m
//  CarApp
//
//  Created by 管理员 on 2016/11/26.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBCarInfoCell.h"
#import "UIImageView+WebCache.h"
#import "HBAuxiliary.h"

@implementation HBCarInfoCell


- (void)setModels:(HBCarStoreDetailModel *)modeldata {
    _models = modeldata;
    self.gname.text = modeldata.gname;
    self.title1.text = modeldata.title;
    self.guidegprice.text = [NSString stringWithFormat:@"%@万-%@万", [HBAuxiliary makeprice:modeldata.minprice], [HBAuxiliary makeprice:modeldata.maxprice]];


    NSString *str = mainUrl;
    NSString *urlStr = [str stringByAppendingFormat:@"%@", modeldata.gshowImage];
    [self.gshowImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
}

@end
