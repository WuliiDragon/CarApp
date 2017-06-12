//
//  HBSearchResultViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/12/9.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBSearchResultViewController.h"
#import "SDCycleScrollView.h"
#import "HBSearchResultModel.h"
#import "HBCarInfoCell.h"
#import "homeImage.h"
#import "HBSeriesOfcarViewController.h"
#import "MJRefresh.h"
#import "HBNetRequest.h"


@interface HBSearchResultViewController () <SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) SDCycleScrollView *loopView;
@property(strong, nonatomic) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *bimageArr;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) NSDictionary *params;
@property(nonatomic, strong) NSMutableArray *homeImageObjArr;

@property(nonatomic, strong) UISearchBar *search;
@property(nonatomic, strong) UILabel *condition;

@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, assign) NSUInteger pageNO;
@property(nonatomic, assign) NSUInteger pageSize;

@end

@implementation HBSearchResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _hud = [[MBProgressHUD alloc] init];
    [self.navigationController.view addSubview:_hud];
    [self loadLoopView];
    [self tableView];
}

- (void)loadLoopView {
    _homeImageObjArr = [[NSMutableArray alloc] init];
    _params = [[NSDictionary alloc] init];
    _bimageArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc] init];

    self.view.backgroundColor = [UIColor whiteColor];
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenWidth * 9 / 16.f + 70)];


    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 30)];
    _search.delegate = self;


    _loopView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, _search.frame.size.height, mainScreenWidth, mainScreenWidth * 9 / 16.f) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];

    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = [UIColor whiteColor];
    _loopView.clickItemOperationBlock = ^(NSInteger index) {
        // NSArray *arr = [self.bimageArr copy];
        // [XLPhotoBrowser showPhotoBrowserWithImages:arr currentImageIndex:index];
    };

    _condition = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth / 10.f, _loopView.frame.size.height + _search.frame.size.height + 3, mainScreenWidth * 8 / 10.f, 40)];
    _condition.text = _seleteItem;
    [_topView addSubview:_search];
    [_topView addSubview:_condition];
    [_topView addSubview:_loopView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight - 64)];
    _tableView.tableHeaderView = _topView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.estimatedRowHeight = 10;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //下拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

    UINib *Nib = [UINib nibWithNibName:@"HBCarInfoCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];


    [_hud show:YES];
    [HBNetRequest Post:SEARCHCONDITION para:nil complete:^(id data) {
        _params = data[@"params"];
        _pageSize = [_params[@"pageSize"] integerValue];
        _pageNO = [_params[@"pageNo"] integerValue];
        NSArray *result = data[@"result"];
        for (NSDictionary *dict in result) {
            HBCarStoreDetailModel *model = [[HBCarStoreDetailModel alloc] initWithDictionary:dict error:nil];
            [_dataArr addObject:model];
        }
        NSArray *bimage = [data objectForKey:@"image"];
        [self loopaimage:bimage];
        [self.tableView reloadData];
        [_hud hide:YES];

    }             fail:^(NSError *error) {
        NSLog(@"HBLog:%@", error);

        [_hud hide:YES];
    }];


}


- (void)loadMore {
    _pageNO++;
    [HBNetRequest Post:SEARCHCONDITION para:@{@"pageNo": [NSString stringWithFormat:@"%lu", (unsigned long) _pageNO]
            }
              complete:^(id data) {
                  _params = data[@"params"];
                  NSArray *result = data[@"result"];
                  for (NSDictionary *dict in result) {
                      HBCarStoreDetailModel *model = [[HBCarStoreDetailModel alloc] initWithDictionary:dict error:nil];
                      [_dataArr addObject:model];
                  }

                  [self.tableView reloadData];
                  [_hud hide:YES];

              } fail:^(NSError *error) {
                NSLog(@"HBLog:%@", error);

                [_hud hide:YES];
            }];

    [_tableView.mj_footer endRefreshing];
}


- (void)loopaimage:(NSArray *)imgurlArr {
    NSMutableArray *urlArr = [[NSMutableArray alloc] init];
    for (NSDictionary *homeImageDic in imgurlArr) {
        homeImage *homeImageObj = [[homeImage alloc] init];
        homeImageObj.imgurl = [homeImageDic objectForKey:@"image"];
        homeImageObj.url = [homeImageDic objectForKey:@"url"];
        [_homeImageObjArr addObject:homeImageObj];
        [urlArr addObject:homeImageObj.imgurl];
    }
    NSString *str = mainUrl;
    for (NSString *Urlstr in urlArr) {
        NSString *url = [str stringByAppendingFormat:@"%@", Urlstr];
        [_bimageArr addObject:url];
    }
    _loopView.imageURLStringsGroup = _bimageArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBCarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    if (_dataArr.count > 0) {
        HBCarStoreDetailModel *model = _dataArr[indexPath.row];
        [cell setModels:model];
    }

    return cell;
}

#pragma mark - 单元格的点击方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HBCarStoreDetailModel *model = _dataArr[indexPath.row];
    HBSeriesOfcarViewController *VC = [[HBSeriesOfcarViewController alloc] init];
    VC.gid = model.gid;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_hud show:YES];
    _hud.labelText = @"搜索中";
    [HBNetRequest Post:SEARCHCONDITION para:@{@"keyword": searchBar.text
            }
              complete:^(id data) {
                  [_dataArr removeAllObjects];
                  _params = data[@"params"];
                  NSArray *result = data[@"result"];
                  for (NSDictionary *dict in result) {
                      HBCarStoreDetailModel *model = [[HBCarStoreDetailModel alloc] initWithDictionary:dict error:nil];
                      [_dataArr addObject:model];
                  }

                  NSArray *bimage = [data objectForKey:@"image"];
                  [self loopaimage:bimage];
                  [self.tableView reloadData];
                  [_hud hide:YES];

              } fail:^(NSError *error) {
                NSLog(@"HBLog:%@", error);

                [_hud hide:YES];
            }];
    [_search resignFirstResponder];
}
@end
