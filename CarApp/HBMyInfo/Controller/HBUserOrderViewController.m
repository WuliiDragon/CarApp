//
//  HBUserOrderViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/6/18.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBUserOrderViewController.h"
#import "JXSegment.h"
#import "JXPageView.h"
#import "HBBuyOrderCell.h"
#import "HBMianCell.h"
#import "HBNetRequest.h"
#import "HBBuyOrderModel.h"
#import "HBMianModel.h"
@interface HBUserOrderViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate,UITableViewDelegate,UITableViewDataSource>{


    JXPageView *pageView;
    JXSegment *segment;


}

@property(nonatomic,strong) MBProgressHUD *hud;



@property(nonatomic,strong) NSMutableArray *OrderCarArr;//标题模型数组
@property(nonatomic,strong) NSMutableArray *mianCarArr;//标题str数组

@property(nonatomic,strong)UITableView *OrderCarTableView;
@property(nonatomic,strong)UITableView *mianCarTableView;
@end

@implementation HBUserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _OrderCarArr = [[NSMutableArray alloc] init];
    _mianCarArr = [[NSMutableArray alloc] init];
    segment = [[JXSegment alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 40)];
    [segment updateChannels:@[@"在线养车",@"在线订车"]];//给title
    segment.delegate = self;
    [segment.scrollView setShowsVerticalScrollIndicator:YES];
    [self.view addSubview:segment];
    
    pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 40, mainScreenWidth, self.view.bounds.size.height)];
    pageView.datasource = self;
    pageView.delegate = self;
    [pageView reloadData];
    for (int i = 0;  i <  2; i++) {//加载所有tableView
        [pageView changeToItemAtIndex:i];
    }
    [pageView changeToItemAtIndex:0];

    [self.view addSubview:pageView];
    
    self.hud = [[MBProgressHUD alloc]init];
    [self.view addSubview:self.hud];
    [self loadDataMian];
    _hud.labelText = @"加载中";

    
}
-(void)loadDataOrder{//获取标题
    [self.hud show:YES];
    
    [HBNetRequest Get:MYORDER
                 para:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                        @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
                        @"type":@"0"}
             complete:^(id data) {
                 [_OrderCarArr removeAllObjects];
                 NSInteger status = [data[@"status"] integerValue];
                 if (status == 1) {
                     NSArray *orders = data[@"orders"];
                     [orders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         NSDictionary *dic = (NSDictionary *)obj;
                         HBBuyOrderModel *model = [[HBBuyOrderModel alloc]  initWithDictionary:dic error:nil];
                         [_OrderCarArr addObject:model];
                         
                     }];
                     [_OrderCarTableView reloadData];
                 }
                    [self.hud hide:YES];
             }
                 fail:^(NSError *error) {
                     [self.hud hide:YES];
                 }];
}

-(void)loadDataMian{//获取标题
   
    [self.hud show:YES];
    [HBNetRequest Get:MYORDER
                 para:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                        @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
                        @"type":@"1"}
             complete:^(id data) {
                 [_mianCarArr removeAllObjects];
                 NSInteger status = [data[@"status"] integerValue];
                 if (status == 1) {
                     NSArray *orders = data[@"orders"];
                     [orders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         NSDictionary *dic = (NSDictionary *)obj;
                         HBMianModel *model = [[HBMianModel alloc]  initWithDictionary:dic error:nil];
                         [_mianCarArr addObject:model];
                     }];
                     [_mianCarTableView reloadData];
                 }
                 [self.hud hide:YES];
             }
                 fail:^(NSError *error) {
                     [self.hud hide:YES];
                 }];
}




#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return 2;
}

-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
    if(index==1){
        _OrderCarTableView =[[UITableView alloc] init];
        _OrderCarTableView.delegate = self;
        _OrderCarTableView.dataSource = self;
        _OrderCarTableView.estimatedRowHeight = 10;
        [_OrderCarTableView registerNib:[UINib nibWithNibName:@"HBBuyOrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];

        return _OrderCarTableView;
        
    }
    if(index==0){
        _mianCarTableView =[[UITableView alloc] init];
        _mianCarTableView.delegate = self;
        _mianCarTableView.dataSource = self;
        _mianCarTableView.estimatedRowHeight = 10;
        [_mianCarTableView registerNib:[UINib nibWithNibName:@"HBMianCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        return _mianCarTableView;
    }

    return nil;
}

#pragma mark - JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index{
    [pageView changeToItemAtIndex:index];
    
    if (index==1) {
        [self loadDataOrder];
    }else{
        [self loadDataMian];
    }
}

#pragma mark - JXPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    
    
    
    [segment didChengeToIndex:index];
    if (index==1) {
        [self loadDataOrder];
    }else{
        [self loadDataMian];
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==_OrderCarTableView) {
        return [_OrderCarArr count];
    }
    
    
    if (tableView==_mianCarTableView) {
        return [_mianCarArr count];
    }
    
    return 0;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView==_OrderCarTableView) {
        HBBuyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell setModel:_OrderCarArr[indexPath.row]];
        
        
        return cell;
    }
    
    
    if (tableView==_mianCarTableView) {
        HBMianCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:_mianCarArr[indexPath.row]];
        return cell;
    }
    
    return [UITableViewCell new];
    
}




@end
