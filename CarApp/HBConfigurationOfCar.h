//
//  HBConfigurationOfCar.h
//  CarApp
//
//  Created by 管理员 on 2016/12/24.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBConfigurationOfCar : UITableViewCell
@property(strong, nonatomic) IBOutlet UILabel *item;
@property(strong, nonatomic) IBOutlet UILabel *info;

- (void)item:(NSString *)item info:(NSString *)info;
@end
