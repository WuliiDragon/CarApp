//
//  HBMenuItem.h
//  CarApp
//
//  Created by 管理员 on 2016/12/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBMenuItem : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *title;
-(void) title:(NSString *) title image :(NSString *)index;
@end
