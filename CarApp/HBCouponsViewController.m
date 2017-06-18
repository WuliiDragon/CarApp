
//
//  HBCouponsViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/4/17.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBCouponsViewController.h"
#import "HBCouponsCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HBNetRequest.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "HBLoginViewController.h"


@interface HBCouponsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) MBProgressHUD *hud;
@property(strong, nonatomic) NSArray *couponsArr;
@property(strong, nonatomic) NSMutableArray *modelArr;
@property(strong, nonatomic) NSString *types;
@property(assign, nonatomic) float totalPrice;

@end

@implementation HBCouponsViewController

- (instancetype)initTypes:(NSString *)types modelArr:(NSMutableArray*)modelArr totalPrice:(float)totalPrice{
    _modelArr = modelArr;
    _types = types;
    _totalPrice = totalPrice;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];
    
    if(_modelArr ==nil)
        [self.navigationController popViewControllerAnimated:YES];
    if ([_modelArr count]==0) {
         [self loadData];
    }
    
    
    [self.tableView reloadData];
}


- (void)loadData {
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.view addSubview:_hud];
    [_hud show:YES];

    [HBNetRequest Post:ROLLGET para:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                                       @"type":_types
                                      } complete:^(id data) {
        NSUInteger status = [data[@"status"] integerValue];
        if (status == 1) {
            _couponsArr = data[@"rolls"];
            for (NSMutableDictionary *dic in _couponsArr) {
                HBCouponsModel *model = [[HBCouponsModel alloc] initWithDictionary:dic error:nil];
                [_modelArr addObject:model];
            }
            [self.tableView reloadData];
        }
        [_hud hide:YES];
    }
                 fail:^(NSError *error) {
        NSLog(@"%@", error);
        [_hud hide:YES];
    }];


}


- (void)loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"HBCouponsCell" bundle:nil] forCellReuseIdentifier:@"CouponsCell"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HBCouponsModel *model = _modelArr[indexPath.row];
    if (_modelArr.count > 0) {
        NSArray *typeArr = [_types componentsSeparatedByString:@","];
        //type; 0表示全场通用卷 1,2,3表示对应的服务类型的专用卷 当前类型优惠券只显示全场通用券和当前类型的券  (装潢只显示装潢券和全场通用券)
        if ([typeArr containsObject:model.type] || [model.type isEqualToString:@"0"]) {
            [cell loadWithModel:model];
            //满  condition 元才可使用  并且当且支付价格需大于优惠券价格
            if (_totalPrice < [model.condition integerValue] ||_totalPrice < [model.price floatValue] )
                [cell changeBG];
        }
    }
    
    
    
    
    cell.btnBlock = ^() {
        if (self.block) {
            [_modelArr removeObject:model];
            self.block(model ,_modelArr);
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end
