//
//  HBGoodInfoCell.m
//  CarApp
//
//  Created by 管理员 on 2017/6/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBGoodInfoCell.h"

@interface HBGoodInfoCell()


@end



@implementation HBGoodInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)add:(id)sender {
    self.number =[self.numberLabel.text intValue];
    self.number += 1;
    [self showNumber:self.number];
    self.operationBlock(self.number);
}
- (IBAction)reduce:(id)sender {
    self.number =[self.numberLabel.text intValue];
    self.number -=1;
    [self showNumber:self.number];
    self.operationBlock(self.number);
}

-(void)showNumber:(NSUInteger)count{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.number];
}


-(void)ListModel:(HBCleanCellModel *)model{
    self.Namelabel.text = model.sname;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",[model.newprice  floatValue] * [model.count integerValue]];
    self.numberLabel.text = model.count;
}

@end
