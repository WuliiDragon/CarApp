//
//  HBCouponsCell.h
//  CarApp
//
//  Created by 管理员 on 2017/4/17.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCouponsModel.h"
@interface HBCouponsCell : UITableViewCell
@property(nonatomic,strong)void (^btnBlock)();
@property (strong, nonatomic) IBOutlet UILabel *rname;
@property (strong, nonatomic) IBOutlet UILabel *data;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *type;
-(void)loadWithModel:(HBCouponsModel*) model;
-(void)changeBG;

@end
