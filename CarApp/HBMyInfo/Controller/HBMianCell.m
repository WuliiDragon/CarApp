//
//  HBMianCell.m
//  CarApp
//
//  Created by 管理员 on 2017/6/19.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBMianCell.h"
#import "HBAuxiliary.h"

#import "HBMianModel.h"

@interface HBMianCell ()
@property (strong, nonatomic) IBOutlet UILabel *statusLab;
@property (strong, nonatomic) IBOutlet UILabel *bmnameLab;
@property (strong, nonatomic) IBOutlet UILabel *snameLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *dateLab;
@property (strong, nonatomic) IBOutlet UILabel *goodidLab;

@property(nonatomic,strong) NSString *bphone;
@end


@implementation HBMianCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)Call:(id)sender {
    [self addSubview: [HBAuxiliary turnTOPhoneWithNumBer:_bphone]];
}
-(void)setModel:(HBMianModel *)model{
    _dateLab.text = model.date;
    
    _goodidLab.text = model.goodid;
    _snameLab.text = model.sname;
    _bmnameLab.text = model.bmname;
    _bphone = model.bphone;

    _priceLab.text = model.price;
    
    
    
    
    if ([model.status integerValue]==0) {
        _statusLab.text = @"已付款";
        
    }else if ([model.status integerValue]==1){
        _statusLab.text = @"等待退款";
        
    }else if ([model.status integerValue]==2){
        _statusLab.text = @"交易完成";
        
    }else if ([model.status integerValue]==3){
        _statusLab.text = @"退款成功";
    }else if ([model.status integerValue]==-3){
        _statusLab.text = @"异常";
    }

}





@end
