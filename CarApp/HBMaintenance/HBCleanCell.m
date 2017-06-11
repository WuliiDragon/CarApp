//
//  HBCleanCell.m
//  CarApp
//
//  Created by 管理员 on 2017/3/18.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBCleanCell.h"
#import "HBAuxiliary.h"


@interface HBCleanCell (){
   
}

@end

@implementation HBCleanCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (IBAction)goodDo:(UIButton *)sender {
    
    if(_number==0){
        [UIView animateWithDuration:0.4 animations:^{
            _countLab.alpha = 1;
            _reduce.alpha = 1;
        }completion:^(BOOL finished) {
            
        }];
    }
    _number++;
    _countLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)_number];
    
    if ([self.delegate respondsToSelector:@selector(tableView:changeStatus:didSelectIndexPath:)]) {
        UITableView *tableView =(UITableView*) self.superview.superview;
        NSDictionary *dic = @{@"reduceStatus" : [NSString stringWithFormat:@"%f" ,_reduce.alpha]    ,
                              @"countLabStatus" : [NSString stringWithFormat:@"%f" ,_countLab.alpha],
                              @"count" : [NSString stringWithFormat:@"%lu",(unsigned long)_number]};
        [self.delegate tableView: tableView changeStatus:dic didSelectIndexPath:_indexPath];
    }
    
    
}


- (IBAction)reduce:(UIButton *)sender {
    if (_number <=1) {
        [UIView animateWithDuration:0.4 animations:^{
            _countLab.alpha = 0;
            _reduce.alpha = 0;
        }completion:^(BOOL finished) {
        }];
    }
    _number--;
    _countLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)_number];
    
    if ([self.delegate respondsToSelector:@selector(tableView:changeStatus:didSelectIndexPath:)]) {
        UITableView *tableView =(UITableView*) self.superview.superview;
        NSDictionary *dic = @{@"reduceStatus" : [NSString stringWithFormat:@"%f" ,_reduce.alpha]    ,
                              @"countLabStatus" : [NSString stringWithFormat:@"%f" ,_countLab.alpha],
                              @"count" : [NSString stringWithFormat:@"%lu",(unsigned long)_number]};
        [self.delegate tableView: tableView changeStatus:dic didSelectIndexPath:_indexPath];
    }
}


-(void)loadDataByModel:(HBCleanCellModel *)model{
    _sname.text = model.sname;
    _sdesc.text = model.sdesc;
    _newprice.text = model.newprice;
    self.oldprice.attributedText =  [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@",model.oldprice ]
                                                                   attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                NSStrikethroughColorAttributeName:[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1.00]}];;

    
    [_reduce setAlpha: [model.reduceStatus floatValue]];
    [_countLab setAlpha: [model.countLabStatus floatValue]];
    [_countLab setText:model.count];
    _number = [model.count integerValue];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)drawRect:(CGRect)rect{
    [_buy addTarget:self action:@selector(clickBuy) forControlEvents:UIControlEventTouchUpInside];
    _buy.layer.cornerRadius = _buy.frame.size.width/2;
    _buy.layer.masksToBounds = YES;
    [_buy setBackgroundColor:[UIColor colorWithRed:0.84 green:0.15 blue:0.31 alpha:1.00]];
    [_buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}




-(void)clickBuy{
    if (self.btnBlock)
        self.btnBlock();
}
@end
