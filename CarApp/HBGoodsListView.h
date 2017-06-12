//
//  HBGoodsListView.h
//  CarApp
//
//  Created by 管理员 on 2017/6/8.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBGoodsListView : UIView <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *objects;
@property(nonatomic, strong) UITableView *tableView;


- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects;

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects canReorder:(BOOL)reOrder;
@end
