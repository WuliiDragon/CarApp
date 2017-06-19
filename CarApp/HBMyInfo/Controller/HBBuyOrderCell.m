//
//  HBBuyOrderCell.m
//  CarApp
//
//  Created by 管理员 on 2017/6/19.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBBuyOrderCell.h"
#import "HBAuxiliary.h"
@interface HBBuyOrderCell ()

@property (strong, nonatomic) IBOutlet UILabel *dateLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *goodidLab;
@property (strong, nonatomic) IBOutlet UILabel *buytimelab;
@property (strong, nonatomic) IBOutlet UILabel *cardCityLab;
@property (strong, nonatomic) IBOutlet UILabel *cityLab;
@property (strong, nonatomic) IBOutlet UILabel *buyWayLab;
@property (strong, nonatomic) IBOutlet UILabel *colorLab;
@property (strong, nonatomic) IBOutlet UILabel *mnameLab;
@property (strong, nonatomic) IBOutlet UILabel *snameLab;
@property (strong, nonatomic) IBOutlet UILabel *bnameLab;
@property (strong, nonatomic) IBOutlet UILabel *statusLab;
@property (strong, nonatomic) NSString *bphone;



@end




@implementation HBBuyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)phone:(id)sender {
[self addSubview: [HBAuxiliary turnTOPhoneWithNumBer:_bphone]];
}

-(void)setModel:(HBBuyOrderModel *)model{
    
    
    
    _priceLab.text = model.price;
    _goodidLab.text = model.goodid;
    _buytimelab.text = model.buytime;
    _cardCityLab.text = model.cardCity;
    _cityLab.text = model.city;
    _buyWayLab.text = model.buyWay;
    _colorLab.text = model.color;
    _mnameLab.text = model.mname;
    _snameLab.text = model.sname;
    _bnameLab.text = model.bname;
    
    
    
    _dateLab.text = model.date;

    
    _bphone = model.bphone;

    
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
