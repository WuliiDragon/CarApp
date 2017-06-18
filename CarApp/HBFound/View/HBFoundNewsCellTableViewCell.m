//
//  HBFoundNewsCellTableViewCell.m
//  CarApp
//
//  Created by 管理员 on 2017/6/17.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBFoundNewsCellTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface HBFoundNewsCellTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *ntitle;

@property (strong, nonatomic) IBOutlet UILabel *descriptions;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *linkNum;

@end

@implementation HBFoundNewsCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setWithModel :(HBNewsCellModel *)model{
    _ntitle.text = model.ntitle;
    _descriptions.text = model.descriptions;
    _linkNum.text = [NSString stringWithFormat:@"点赞：%@",model.linkNum];
    _date.text = model.date;
    
    
    NSString *str = mainUrl;
    NSString *urlStr = [str stringByAppendingFormat:@"%@", model.image];
    [self.image sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
    
}



@end
