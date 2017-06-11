//
//  myTableViewCell.h
//  CarApp
//
//  Created by 管理员 on 2016/11/23.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBStoreCarModel.h"

@interface HBCarStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bimage;
@property (weak, nonatomic) IBOutlet UILabel *bname;
@property (weak, nonatomic) IBOutlet UILabel *baddress;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UIImageView *hang;

@property (weak, nonatomic) IBOutlet UILabel *majorbusiness;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property(nonatomic,strong)HBStoreCarModel *models;





- (void)setModels:(HBStoreCarModel *)model;
@end
