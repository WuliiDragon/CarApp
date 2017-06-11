//
//  HBSeriesOfCarCell.h
//  CarApp
//
//  Created by 管理员 on 2016/12/6.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSeriesOfcarModel.h"
@interface HBSeriesOfCarCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mname;
@property (strong, nonatomic) IBOutlet UILabel *guidegprice;
@property (strong, nonatomic) IBOutlet UILabel *gprice;
@property (strong, nonatomic) IBOutlet UILabel *activity;
@property (strong, nonatomic) IBOutlet UIButton *askLowPrice;
@property (strong, nonatomic) IBOutlet UIButton *installment;
@property (strong, nonatomic) IBOutlet UIButton *onlinePolicy;
@property (strong, nonatomic) IBOutlet UIImageView *mshowImage;
-(void)loadmodel:(HBSeriesOfcarModel *)model;

@end
