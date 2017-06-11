//
//  HBRootViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBRootViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface HBRootViewController ()
-(void) dataInit;//数据初始化
@property(nonatomic,strong)MBProgressHUD *hud;
@end

@implementation HBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hud];
    [self dataInit];
    //tintColor设置为白
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.dataSource = nil;//销毁数据源
}
//初始化数据源
-(void) dataInit{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
}
-(void)postfailure{
    
}
-(void)postparse:(id)data{
    
}
//数据请求
-(void) request:(NSString*)method url:(NSString*)urlString para:(NSDictionary*)dict{
    if ([method isEqualToString:@"GET"]) {
        [HBNetRequest Get:urlString para: dict complete:^(id data) {
            [self parserData:data];
        } fail:^(NSError *error) {
            NSLog(@"GET的失败原因是%@",error);
            [self showHub:NO];
        }];
    }else{
        [HBNetRequest Post:urlString para:dict complete:^(id data) {
            [self postparse:data];
        } fail:^(NSError *error) {
            
            NSLog(@"POST失败原因是%@",error);
            [self postfailure];
        }];
    }
}
-(void) parserData:(id)data{
    
}
- (void)showHub:(BOOL)show{
    if(show){
        [self.hud show:YES];
    }else {
        [self.hud hide:YES];
    }
}

#pragma mark ---- 懒加载 -----
- (MBProgressHUD *)hud {
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc]init];
        // 加载文案
        _hud.labelText = @"正在加载...";
    }
    [self.navigationController.view addSubview:_hud];
    return _hud;
}
@end
