//
//  HBMaintenanceCarCell.h
//  CarApp
//
//  Created by 管理员 on 2017/3/15.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBMiantenanceCarHomeModel.h"

@interface HBMaintenanceCarCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *bshowimage;
@property(strong, nonatomic) IBOutlet UILabel *commentcount;
@property(strong, nonatomic) IBOutlet UILabel *mbname;
@property(strong, nonatomic) IBOutlet UILabel *baddress;
@property(strong, nonatomic) IBOutlet UILabel *distance;
@property(strong, nonatomic) IBOutlet UILabel *title1;
@property(strong, nonatomic) IBOutlet UILabel *title2;
@property(strong, nonatomic) IBOutlet UIView *scoreView;

- (void)loadmodel:(HBMiantenanceCarHomeModel *)model;
@end
