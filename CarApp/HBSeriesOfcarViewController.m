//
//  HBSeriesOfcarViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/12/6.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBSeriesOfcarViewController.h"
#import "HBInstallmentViewController.h"
#import "HBOrderingCarViewController.h"
#import "HBAskLowPriceViewController.h"
#import "HBCarDetailViewController.h"
#import "HBSeriesOfCarCell.h"


#import "UIImageView+WebCache.h"
#import "XLPhotoBrowser.h"
#import "SDCycleScrollView.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"


@interface HBSeriesOfcarViewController () <SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property(nonatomic, strong) UIView *topView;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) SDCycleScrollView *loopView;
@property(nonatomic, strong) UILabel *gnamelab;
@property(nonatomic, strong) UILabel *pricelab;
@property(nonatomic, strong) UILabel *activitylab;
@property(nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic, strong) NSMutableArray *bimageArr;
@property(nonatomic, strong) NSMutableArray *dataArr;


@property(nonatomic, strong) NSString *stage12;
@property(nonatomic, strong) NSString *stage24;
@property(nonatomic, strong) NSString *stage36;
@property(nonatomic, strong) NSString *bid;
@property(nonatomic, strong) NSString *bphone;
@property(nonatomic, strong) NSString *gname;
@property(nonatomic, strong) NSString *maxprice;
@property(nonatomic, strong) NSString *minprice;
@property(nonatomic, strong) NSString *activity;

@end

@implementation HBSeriesOfcarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.navigationController.view addSubview:_hud];
    _bimageArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc] init];


    [self loadTableView];
    [self loadTopView];
    [self tableView];
    [self fetchProject:NO];

}

- (void)loadTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, [UIScreen mainScreen].bounds.size.height - 64)];

    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;


    _tableView.estimatedRowHeight = 10;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchProject:YES];
    }];

    UINib *Nib = [UINib nibWithNibName:@"HBSeriesOfCarCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];
    [self.view addSubview:_tableView];
}


- (void)loadTopView {
    _loopView = [[SDCycleScrollView alloc] init];
    _loopView.delegate = self;
    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = mainColor;
    _loopView.pageDotColor = [UIColor whiteColor];
    HBSeriesOfcarViewController *__weak weakSelf = self;
    _loopView.clickItemOperationBlock = ^(NSInteger index) {
        NSArray *arr = [weakSelf.bimageArr copy];
        [XLPhotoBrowser showPhotoBrowserWithImages:arr currentImageIndex:index];
    };
    _tableView.tableHeaderView = _loopView;
    [_loopView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f));
        make.top.bottom.left.right.offset(0);
    }];


    UIView *carOfSeriesinfo = [[UIView alloc] init];
    carOfSeriesinfo.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:0.65];
    [_loopView addSubview:carOfSeriesinfo];
    [carOfSeriesinfo makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, 100));
        make.bottom.left.right.offset(0);
    }];


    _gnamelab = [[UILabel alloc] init];
    _gnamelab.textColor = [UIColor whiteColor];
    [carOfSeriesinfo addSubview:_gnamelab];
    [_gnamelab makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, 20));
        make.top.left.offset(5);
    }];

    _pricelab = [[UILabel alloc] init];
    _pricelab.textColor = [UIColor whiteColor];
    _pricelab.font = [UIFont systemFontOfSize:13.f];
    [carOfSeriesinfo addSubview:_pricelab];
    [_pricelab makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(300, 20));
        make.top.equalTo(_gnamelab.bottom).offset(5);
        make.left.offset(5);
    }];


    _activitylab = [[UILabel alloc] init];
    _activitylab.font = [UIFont systemFontOfSize:13.f];
    _activitylab.textColor = [UIColor whiteColor];
    [carOfSeriesinfo addSubview:_activitylab];
    [_activitylab makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(300, 20));
        make.top.equalTo(_pricelab.bottom).offset(5);
        make.left.offset(5);

    }];

}


- (void)fetchProject:(BOOL)refresh {

    if (!refresh)[self.hud show:YES];

    [HBNetRequest Get:SERIESOFCAR
                 para:@{@"gid": _gid}
             complete:^(id data) {

                 if (refresh) {
                     [_bimageArr removeAllObjects];
                     [_dataArr removeAllObjects];
                 }

                 NSDictionary *car = data[@"car"];
                 _gname = [car objectForKey:@"gname"];
                 _maxprice = [HBAuxiliary makeprice:[car objectForKey:@"maxprice"]];
                 _minprice = [HBAuxiliary makeprice:[car objectForKey:@"minprice"]];
                 _stage12 = [car objectForKey:@"stages12"];
                 _stage24 = [car objectForKey:@"stages24"];
                 _stage36 = [car objectForKey:@"stages36"];
                 _activity = [car objectForKey:@"title"];
                 _bid = [car objectForKey:@"bid"];

                 _gnamelab.text = _gname;
                 NSString *priceStr = [NSString stringWithFormat:@"%@万 ~ %@万", _minprice, _maxprice];
                 _pricelab.text = priceStr;
                 _activitylab.text = _activity;


                 NSArray *childs = car[@"childs"];
                 for (NSDictionary *dict in childs) {
                     HBSeriesOfcarModel *model = [[HBSeriesOfcarModel alloc] initWithDictionary:dict error:nil];
                     [_dataArr addObject:model];
                 }
                 NSArray *gimage = [car objectForKey:@"gimage"];
                 _loopView.imageURLStringsGroup = [HBAuxiliary loopaimage:gimage];

                 [self.tableView reloadData];
                 [_hud hide:YES];

                 [_tableView.mj_header endRefreshing];//结束刷新

             } fail:^(NSError *error) {
                [_tableView.mj_header endRefreshing];//结束刷新
                [_hud hide:YES];
                NSLog(@"%@", error);

            }];
}


#pragma mark tableViewCell填充数据

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBSeriesOfCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL"];


    if (_dataArr.count > 0) {
        HBSeriesOfcarModel *model = _dataArr[indexPath.row];
        [cell loadmodel:model];

    }


    [cell.askLowPrice addTarget:self action:@selector(clickAskLowPrice:) forControlEvents:UIControlEventTouchUpInside];
    cell.askLowPrice.tag = indexPath.row;
    [cell.onlinePolicy addTarget:self action:@selector(clickOnlinePolicy:) forControlEvents:UIControlEventTouchUpInside];
    [cell.installment addTarget:self action:@selector(clickInstallment:) forControlEvents:UIControlEventTouchUpInside];
    cell.installment.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HBSeriesOfcarModel *model = _dataArr[indexPath.row];
    HBCarDetailViewController *VC = [[HBCarDetailViewController alloc] init];
    VC.mid = model.mid;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)clickAskLowPrice:(UIButton *)btu {
    HBAskLowPriceViewController *VC = [[HBAskLowPriceViewController alloc] init];
    HBSeriesOfcarModel *seriesOfCarModel = _dataArr[btu.tag];
    VC.distanceStr = _distance;
    VC.bid = _bid;
    VC.carinfo = seriesOfCarModel.mname;
    VC.mid = seriesOfCarModel.mid;

    [self.navigationController pushViewController:VC animated:YES];

}

- (void)clickOnlinePolicy:(id)sender {
    UIButton *btu = sender;
    HBSeriesOfcarModel *seriesOfCarModel = _dataArr[btu.tag];
    HBOrderingCarViewController *VC = [[HBOrderingCarViewController alloc] init];
    VC.seriesOfCarModel = seriesOfCarModel;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)clickInstallment:(id)sender {
    HBInstallmentViewController *VC = [[HBInstallmentViewController alloc] init];
    UIButton *btu = sender;
    HBSeriesOfcarModel *seriesOfCarModel = _dataArr[btu.tag];
    VC.stage12 = _stage12;
    VC.stage24 = _stage24;
    VC.stage36 = _stage36;
    VC.gprice = seriesOfCarModel.gprice;
    [self.navigationController pushViewController:VC animated:YES];

}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂没有数据";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
            NSForegroundColorAttributeName: [UIColor lightGrayColor],
            NSParagraphStyleAttributeName: paragraph
    };

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIImage *image = [UIImage imageNamed:@"noNetwork"];
    return image;
}


- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    [self fetchProject:NO];
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 60;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 0;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:243.0 / 255 alpha:1.0];
}

@end
