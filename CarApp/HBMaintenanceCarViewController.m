//
//  MaintenanceCarViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/22.
//  Copyright © 2016年 dragon. All rights reserved.
//
//

#import "HBMaintenanceCarViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MJRefresh.h"
#import "HBMaintenanceCarCell.h"
#import "HBMaintenanceStoreViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "XLPhotoBrowser.h"

#define MAS_SHORTHAND

#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"
#import "SDCycleScrollView.h"

@interface HBMaintenanceCarViewController () <SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


//经纬度
@property(strong, nonatomic) NSString *latitude;
@property(strong, nonatomic) NSString *longitude;

@property(strong, nonatomic) NSMutableArray *loopImgArr;
@property(strong, nonatomic) NSMutableArray *ycstore;

@property(strong, nonatomic) NSMutableArray *homeImageObjArr;

//View
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) SDCycleScrollView *loopView;


@property(strong, nonatomic) UIView *topView;
@property(strong, nonatomic) UIView *selectCar;
@property(nonatomic, strong) UIView *hangbarView;
@property(nonatomic, strong) UIView *dealaerandcarView;
@property(nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HBMaintenanceCarViewController


- (void)viewDidLoad {
    [super viewDidLoad];


    _ycstore = [NSMutableArray array];
    _loopImgArr = [NSMutableArray array];
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.navigationController.view addSubview:_hud];


    [self loadWithTopView];
    [self fetchProject:NO];
}

- (void)fetchProject:(BOOL)refresh {
    DEFAULTS
    _latitude = [defaults objectForKey:@"latitude"];
    _longitude = [defaults objectForKey:@"longitude"];
    if (!refresh)[self.hud show:YES];

    [HBNetRequest Get:MAINTENANCECARHOME para:@{
                                                @"longitude": _longitude,
                                                @"latitude": _latitude
                                                }

             complete:^(id data) {

                 if (refresh) {
                     [_ycstore removeAllObjects];
                     [_loopImgArr removeAllObjects];
                 }

                 NSLog(@"HBLog:%@", data);
                 NSArray *ycstore = data[@"ycstore"];
                 NSArray *homeImage = data[@"homeImage"];
                 for (NSDictionary *dict in ycstore) {
                     HBMiantenanceCarHomeModel *model = [[HBMiantenanceCarHomeModel alloc] initWithDictionary:dict error:nil];
                     [_ycstore addObject:model];
                 }
                 [self.tableView reloadData];
                 _loopImgArr = [HBAuxiliary loopaimage:homeImage];
                 _loopView.imageURLStringsGroup = _loopImgArr;
                 [_hud hide:YES afterDelay:0];
                 [self.tableView.mj_header endRefreshing];//结束刷新

             } fail:^(NSError *error) {
                [_hud hide:YES afterDelay:0];
                [self.tableView.mj_header endRefreshing];//结束刷新
                NSLog(@"%@", error);
            }];

}


- (void)loadWithTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenWidth * 9.f / 16.f + 80)];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    _loopView = [[SDCycleScrollView alloc] init];
    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = mainColor;
    _loopView.pageDotColor = [UIColor whiteColor];
    HBMaintenanceCarViewController *__weak weakSelf = self;//防止循环引用
    _loopView.clickItemOperationBlock = ^(NSInteger index) {
        NSArray *arr = [weakSelf.loopImgArr copy];
        [XLPhotoBrowser showPhotoBrowserWithImages:arr currentImageIndex:index];
    };
    [self.view addSubview:_topView];

    [_topView addSubview:_loopView];
    [_loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.offset(0);        //添加三个约束上左右
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f));  // 设置尺寸
    }];


    NSInteger dViewHeight = 80;
    _dealaerandcarView = [[UIView alloc] init];
    [_topView addSubview:_dealaerandcarView];
    [_dealaerandcarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopView.mas_bottom).offset(0);
        make.left.equalTo(self.topView).offset(0);
        make.right.equalTo(self.topView).offset(0);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, dViewHeight));
    }];

    NSInteger padding = 5;
    UIImageView *leftimg = [[UIImageView alloc] init];
    leftimg.backgroundColor = [UIColor colorWithRed:95 / 255.0f green:177 / 255.0f blue:192 / 255.0f alpha:1.f];
    leftimg.image = [HBAuxiliary saImageWithSingleColor:[UIColor colorWithRed:95 / 255.0f green:177 / 255.0f blue:192 / 255.0f alpha:1.f]];
    leftimg.layer.cornerRadius = 5;
    leftimg.layer.masksToBounds = YES;

    UIImageView *rightimg = [[UIImageView alloc] init];
    rightimg.image = [HBAuxiliary saImageWithSingleColor:[UIColor colorWithRed:52 / 255.0f green:124 / 255.0f blue:189 / 255.0f alpha:1.f]];
    rightimg.layer.cornerRadius = 5;
    rightimg.layer.masksToBounds = YES;

    [_dealaerandcarView addSubview:leftimg];
    [_dealaerandcarView addSubview:rightimg];

    NSInteger width = (mainScreenWidth - 3 * padding) / 2;
    NSInteger height = dViewHeight - 2 * padding;
    [leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dealaerandcarView.left).offset(padding);
        make.right.equalTo(rightimg.mas_left).offset(-padding);
        make.top.equalTo(_dealaerandcarView.top).offset(padding);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    [rightimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dealaerandcarView.right).offset(-padding);
        make.left.equalTo(leftimg.right).offset(padding);
        make.top.equalTo(_dealaerandcarView.top).offset(padding);
        make.size.equalTo(CGSizeMake(width, height));
    }];

    UIImageView *maintenanceImg = [[UIImageView alloc] init];
    maintenanceImg.image = [UIImage imageNamed:@"maintenance"];

    UILabel *maintenanceLab = [[UILabel alloc] init];
    maintenanceLab.font = [UIFont systemFontOfSize:13.f];
    maintenanceLab.textColor = [UIColor whiteColor];
    maintenanceLab.text = @"养车服务";

    [leftimg addSubview:maintenanceImg];
    [leftimg addSubview:maintenanceLab];
    [maintenanceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftimg).offset(-6);
        make.size.equalTo(CGSizeMake(45, 39));
        make.top.equalTo(leftimg.top).offset(padding);

    }];
    [maintenanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftimg);
        make.size.equalTo(CGSizeMake(60, 16));
        make.top.equalTo(maintenanceImg.bottom).offset(2);
    }];


    UIImageView *autoSuppliesImg = [[UIImageView alloc] init];
    autoSuppliesImg.image = [UIImage imageNamed:@"autoSupplies"];

    UILabel *autoSuppliesLab = [[UILabel alloc] init];
    autoSuppliesLab.font = [UIFont systemFontOfSize:13.f];
    autoSuppliesLab.textColor = [UIColor whiteColor];
    autoSuppliesLab.text = @"汽车用品";

    [rightimg addSubview:autoSuppliesLab];
    [rightimg addSubview:autoSuppliesImg];
    [autoSuppliesImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightimg).offset(-6);
        make.size.equalTo(CGSizeMake(30, 39));
        make.top.equalTo(leftimg.top).offset(padding);

    }];
    [autoSuppliesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightimg);
        make.size.equalTo(CGSizeMake(60, 16));
        make.top.equalTo(autoSuppliesImg.bottom).offset(2);
    }];
    [self loadTableView];
}


#pragma mark tableView数据

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ycstore.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBMaintenanceCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL"];
    if (_ycstore.count > 0) {
        HBMiantenanceCarHomeModel *model = _ycstore[indexPath.row];
        [cell loadmodel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_ycstore.count > 0) {
        HBMiantenanceCarHomeModel *model = _ycstore[indexPath.row];
        HBMaintenanceStoreViewController *VC = [[HBMaintenanceStoreViewController alloc] initWithStoreInfo:model];
        [self.navigationController pushViewController:VC animated:YES];
    }


}

- (void)loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 110)];
    _tableView.tableHeaderView = _topView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 110;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchProject:YES];
    }];
    [(MJRefreshAutoNormalFooter *) self.tableView.mj_footer setTitle:@"已全部加载完毕" forState:MJRefreshStateNoMoreData];

    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UINib *Nib = [UINib nibWithNibName:@"HBMaintenanceCarCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];

    [self.view addSubview:_tableView];
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
