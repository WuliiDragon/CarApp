//
//  HBInfoSetTableViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/4/24.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBInfoSetTableViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "HBAuxiliary.h"
#import "HBUserInfoSetViewController.h"
@interface HBInfoSetTableViewController ()


@property(nonatomic, strong) NSArray *titlelab;
@property(nonatomic, strong) NSMutableArray *infolab;


@end

@implementation HBInfoSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _titlelab = [[NSArray alloc] initWithObjects:@"个人信息", @"应用评分", @"清除缓存", @"修改密码", nil];
    DEFAULTS
    [_infolab addObject:[defaults objectForKey:@"sex"]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = _titlelab[indexPath.row];
    
    
    if (indexPath.row==2) {
        cell.detailTextLabel.text = [ NSString stringWithFormat:@"%.2f MB" ,[[SDImageCache sharedImageCache] getSize] / 1024.f /1024.f ];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        [HBAuxiliary alertWithTitle:@"清除缓存" message:@"确定要清除缓存吗？" button:@[@"确定",@"取消"
                                                                          ] done:^{
                                                                              [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                                                                                  [self.tableView reloadData];
                                                                              }];
                                                                          } cancel:^{
                                                                          }];
        
    }

    
    if (indexPath.row==0) {
        
        HBUserInfoSetViewController *vc = [[HBUserInfoSetViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }







}

@end
