//
//  HBPushShopCarView.m
//  CarApp
//
//  Created by 管理员 on 2017/6/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBPushShopCarView.h"
#import "HBGoodInfoCell.h"
@interface HBPushShopCarView ()<UITableViewDelegate,UITableViewDataSource>


@end
@implementation HBPushShopCarView



#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ShopCarData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    HBCleanCellModel *model = _ShopCarData[indexPath.row];
    [cell ListModel:model];
    __weak __typeof(&*cell)weakCell =cell;

    cell.operationBlock=^(NSInteger number){
        model.count = [NSString stringWithFormat:@"%ld",(long)number];
        weakCell.priceLabel.text =[NSString stringWithFormat:@"￥ %.2f", [model.count integerValue] * [model.newprice floatValue]];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeData" object:self userInfo:@{@"model":model}];
    };

    return cell;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, mainScreenHeight, mainScreenWidth, mainScreenHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        [self loadTableViewShopCar];
    }
    return self;
}

- (void)loadTableViewShopCar{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1.00];
    UILabel *ShopCarTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 300, 30)];
    [ShopCarTitle setText:@"购物车"];
    [ShopCarTitle setTextColor:[UIColor whiteColor]];
    [ShopCarTitle setFont:[UIFont systemFontOfSize:20]];
    [headerView addSubview:ShopCarTitle];
    
    
    UIButton *clearAll = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth-58, 10, 50, 30)];
    [clearAll.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [clearAll setTitle:@"清空" forState:UIControlStateNormal];
    [clearAll addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:clearAll];
    [self.bgView addSubview:headerView];
    
    
    
    _tableViewShopCar = [[UITableView alloc]initWithFrame:CGRectMake(0,50 ,mainScreenWidth,0)];
    _tableViewShopCar.delegate = self;
    _tableViewShopCar.dataSource = self;
    _tableViewShopCar.tableFooterView = [UIView new];
    _tableViewShopCar.estimatedRowHeight = 110;
    _tableViewShopCar.rowHeight = UITableViewAutomaticDimension;
    _tableViewShopCar.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_tableViewShopCar registerNib:[UINib nibWithNibName:@"HBGoodInfoCell" bundle:nil] forCellReuseIdentifier:@"MYCELL"];
    [self.bgView addSubview:_tableViewShopCar];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        self.bgView.y = mainScreenHeight;
    }completion:^(BOOL finished) {
        for (UIView *cover in mainKeyWindow.subviews) {
            if ([cover isKindOfClass:[HBPushShopCarView class]]) {
                [cover removeFromSuperview];
            }
        }
    }];
}


-(void)clearAll{
    [_ShopCarData removeAllObjects];
    [_tableViewShopCar reloadData];
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearAll" object:self userInfo:nil];
    [self removeView];
   }


-(void)removeView{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        self.bgView.y = mainScreenHeight;
    }completion:^(BOOL finished) {
        for (UIView *cover in mainKeyWindow.subviews) {
            if ([cover isKindOfClass:[HBPushShopCarView class]]) {
                [cover removeFromSuperview];
            }
        }
    }];



}




-(float)updateFrame{
    if (_ShopCarData.count==0) {
        return 0;
    }
    float height = 0;
    height = [_ShopCarData count] * 45;
    
    height = height  >=  mainScreenHeight * 0.7f ? mainScreenHeight * 0.7f : height ;
    [_tableViewShopCar setFrame:CGRectMake(0,50 ,mainScreenWidth, height)];
    return height + 50 ;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}
@end
