//
//  HBGoodInfoCell.h
//  CarApp
//
//  Created by 管理员 on 2017/6/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCleanCellModel.h"

@interface HBGoodInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *Namelabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic) IBOutlet UIButton *minus;
@property (strong, nonatomic) IBOutlet UIButton *plus;


@property (nonatomic,copy) void (^operationBlock)(NSInteger number);


@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger number;

-(void)ListModel:(HBCleanCellModel *)model;
@end
