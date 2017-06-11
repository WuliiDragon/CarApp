//
//  HBMaintenanceCarCell.m
//  CarApp
//
//  Created by 管理员 on 2017/3/15.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBMaintenanceCarCell.h"
#import "UIImageView+WebCache.h"
#import "HBAuxiliary.h"



@implementation HBMaintenanceCarCell



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)loadmodel:(HBMiantenanceCarHomeModel *)model{
    _mbname.text = model.mbname;
    _title1.text = model.title1;
    _baddress.text = model.baddress;
    _title2.text = model.title2;
    
    _distance.text =[HBAuxiliary distance:model.distance];
    
    
    
    NSString *str = mainUrl;
    NSString *urlStr = [str stringByAppendingFormat:@"%@",model.bshowimage] ;
    [_bshowimage sd_setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
    NSString *commentInfo = [NSString stringWithFormat:@"%@人评论%@人购买",model.commentcount,model.purchase];
    _commentcount.text = commentInfo;
    
    NSUInteger score =[model.score intValue];
    NSUInteger width = 14;
    NSUInteger height = 14;
    for (int i = 0; i < score ; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*(width+4), 0, width, height)];
        imgView.image = [UIImage imageNamed:@"star"];
        [_scoreView addSubview:imgView];
    }
    UILabel *star = [[UILabel alloc]initWithFrame:CGRectMake(score*(width+4), 1, 60, 14)];
    star.text = [NSString stringWithFormat:@"%lu.0分",(unsigned long)score];
    [star setFont:[UIFont systemFontOfSize:13.f]];
    [star setTextColor:[UIColor colorWithRed:0.96 green:0.76 blue:0.00 alpha:1.00]];
    [_scoreView addSubview:star];
}

@end
