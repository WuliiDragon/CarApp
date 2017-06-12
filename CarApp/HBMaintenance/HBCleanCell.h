//
//  HBCleanCell.h
//  CarApp
//
//  Created by 管理员 on 2017/3/18.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCleanCellModel.h"

@class RBGuessMatchItem;

@protocol HBCellAnimationDelegate <NSObject>
//- (void) tableView:(UITableView *)tableView goodsCount:(NSInteger)count;
- (void)tableView:(UITableView *)tableView changeStatus:(NSDictionary *)status didSelectIndexPath:(NSIndexPath *)indexPath;
@end


@interface HBCleanCell : UITableViewCell
@property(nonatomic, strong) void (^btnBlock)();
@property(strong, nonatomic) IBOutlet UIButton *buy;
@property(strong, nonatomic) IBOutlet UILabel *sname;
@property(strong, nonatomic) IBOutlet UILabel *sdesc;
@property(strong, nonatomic) IBOutlet UILabel *newprice;
@property(strong, nonatomic) IBOutlet UILabel *oldprice;
@property(strong, nonatomic) NSIndexPath *indexPath;


@property(strong, nonatomic) IBOutlet UIButton *add;
@property(strong, nonatomic) IBOutlet UIButton *reduce;
@property(strong, nonatomic) IBOutlet UILabel *countLab;

@property(assign, nonatomic) NSUInteger number;
@property(nonatomic, strong) RBGuessMatchItem *guessMatchItem;
@property(nonatomic, weak) id <HBCellAnimationDelegate> delegate;//代理
- (void)loadDataByModel:(HBCleanCellModel *)model;
@end
