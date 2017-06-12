//
//  HBCouponsCell.m
//  CarApp
//
//  Created by 管理员 on 2017/4/17.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBCouponsCell.h"

@interface HBCouponsCell ()

@property(strong, nonatomic) IBOutlet UIView *BG;

@property(strong, nonatomic) IBOutlet UIView *viewBG;
@property(strong, nonatomic) IBOutlet UIButton *use;

@property(strong, nonatomic) IBOutlet UILabel *cleanitem;


@end

@implementation HBCouponsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickUse:(id)sender {
    if (self.btnBlock)
        self.btnBlock();

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWithModel:(HBCouponsModel *)model {
    NSLog(@"HBLog:%@", [model createdate]);

    _data.text = [NSString stringWithFormat:@"%@~%@", model.createdate, model.pastdate];
    _price.text = [NSString stringWithFormat:@"%@元优惠券", model.price];
    _rname.text = model.rname;

    switch ([model.type integerValue]) {
        case 0: {
            _type.text = @"全场通用券";
            _cleanitem.text = @"全场通用";
        }
            break;

        case 1: {
            _type.text = @"清洗券";
            _cleanitem.text = @"仅限清洗时使用";

        }
            break;
        case 2: {
            _type.text = @"保养券";
            _cleanitem.text = @"仅限保养时使用";

        }
            break;
        case 3: {
            _type.text = @"装潢券";
            _cleanitem.text = @"仅限装潢时使用";

        }
            break;

        default:
            _type.text = @"";
            break;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    

    NSDate *date = [NSDate date];
    [dateFormatter dateStyle];
    NSString *pastdate = [model.pastdate stringByAppendingString:@" 00:00:00"];
    NSDate *dates = [dateFormatter dateFromString:pastdate];
    
    switch ([date compare:dates]) {
        case NSOrderedAscending: break;
        case NSOrderedSame: break;
        case NSOrderedDescending:  [self changeBG]; break;
        default:break;
            
    }

}


- (void)changeBG {
    _BG.backgroundColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
    _viewBG.backgroundColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
    _use.backgroundColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
    _use.enabled = NO;

}

@end
