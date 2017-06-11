//
//  HBPayWayCell.h
//  CarApp
//
//  Created by 管理员 on 2017/4/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPayWayCell : UITableViewCell
@property(nonatomic,strong)void (^btnBlock)();
@property (strong, nonatomic) IBOutlet UIImageView *payImg;
@property (strong, nonatomic) IBOutlet UILabel *payWay;
-(void)imgName:(NSString *)imgName payWay:(NSString *)payWay ;
@property (strong, nonatomic) IBOutlet UIImageView *select;
@end
