//
//  HBCarInfoCell.h
//  CarApp
//
//  Created by 管理员 on 2016/11/26.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCarStoreDetailModel.h"

@interface HBCarInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gshowImage;
@property (weak, nonatomic) IBOutlet UILabel *gname;
@property (weak, nonatomic) IBOutlet UILabel *guidegprice;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UIButton *installment;

@property(nonatomic,strong)HBCarStoreDetailModel *models;
- (void)setModels:(HBCarStoreDetailModel *)model;
@end
