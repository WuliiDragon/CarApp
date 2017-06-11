//
//  HBColorSelectCell.m
//  CarApp
//
//  Created by 管理员 on 2016/12/14.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBColorSelectCell.h"
#import "HBColorSelectModel.h"
#import "HBAuxiliary.h"

@interface HBColorSelectCell ()
@property (strong, nonatomic) IBOutlet UILabel *colorname;

@property (strong, nonatomic) IBOutlet UIImageView *colorimage;

@end

@implementation HBColorSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadmodel:(HBColorSelectModel *)model{
    _colorname.text = model.colorName;
    [_colorimage setImage:[HBAuxiliary saImageWithSingleColor:[HBAuxiliary colorWithHexString:model.colorKey]]];
    _colorimage.layer.cornerRadius = 3;//圆角
    _colorimage.layer.masksToBounds = YES;
}
@end
