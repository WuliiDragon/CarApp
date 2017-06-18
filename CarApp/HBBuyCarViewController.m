//
//  HBBuyCarViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/30.
//  Copyright © 2016年 dragon. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>


#import "HBBuyCarViewController.h"
#import "HBSearchConditionCarViewController.h"
#import "HBCarStoreDetailViewController.h"
#import "HBCarStoreCell.h"
#import "HBSearchResultViewController.h"

#import "homeActive.h"
#import "homeImage.h"


#import "MJRefresh.h"
#import "XLPhotoBrowser.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MBProgressHUD.h"
#import "SDCycleScrollView.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"


@interface HBBuyCarViewController () <SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CLLocationManagerDelegate>

//经纬度
@property(nonatomic, strong) CLLocationManager *locationManager;

@property(strong, nonatomic) NSString *latitude;
@property(strong, nonatomic) NSString *longitude;

@property(strong, nonatomic) NSMutableArray *loopImgArr;
@property(strong, nonatomic) NSMutableArray *CarStoreArr;
@property(strong, nonatomic) NSMutableArray *loopTitleArr;
@property(nonatomic, strong) NSMutableArray *homeActiveObjs;
@property(strong, nonatomic) NSMutableArray *homeImageObjArr;

//View
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) SDCycleScrollView *loopView;
@property(strong, nonatomic) SDCycleScrollView *hangbartopTitle;
@property(strong, nonatomic) UIView *topView;
@property(strong, nonatomic) UIView *selectCar;
@property(nonatomic, strong) UIView *hangbarView;
@property(nonatomic, strong) UIView *dealaerandcarView;

@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, assign) NSString *isFirst;

@end

@implementation HBBuyCarViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    _hud = [[MBProgressHUD alloc] init];
    [self.navigationController.view addSubview:_hud];
    //初始化位置信息
    _hud.labelText = @"正在加载位置";
    [_hud show:YES];
    [self startLocation];//获取经纬度
    [self fetchProject:NO];
    // 默认bg是透明的
    self.view.backgroundColor = [UIColor whiteColor];

    [self initArr];
    [self loadTableView];
    [self loadWithView];

}

#pragma mark 加载view

- (void)loadTableView {
    //指定大小
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    //指定headerView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    _tableView.tableFooterView = [UIView new];
    //预估行高estimatedRowHeight,达到cell高度的自适应
    _tableView.estimatedRowHeight = 110;
    _tableView.rowHeight = UITableViewAutomaticDimension;


    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchProject:YES];
    }];
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //[self fetchProject:NO];
    }];
    [(MJRefreshAutoNormalFooter *) self.tableView.mj_footer setTitle:@"已全部加载完毕" forState:MJRefreshStateNoMoreData];
    // 默认先隐藏footer
    self.tableView.mj_footer.hidden = YES;


    //注册nib以及重用资源符
    UINib *Nib = [UINib nibWithNibName:@"HBCarStoreCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];

    [self.view addSubview:_tableView];

}

- (void)loadWithView {
    //初始化头视图
    _topView = [[UIView alloc] init];
    _tableView.tableHeaderView = _topView;
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.size.equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f + 70 + 57));
    }];

    _loopView = [[SDCycleScrollView alloc] init];
    [_topView addSubview:_loopView];
    [_loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.top).offset(0);
        make.left.equalTo(_topView.left).offset(0);
        make.right.equalTo(_topView.right).offset(0);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f));  // 设置尺寸
    }];
    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = mainColor;
    _loopView.pageDotColor = [UIColor whiteColor];

    HBBuyCarViewController *__weak weakSelf = self;//防止循环引用
    _loopView.clickItemOperationBlock = ^(NSInteger index) {
        NSArray *arr = [weakSelf.loopImgArr copy];
        [XLPhotoBrowser showPhotoBrowserWithImages:arr currentImageIndex:index];
    };
    //_loopView.imageURLStringsGroup = _loopImgArr;


    [self loadDelaerAndCarView];//经销商和车型

    _hangbarView = [[UIView alloc] init];
    [_topView addSubview:_hangbarView];

    [_hangbarView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, 26));
        make.top.equalTo(_dealaerandcarView.bottom).offset(0);
    }];

    UIImageView *hangbartop = [[UIImageView alloc] init];
    hangbartop.image = [UIImage imageNamed:@"hangbatop"];
    [_hangbarView addSubview:hangbartop];
    [hangbartop makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(30, 20));
        make.centerY.equalTo(_hangbarView).offset(0);
        make.left.offset(18);
    }];

    _hangbartopTitle = [[SDCycleScrollView alloc] init];
    _hangbartopTitle.delegate = self;
    _hangbartopTitle.scrollDirection = UICollectionViewScrollDirectionVertical;
    _hangbartopTitle.onlyDisplayText = YES;
    _hangbartopTitle.titleLabelBackgroundColor = [UIColor whiteColor];
    _hangbartopTitle.titleLabelTextColor = [UIColor blackColor];
    _hangbartopTitle.titlesGroup = _loopTitleArr;
    [_hangbarView addSubview:_hangbartopTitle];
    [_hangbartopTitle makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(800, 20));
        make.centerY.equalTo(_hangbarView).offset(0);
        make.left.equalTo(hangbartop.right).offset(5);
    }];

    _selectCar = [[UIView alloc] init];
    [_topView addSubview:_selectCar];
    [_selectCar makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, 30));
        make.top.equalTo(_hangbarView.bottom).offset(0);
    }];

    //添加按钮
    UIButton *selectCarBtu = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth - 40, 0, 35, 22)];
    [selectCarBtu setImage:[UIImage imageNamed:@"selectCar"] forState:UIControlStateNormal];
    [selectCarBtu addTarget:self action:@selector(clickselectCarbtu:) forControlEvents:UIControlEventTouchUpInside];
    [_selectCar addSubview:selectCarBtu];
    [selectCarBtu makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(35, 22));
        make.right.offset(-20);
        make.centerY.equalTo(_selectCar).offset(0);
    }];
    //图片
    UIImageView *selectCarImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth - selectCarBtu.frame.size.width - 20, selectCarBtu.frame.size.height / 3.f, 12, 6)];
    selectCarImg2.image = [UIImage imageNamed:@"selectCar1"];
    [_selectCar addSubview:selectCarImg2];
    [selectCarImg2 makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(12, 6));
        make.right.equalTo(selectCarBtu.left).offset(-8);
        make.centerY.equalTo(_selectCar).offset(0);
    }];

}

- (void)initArr {
    _loopImgArr = [[NSMutableArray alloc] init];
    _loopTitleArr = [[NSMutableArray alloc] init];
    _CarStoreArr = [[NSMutableArray alloc] init];
    _homeImageObjArr = [[NSMutableArray alloc] init];
    _homeActiveObjs = [[NSMutableArray alloc] init];
}

//经销商和车型
- (void)loadDelaerAndCarView {
    _dealaerandcarView = [[UIView alloc] init];
    [_topView addSubview:_dealaerandcarView];
    NSUInteger padding = 5;
    [_dealaerandcarView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, 70));
        make.top.equalTo(_loopView.bottom).offset(padding);
    }];


    UIImageView *leftimg = [[UIImageView alloc] init];
    leftimg.image = [HBAuxiliary saImageWithSingleColor:[UIColor colorWithRed:95 / 255.0f green:177 / 255.0f blue:192 / 255.0f alpha:1.f]];
    leftimg.layer.cornerRadius = 5;
    leftimg.layer.masksToBounds = YES;
    [_dealaerandcarView addSubview:leftimg];
    [leftimg makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake((mainScreenWidth - 3 * padding) / 2, 70));
        make.top.equalTo(_dealaerandcarView.top).offset(0);
        make.left.equalTo(_dealaerandcarView.left).offset(padding);
    }];
    UIImageView *dealer = [[UIImageView alloc] init];
    dealer.image = [UIImage imageNamed:@"carBussnis"];
    [leftimg addSubview:dealer];
    [dealer makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftimg).offset(0);
        make.size.equalTo(CGSizeMake(90, 30));
        make.top.offset(10);
    }];
    UILabel *dealerlab = [[UILabel alloc] init];
    dealerlab.font = [UIFont systemFontOfSize:13.f];
    dealerlab.textColor = [UIColor whiteColor];
    dealerlab.text = @"经销商";
    dealerlab.textAlignment = NSTextAlignmentCenter;
    [leftimg addSubview:dealerlab];
    [dealerlab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftimg).offset(0);
        make.size.equalTo(CGSizeMake(60, 16));
        make.top.equalTo(dealer.bottom).offset(2);
    }];


    UIImageView *rightimg = [[UIImageView alloc] init];
    rightimg.image = [HBAuxiliary saImageWithSingleColor:[UIColor colorWithRed:52 / 255.0f green:124 / 255.0f blue:189 / 255.0f alpha:1.f]];
    rightimg.layer.cornerRadius = 5;
    rightimg.layer.masksToBounds = YES;
    [_dealaerandcarView addSubview:rightimg];

    [rightimg makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake((mainScreenWidth - 3 * padding) / 2, 70));
        make.top.equalTo(_dealaerandcarView.top).offset(0);
        make.left.equalTo(leftimg.right).offset(padding);
    }];
    UIImageView *car = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car"]];
    [rightimg addSubview:car];

    [car makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightimg).offset(+5);
        make.size.equalTo(CGSizeMake(90, 30));
        make.top.offset(10);
    }];
    UILabel *carlab = [[UILabel alloc] init];
    carlab.font = [UIFont systemFontOfSize:13.f];
    carlab.textColor = [UIColor whiteColor];
    carlab.text = @"车型";
    carlab.textAlignment = NSTextAlignmentCenter;
    [rightimg addSubview:carlab];
    [carlab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightimg).offset(0);
        make.size.equalTo(CGSizeMake(60, 16));
        make.top.equalTo(car.bottom).offset(2);
    }];


    //图片添加点击事件
    //开启手势
    [rightimg setUserInteractionEnabled:YES];
    [rightimg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory)]];
}

#pragma mark 点击事件

- (void)clickCategory {
    HBSearchResultViewController *VC = [[HBSearchResultViewController alloc] init];
    VC.itemDic = nil;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)clickselectCarbtu:(id)sender {
    HBSearchConditionCarViewController *s = [[HBSearchConditionCarViewController alloc] init];
    [self.navigationController pushViewController:s animated:YES];

}


#pragma mark  加载数据

- (void)fetchProject:(BOOL)refresh {
    _hud.labelText = @"正在加载...";
    DEFAULTS
    _latitude = [defaults objectForKey:@"latitude"];
    _longitude = [defaults objectForKey:@"longitude"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setValue:_longitude forKey:@"longitude"];
    [parameter setValue:_latitude forKey:@"latitude"];
    if (!refresh) {
        [self.hud show:YES];
    }

    [HBNetRequest Get:HOMEPAGE para:parameter complete:^(id data) {
        if (refresh) {
            [_CarStoreArr removeAllObjects];
            [_loopImgArr removeAllObjects];
            [_loopTitleArr removeAllObjects];
            [_homeImageObjArr removeAllObjects];
            [_homeActiveObjs removeAllObjects];
        }


        NSArray *carstore = data[@"carstore"];
        //解析Json给数据模型
        for (NSDictionary *dict in carstore) {
            HBStoreCarModel *model = [[HBStoreCarModel alloc] initWithDictionary:dict error:nil];
            [_CarStoreArr addObject:model];
        }
        NSArray *homeImage = data[@"homeImage"];
        NSArray *homeActive = data[@"homeActive"];


        //tableView数据重载
        dispatch_async(dispatch_get_main_queue(), ^{//重载数据
            //解析图片地址
            [_loopImgArr removeAllObjects];
            [_loopTitleArr removeAllObjects];
            [self loopaimage:homeImage];
            [self loopTitle:homeActive];
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


#pragma mark 两个轮播图的view以及数据加载

- (void)loopaimage:(NSArray *)imgurlArr {
    NSString *str = mainUrl;
    for (NSDictionary *dic in imgurlArr) {
        homeImage *homeImageObj = [[homeImage alloc] init];
        homeImageObj.url = [dic objectForKey:@"url"];
        homeImageObj.imgurl = [dic objectForKey:@"image"];
        //拼接url
        NSString *url = [str stringByAppendingFormat:@"%@", homeImageObj.imgurl];
        [_loopImgArr addObject:url];
        //存下对象数组
        [_homeImageObjArr addObject:homeImageObj];
    }
    //设置给轮播图
    _loopView.imageURLStringsGroup = _loopImgArr;
}

- (void)loopTitle:(NSArray *)arr {
    for (NSDictionary *dic in arr) {
        homeActive *homeActivityObj = [[homeActive alloc] init];
        homeActivityObj.title = [dic objectForKey:@"title"];
        homeActivityObj.url = [dic objectForKey:@"url"];
        [_loopTitleArr addObject:homeActivityObj.title];
        [_homeActiveObjs addObject:homeActivityObj];
    }
    _hangbartopTitle.titlesGroup = _loopTitleArr;
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
    VC.bid = model.bid;
    VC.distance = model.distance;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {

    }
    if ([error code] == kCLErrorLocationUnknown) {

    }
}

//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    DEFAULTS
    [defaults setDouble:newLocation.coordinate.latitude forKey:@"latitude"];
    [defaults setDouble:newLocation.coordinate.longitude forKey:@"longitude"];
    [defaults synchronize];
    [manager stopUpdatingLocation];


    [_hud hide:YES];
    [self fetchProject:NO];

}


#pragma mark 空白页设置

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text;
    text = @"暂无数据";
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
    return 100;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 0;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:243.0 / 255 alpha:1.0];
}

@end
