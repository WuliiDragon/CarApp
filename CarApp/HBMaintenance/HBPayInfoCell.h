//
//  HBPayInfoCell.h
//  CarApp
//
//  Created by 管理员 on 2017/4/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPayInfoCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UILabel *item;
@property(strong, nonatomic) IBOutlet UILabel *info;

- (void)ItemString:(NSString *)item InfoString:(NSString *)info;
@end
