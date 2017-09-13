//
//  HBDealerViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/7/4.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBDealerViewController.h"
#import "YZPullDownMenu.h"
#import "YZMenuButton.h"
#import "HBCarStoreCell.h"
#import "HBStoreCarModel.h"
#import "HBCarStoreDetailViewController.h"
#import "YZSortViewController.h"
@interface HBDealerViewController ()<YZPullDownMenuDataSource,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *titles;
@property(strong, nonatomic) UITableView *tableView;

@property(nonatomic, strong) MBProgressHUD *hud;
@property(strong, nonatomic) NSMutableArray *CarStoreArr;

@end

@implementation HBDealerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    YZPullDownMenu *menu = [[YZPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 0, mainScreenWidth, 44);
    [self.view addSubview:menu];
    // 设置下拉菜单代理
    menu.dataSource = self;
    // 添加子控制器
    [self setupAllChildViewController];
    
    // 初始化标题
    _titles = @[@"西安市",@"车型",@"离我最近"];
    _CarStoreArr = [[NSMutableArray alloc] init];
    
    
    
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载位置";
    [self.navigationController.view addSubview:_hud];
    [_hud show:YES];
    
    [self loadTableView ];
    [self fetchProject:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCar:) name:@"namechage" object:nil];

    //https://www.singpa.com/carshop/car/goods/query.action?gname=-1
    
}

- (void)changeCar:(NSNotification *)sender {
    _hud.labelText = @"正在加载...";
    [self.hud show:YES];
    DEFAULTS
    [HBNetRequest Get:JINXIAOSHANG para:@{@"latitude":[defaults objectForKey:@"latitude"],
                                          @"longitude":[defaults objectForKey:@"longitude"],
                                          @"gname":sender.userInfo[@"title"]
                                          } complete:^(id data) {
                                              [_CarStoreArr removeAllObjects];
                                              NSArray *carstore = data[@"list"];
                                              //解析Json给数据模型
                                              for (NSDictionary *dict in carstore) {
                                                  HBStoreCarModel *model = [[HBStoreCarModel alloc] initWithDictionary:dict error:nil];
                                                  [_CarStoreArr addObject:model];
                                              }
                                              //tableView数据重载
                                              dispatch_async(dispatch_get_main_queue(), ^{//重载数据
                                                  //解析图片地址
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_header endRefreshing];
                                                  [self.hud hide:YES];
                                              });
                                              
                                          }            fail:^(NSError *error) {
                                              [_tableView.mj_header endRefreshing];//结束刷新
                                              [_hud hide:YES];
                                              NSLog(@"%@", error);
                                              
                                          }];
}


#pragma mark - 添加子控制器
- (void)setupAllChildViewController{
    UITableViewController *allCourse = [[UITableViewController alloc] init];
    YZSortViewController *sort = [[YZSortViewController alloc] init];
    UITableViewController *moreMenu = [[UITableViewController alloc] init];
    [self addChildViewController:allCourse];
    [self addChildViewController:sort];
    [self addChildViewController:moreMenu];
}


- (void)fetchProject:(BOOL)refresh {
    _hud.labelText = @"正在加载...";
    DEFAULTS
    if (!refresh) {
        [self.hud show:YES];
    }
    
    [HBNetRequest Get:JINXIAOSHANG para:@{@"latitude":[defaults objectForKey:@"latitude"],
                                      @"longitude":[defaults objectForKey:@"longitude"],
                                      @"gname":@"-1"
                                      } complete:^(id data) {
        if (refresh) {
            [_CarStoreArr removeAllObjects];
        }
        
        NSArray *carstore = data[@"list"];
        //解析Json给数据模型
        for (NSDictionary *dict in carstore) {
            HBStoreCarModel *model = [[HBStoreCarModel alloc] initWithDictionary:dict error:nil];
            [_CarStoreArr addObject:model];
        }
        //tableView数据重载
        dispatch_async(dispatch_get_main_queue(), ^{//重载数据
            //解析图片地址
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.hud hide:YES];
        });
        
    }            fail:^(NSError *error) {
        [_tableView.mj_header endRefreshing];//结束刷新
        [_hud hide:YES];
        NSLog(@"%@", error);
        
    }];
}


- (void)loadTableView {
    //指定大小
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 -44)];
    //指定headerView
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    self.tableView.emptyDataSetSource = self;
//    self.tableView.emptyDataSetDelegate = self;
    
    _tableView.tableFooterView = [UIView new];
    //预估行高estimatedRowHeight,达到cell高度的自适应
    _tableView.estimatedRowHeight = 110;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //注册nib以及重用资源符
    UINib *Nib = [UINib nibWithNibName:@"HBCarStoreCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];
    [self.view addSubview:_tableView];
    
}


#pragma mark - YZPullDownMenuDataSource
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu{
    return 3;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    YZMenuButton *button = [YZMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:mainColor forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"标签-向下箭头"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateSelected];
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index{
    
    
    
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index{
    // 第1列 高度
    if (index == 0) {
        return 0;
    }
    // 第2列 高度
    if (index == 1) {
        return 180;
    }
    // 第3列 高度
    return 0;
}




#pragma mark tableView数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CarStoreArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBCarStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    if (_CarStoreArr.count > 0) {
        HBStoreCarModel *model = _CarStoreArr[indexPath.row];
        [cell setModels:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HBStoreCarModel *model = _CarStoreArr[indexPath.row];
    HBCarStoreDetailViewController *VC = [[HBCarStoreDetailViewController alloc] init];
    VC.StoreCarModel = model;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeCar" object:nil];
}


@end
