//
//  FoundViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/22.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "FoundViewController.h"

#import "JXSegment.h"
#import "JXPageView.h"
#import "HBNewsModel.h"
#import "HBFoundNewsCellTableViewCell.h"
#import "HBNewsCellModel.h"
#import "HBNewsViewController.h"

@interface FoundViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    JXPageView *pageView;
    JXSegment *segment;
    
}

@property(nonatomic,strong) MBProgressHUD *hud;
@property(nonatomic,strong) NSMutableArray *listArr;//标题模型数组
@property(nonatomic,strong) NSMutableArray *titleArr;//标题str数组
@property(nonatomic,strong) NSMutableArray *tableViews;//tableview数组
@property(nonatomic,strong) NSMutableArray *tableViewsdata;//tableview数据源数组
@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listArr = [[NSMutableArray alloc] init];//数组初始化
    _titleArr = [[NSMutableArray alloc] init];
    _tableViews = [[NSMutableArray alloc] init];
    _tableViewsdata = [[NSMutableArray alloc] init];

    [self loadTitle];
    
}
-(void)loadTheView{
    
    segment = [[JXSegment alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 40)];
    [segment updateChannels:_titleArr];//给title
    segment.delegate = self;
    [segment.scrollView setShowsVerticalScrollIndicator:YES];
    [self.view addSubview:segment];
    
    pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 40, mainScreenWidth, self.view.bounds.size.height)];
    pageView.datasource = self;
    pageView.delegate = self;
    [pageView reloadData];
    for (int i = 0; i<[_listArr count]; i++) {//加载所有tableView
        [pageView changeToItemAtIndex:i];
    }
    [pageView changeToItemAtIndex:0];
    [self.view addSubview:pageView];
    
    
    [self loadTableDataWithNewsModel:_listArr[0] withIndex:0];//加载第一个
}

-(void)loadTitle{//获取标题
    self.hud = [[MBProgressHUD alloc]init];
    [self.view addSubview:self.hud];
    _hud.labelText = @"加载中";
    [self.hud show:YES];
    [HBNetRequest Get:GETCATALOG
                 para:nil
             complete:^(id data) {
                 
                 NSInteger status = [data[@"status"] integerValue];
                 if (status == 1) {
                     NSArray *list = data[@"list"];
                     for (NSDictionary *dict in list) {
                         HBNewsModel *model = [[HBNewsModel alloc] initWithDictionary:dict error:nil];
                         [_listArr addObject:model];//拿到title
                         [_titleArr addObject:model.cname];
                         [_tableViewsdata addObject:@""];
                     }
                 }

                [self loadTheView];//加载View
                [self.hud hide:YES];
             }
                 fail:^(NSError *error) {
                     [self.hud hide:YES];
                 }];
}



-(void)loadTableDataWithNewsModel :(HBNewsModel *)model  withIndex:(NSInteger )index{
    
    id temp =  _tableViewsdata[index];
    if (![temp isKindOfClass:[NSString class]]) {
        return;
    }
    
    
    [self.view addSubview:self.hud];
    
    [self.hud show:YES];
    _hud.labelText = @"加载中";
    
    
    [HBNetRequest Get:GETALL
                 para:@{@"cid":model.catid}
             complete:^(id data) {
                 
                 NSInteger status = [data[@"status"] integerValue];
                 if (status==1) {
                     NSArray *list = data[@"list"];
                     
                     NSMutableArray *tableViewData = [[NSMutableArray alloc] init];
                     [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         NSDictionary *dic = (NSDictionary *)obj;
                         HBNewsCellModel *model = [[HBNewsCellModel alloc] init];
                         model.cid = dic[@"cid"];
                         model.date = dic[@"date"];
                         model.descriptions = dic[@"description"];
                         model.image = dic[@"image"];
                         model.linkNum = dic[@"linkNum"];
                         model.nid = dic[@"nid"];
                         model.ntitle = dic[@"ntitle"];
                         
                         
                         [tableViewData addObject:model];
                     }];
                     
                     [_tableViewsdata replaceObjectAtIndex:index withObject:tableViewData];
                     UITableView *tableView = [_tableViews objectAtIndex:index];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                            [tableView reloadData];
                     });
                  
                 }
                 [self.hud hide:YES];
             }
                 fail:^(NSError *error) {
                     [self.hud hide:YES];
                 }];
}


#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return [_titleArr count];
}

-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
    
    UITableView *tableView=  [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 10;
    [tableView registerNib:[UINib nibWithNibName:@"HBFoundNewsCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];


    
    [_tableViews addObject:tableView];
    return tableView;
}

#pragma mark - JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index{
    [pageView changeToItemAtIndex:index];
    
    
    HBNewsModel *model = _listArr[index];
    [self loadTableDataWithNewsModel:model withIndex:index];
    
}

#pragma mark - JXPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [segment didChengeToIndex:index];
    
    
    HBNewsModel *model = _listArr[index];
    [self loadTableDataWithNewsModel:model withIndex:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_tableViewsdata count]==0  ) return 0;
    id list =  [_tableViewsdata objectAtIndex:[_tableViews indexOfObject:tableView]];
    if ([list isKindOfClass:[NSString class]]) {
        return 0;
    }
    return [list count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBFoundNewsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSArray *list =  [_tableViewsdata objectAtIndex:[_tableViews indexOfObject:tableView]];
    HBNewsCellModel *model =  list[indexPath.row];
    [cell setWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *list =  [_tableViewsdata objectAtIndex:[_tableViews indexOfObject:tableView]];
    HBNewsCellModel *model =  list[indexPath.row];
    
    HBNewsViewController *vc = [[HBNewsViewController alloc] initWithNid:model.nid];
    [self.navigationController pushViewController:vc animated:YES];


}

@end
