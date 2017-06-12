//
//  HBPayresult.m
//  CarApp
//
//  Created by 管理员 on 2017/4/22.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBPayresult.h"
#import "HBMainPayViewController.h"
#import "AppDelegate.h"
#import "HBBuyCarViewController.h"
#import "BaseNavigationController.h"

@interface HBPayresult () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSString *resultCode;
@property(strong, nonatomic) NSArray *infoItem;
@property(strong, nonatomic) NSMutableArray *info;
@property(strong, nonatomic) NSDictionary *data;
@property(strong, nonatomic) NSString *qid;

@property(strong, nonatomic) UILabel *resinfo;
@property(strong, nonatomic) UIButton *back;
@property(strong, nonatomic) UITableView *resultTableView;


@end

@implementation HBPayresult

- (instancetype)initWithResInfo:(id)data qid:(NSString *)qid resultCode:(NSString *)resultCode {
    _resultCode = resultCode;
    _data = data;
    _qid = qid;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _resinfo = [[UILabel alloc] initWithFrame:CGRectMake((mainScreenWidth - 10) / 2, 10, 200, 30)];
    [self.view addSubview:_resinfo];

    if ([_resultCode isEqualToString:@"Y"]) {
        _resinfo.text = @"支付成功";
    }

    if ([_resultCode isEqualToString:@"C"]) {

        _resinfo.text = @"支付取消";

    }
    if ([_resultCode isEqualToString:@"N"]) {

        _resinfo.text = @"支付失败";

    }
    if ([_resultCode isEqualToString:@"D"]) {
        _resinfo.text = @"订单处理中";
    }


    _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, mainScreenWidth, mainScreenWidth)];
    _resultTableView.dataSource = self;
    _resultTableView.delegate = self;
    [self.view addSubview:_resultTableView];

    _infoItem = [[NSArray alloc] initWithObjects:@"商家名", @"服务名", @"订单编号", @"交易流水号", @"支付金额", @"交易时间", @"手机号", nil];
    _info = [[NSMutableArray alloc] init];

    [_info addObject:_data[@"bmname"]];
    [_info addObject:_data[@"sname"]];
    [_info addObject:_data[@"goodid"]];
    [_info addObject:_qid];
    [_info addObject:[NSString stringWithFormat:@"￥ %@", _data[@"price"]]];
    [_info addObject:_data[@"date"]];
    [_info addObject:_data[@"bphone"]];

    _back = [[UIButton alloc] initWithFrame:CGRectMake((mainScreenWidth - 200) / 2, mainScreenWidth + 80, 200, 30)];
    [_back addActionWithblocks:^{
        //        NSArray *arr =  self.navigationController.viewControllers;
        //        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        //            if([obj isKindOfClass:[HBMainPayViewController class]]){}
        //
        //            [self.navigationController popToViewController:obj animated:YES];
        //
        //        }];
        //        NSLog(@"HBLog:%@",arr);
        //
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        BaseNavigationController *NA = [[BaseNavigationController alloc] initWithRootViewController:[HBBuyCarViewController new]];
        appDelegate.window.rootViewController = NA;
    }];
    [self.view addSubview:_back];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infoItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
    cell.detailTextLabel.text = _info[indexPath.row];
    cell.textLabel.text = _infoItem[indexPath.row];
    //HBPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    //cell.item.text = _infoItem[indexPath.row];
    //cell.info.text = _info[indexPath.row];
    return cell;
}


@end
