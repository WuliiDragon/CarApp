//
//  HBUserRollViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/6/18.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBUserRollViewController.h"
#import "HBCouponsCell.h"
#import "HBNetRequest.h"

@interface HBUserRollViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) MBProgressHUD *hud;
@property(strong, nonatomic) NSArray *couponsArr;
@property(strong, nonatomic) NSMutableArray *modelArr;
@property(strong, nonatomic) NSString *types;
@property(assign, nonatomic) float totalPrice;
@end

@implementation HBUserRollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"HBCouponsCell" bundle:nil] forCellReuseIdentifier:@"CouponsCell"];

    _modelArr = [[NSMutableArray alloc] init];
    [self loadData];
    
    
    
    
}


- (void)loadData {
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    [HBNetRequest Post:GETALLROLL para:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HBCouponsModel *model = _modelArr[indexPath.row];
    if (_modelArr.count > 0){
        [cell loadWithModel:model];
        [cell setUseHidden];
        
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
