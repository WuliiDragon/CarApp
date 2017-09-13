//
//  HBCarStoreDetailViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/30.
//  Copyright © 2016年 dragon. All rights reserved.
//


#import "HBCarStoreDetailViewController.h"
#import "HBSeriesOfcarViewController.h"
#import "HBAskLowPriceViewController.h"


#import "HBCarInfoCell.h"


#import "XLPhotoBrowser.h"
#import "SDCycleScrollView.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIImageView+WebCache.h"


@interface HBCarStoreDetailViewController () <SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic, strong) SDCycleScrollView *loopView;
@property(strong, nonatomic) UITableView *tableView;
@property(nonatomic, strong) MBProgressHUD *hud;


@property(nonatomic, strong) NSMutableArray *bimageArr;
@property(nonatomic, strong) NSMutableArray *dataArr;

@property(nonatomic, strong) UILabel *bnamelab;
@property(nonatomic, strong) UILabel *baddresslab;
@property(nonatomic, strong) UILabel *majorbusinesslab;
@property(nonatomic, strong) UILabel *distancelab;
@property(nonatomic, strong) UILabel *phonelab;


//分期政策
@property(nonatomic, strong) NSString *stages;
@property(nonatomic, strong) NSString *baddress;
@property(nonatomic, strong) NSString *bname;
@property(nonatomic, strong) NSString *bphone;
@property(nonatomic, strong) NSString *majorbusiness;


@end

@implementation HBCarStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bimageArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc] init];


    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.navigationController.view addSubview:_hud];


    self.view.backgroundColor = [UIColor whiteColor];
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 30, 4)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 4)];
    img.image = [UIImage imageNamed:@"moreact"];
    [testView addSubview:img];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:testView];

    //titleView设置图片
    UIView *titlestoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
    UIImageView *titlestoreImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
    titlestoreImg.image = [UIImage imageNamed:@"titlestore"];
    [titlestoreView addSubview:titlestoreImg];
    self.navigationItem.titleView = titlestoreView;


    [self loadTableView];
    [self loadTopView];
    [self fetchProject:NO];

}

- (void)loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];


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
    [(MJRefreshAutoNormalFooter *) self.tableView.mj_footer setTitle:@"已全部加载完毕" forState:MJRefreshStateNoMoreData];
    _tableView.mj_footer.hidden = YES;


    UINib *Nib = [UINib nibWithNibName:@"HBCarInfoCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];
    [self.view addSubview:_tableView];
}

- (void)loadTopView {
    _loopView = [[SDCycleScrollView alloc] init];
    _loopView.delegate = self;
    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = mainColor;
    _loopView.pageDotColor = [UIColor whiteColor];
    HBCarStoreDetailViewController *__weak weakself = self;
    _loopView.clickItemOperationBlock = ^(NSInteger index) {
        NSArray *arr = [weakself.bimageArr copy];
        [XLPhotoBrowser showPhotoBrowserWithImages:arr currentImageIndex:index];
    };
    _tableView.tableHeaderView = _loopView;
    [_loopView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f));  // 设置尺寸
    }];


    UIView *carStoreinfo = [[UIView alloc] init];
    carStoreinfo.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:0.65];
    [_loopView addSubview:carStoreinfo];
    [carStoreinfo makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.size.equalTo(CGSizeMake(mainScreenWidth, 90));
    }];

    _bnamelab = [[UILabel alloc] init];
    _bnamelab.textColor = [UIColor whiteColor];
    _bnamelab.font = [UIFont systemFontOfSize:13];
    [carStoreinfo addSubview:_bnamelab];
    [_bnamelab makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(300, 15));
        make.top.left.offset(5);
    }];


    _baddresslab = [[UILabel alloc] init];
    _baddresslab.textColor = [UIColor whiteColor];
    _baddresslab.font = [UIFont systemFontOfSize:13.f];
    [carStoreinfo addSubview:_baddresslab];
    [_baddresslab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bnamelab.bottom).offset(5);
        make.left.offset(5);
        make.size.equalTo(CGSizeMake(300, 15));
    }];


    _majorbusinesslab = [[UILabel alloc] init];
    _majorbusinesslab.textColor = [UIColor whiteColor];
    _majorbusinesslab.font = [UIFont systemFontOfSize:13.f];
    [carStoreinfo addSubview:_majorbusinesslab];

    [_majorbusinesslab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_baddresslab.bottom).offset(5);
        make.left.offset(5);
        make.size.equalTo(CGSizeMake(mainScreenWidth, 15));
    }];

    UIImageView *distanceImg = [[UIImageView alloc] init];
    distanceImg.image = [UIImage imageNamed:@"distance"];
    [carStoreinfo addSubview:distanceImg];
    [distanceImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(5);
        make.size.equalTo(CGSizeMake(20, 20));
    }];


    UIImageView *phoneImg = [[UIImageView alloc] init];
    phoneImg.image = [UIImage imageNamed:@"phone"];
    [carStoreinfo addSubview:phoneImg];
    [phoneImg makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.equalTo(distanceImg.bottom).offset(10);
        make.size.equalTo(CGSizeMake(20, 20));
    }];


    _distancelab = [[UILabel alloc] init];
    _distancelab.textColor = [UIColor colorWithRed:0.79 green:0.22 blue:0.31 alpha:1.00];
    _distancelab.font = [UIFont systemFontOfSize:13.f];
    _distancelab.textAlignment = NSTextAlignmentRight;
    [carStoreinfo addSubview:_distancelab];
    [_distancelab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(distanceImg.left).offset(-10);
        make.top.offset(5);
        make.size.equalTo(CGSizeMake(90, 20));
    }];

    _phonelab = [[UILabel alloc] init];
    _phonelab.textColor = [UIColor colorWithRed:0.25 green:0.56 blue:0.29 alpha:1.00];
    _phonelab.font = [UIFont systemFontOfSize:13.f];
    _phonelab.textAlignment = NSTextAlignmentRight;
    [carStoreinfo addSubview:_phonelab];
    [_phonelab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_distancelab.bottom).offset(12);
        make.right.equalTo(phoneImg.left).offset(-10);
        make.size.equalTo(CGSizeMake(90, 20));
    }];


}


- (void)fetchProject:(BOOL)refresh {


    if (!refresh)[self.hud show:YES];
    [HBNetRequest Get:CARDETAIL para:@{@"bid": _StoreCarModel.bid} complete:^(id data) {
        if (refresh) {
            [_bimageArr removeAllObjects];
            [_dataArr removeAllObjects];
        }


        NSDictionary *business = data[@"business"];
        NSArray *childs = [business objectForKey:@"childs"];


        if (childs.count > 0) {
            _baddress = [business objectForKey:@"baddress"];
             _bid = [business objectForKey:@"bid"];
            _bname = [business objectForKey:@"bname"];
            _bphone = [business objectForKey:@"bphone"];
            _majorbusiness = [NSString stringWithFormat:@"主营车型: %@", [business objectForKey:@"majorbusiness"]];
            _stages = [business objectForKey:@"stages"];


            _distancelab.text = [HBAuxiliary distance:_StoreCarModel.distance];
            _phonelab.text = _bphone;
            _baddresslab.text = _baddress;
            _bnamelab.text = _bname;
            _phonelab.text = _bphone;
            _majorbusinesslab.text = _majorbusiness;


            for (NSDictionary *dict in childs) {
                HBCarStoreDetailModel *model = [[HBCarStoreDetailModel alloc] initWithDictionary:dict error:nil];
                [_dataArr addObject:model];
            }
            NSArray *bimage = [business objectForKey:@"bimage"];

            _bimageArr = [HBAuxiliary loopaimage:bimage];
            _loopView.imageURLStringsGroup = _bimageArr;

            dispatch_async(dispatch_get_main_queue(), ^{//重载数据
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.hud hide:YES];
            });

        } else {


        }

    }            fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];//结束刷新
        [self.hud hide:YES];
        NSLog(@"%@", error);
    }];
}


//轮播图的url拼接
- (void)loopaimage:(NSArray *)imgurlArr {
    NSString *str = mainUrl;
    for (NSString *Urlstr in imgurlArr) {
        NSString *url = [str stringByAppendingFormat:@"%@", Urlstr];
        [_bimageArr addObject:url];
    }
    _loopView.imageURLStringsGroup = _bimageArr;
}

#pragma mark tableView

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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HBCarStoreDetailModel *model = _dataArr[indexPath.row];
    HBSeriesOfcarViewController *VC = [[HBSeriesOfcarViewController alloc] init];
    VC.CarStoreDetailModel = model;
    VC.StoreCarModel = _StoreCarModel;
    VC.bid = _bid;
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
