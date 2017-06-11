
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


@interface HBCouponsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) MBProgressHUD *hud;
@property(strong,nonatomic) HBCleanCellModel *clearmodel;

@property(strong,nonatomic) NSArray *couponsArr;
@property(strong,nonatomic) NSMutableArray *modelArr;

@end

@implementation HBCouponsViewController

-(instancetype)initWithCouponsArr:(HBCleanCellModel  *)model{
    _clearmodel = model;
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];
    [self loadData];
    _modelArr = [[NSMutableArray alloc] init];
}


-(void)loadData{
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    [HBNetRequest Get:[ROLLGET stringByAppendingFormat:@"?token=%@&type=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],_clearmodel.type] para:nil complete:^(id data) {
        
        NSLog(@"HBLog:%@",data);
        NSUInteger status =  [data[@"status"] integerValue];
        if(status==1){
            _couponsArr = data[@"rolls"];
            for (NSMutableDictionary *dic in _couponsArr) {
                HBCouponsModel *model  = [[HBCouponsModel alloc]initWithDictionary:dic error:nil];
                [_modelArr addObject:model];

            }
            [self.tableView reloadData];
        }else{
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            BaseNavigationController *NA = [[BaseNavigationController alloc] initWithRootViewController:[HBLoginViewController new]];
            appDelegate.window.rootViewController =NA;
            
            
        }
        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        [_hud hide:YES];
    }];
    
    
    
}


-(void)loadTableView{
    //指定大小
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth,mainScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    //预估行高estimatedRowHeight,达到cell高度的自适应
    self.tableView.estimatedRowHeight =30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    //注册nib以及重用资源符
    UINib *PayInfoCell = [UINib nibWithNibName:@"HBCouponsCell" bundle:nil];
    [_tableView registerNib:PayInfoCell forCellReuseIdentifier:@"CouponsCell"];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HBCouponsModel *model = _modelArr[indexPath.row];
    if(_couponsArr.count>0){
        //type; 0表示全场通用卷 1,2,3表示对应的服务类型的专用卷 当前类型优惠券只显示全场通用券和当前类型的券  (装潢只显示装潢券和全场通用券)
        if([model.type isEqualToString:@"0"]||[_clearmodel.type isEqualToString:model.type]){
               [cell loadWithModel:model];
            //判断价格 是否满足 大于model.condition 满足买conition 使用优惠券
            if([_clearmodel.newprice integerValue ]  <  [model.condition integerValue] )
                [cell changeBG];
        }
    }
    
    
    cell.btnBlock = ^(){
        if(self.block) {
            self.block(model);
            [_modelArr removeObject:model];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _couponsArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}





@end
