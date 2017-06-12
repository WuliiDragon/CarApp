//
//  HBrecommendViewCell.h
//  CarApp
//
//  Created by 管理员 on 2016/12/19.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBRecommendModel.h"

@interface HBrecommendViewCell : UICollectionViewCell
@property(strong, nonatomic) IBOutlet UIImageView *mshowImage;
@property(strong, nonatomic) IBOutlet UILabel *mtitle;
@property(strong, nonatomic) IBOutlet UILabel *mname;

@property(strong, nonatomic) IBOutlet UILabel *guidegprice;

- (void)loadmodel:(HBRecommendModel *)model;
@end
