//
//  HBTableViewCell.h
//  CarApp
//
//  Created by 管理员 on 2016/11/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSelectCarModel.h"
@interface HBTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *bane;
-(void)putdata:(HBSelectCarModel *)model;

@end
