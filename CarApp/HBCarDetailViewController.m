//
//  HBCarDetailViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/12/9.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBCarDetailViewController.h"
#import "HBOrderingCarViewController.h"
#import "HBAskLowPriceViewController.h"
#import "HBrecommendViewCell.h"
#import "HBConfigurationOfCar.h"


#import "XLPhotoBrowser.h"

#import "MBProgressHUD.h"
#import "SDCycleScrollView.h"

@interface HBCarDetailViewController () <SDCycleScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(strong, nonatomic) NSMutableArray *allKeys;
@property(strong, nonatomic) NSDictionary *configure;
@property(strong, nonatomic) NSDictionary *model;
@property(nonatomic, strong) NSMutableArray *bimageArr;
@property(nonatomic, strong) NSMutableArray *recommend;


@property(nonatomic, strong) SDCycleScrollView *loopView;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *recommendView;
@property(nonatomic, strong) UIView *scrollView;
@property(nonatomic, strong) UICollectionView *CollectionView;
@property(strong, nonatomic) UITableView *tableView;
@property(nonatomic, strong) MBProgressHUD *hud;


@property(nonatomic, strong) UILabel *namelab;
@property(nonatomic, strong) UILabel *pircelab;
@property(nonatomic, strong) UILabel *activitylab;
@property(nonatomic, strong) UILabel *gname;
@property(nonatomic, strong) UILabel *phoneLab;
@property(nonatomic, strong) UILabel *distanceLab;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *bphone;
@property(nonatomic, strong) NSString *guidegprice;
@property(nonatomic, strong) NSString *mtitle;


@end

@implementation HBCarDetailViewController

- (void)loadCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(120, 115);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 120) collectionViewLayout:layout];

    _CollectionView.dataSource = self;
    _CollectionView.delegate = self;


    UINib *nib = [UINib nibWithNibName:@"HBrecommendViewCell" bundle:nil];
    [self.CollectionView registerNib:nib forCellWithReuseIdentifier:@"NIBCELL"];
    self.CollectionView.backgroundColor = [UIColor whiteColor];
    [_recommendView addSubview:_CollectionView];
    [_CollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40);
        make.size.equalTo(CGSizeMake(mainScreenWidth, 120));
        make.right.left.offset(0);
    }];
}

- (void)loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;


    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = _scrollView;
    _tableView.estimatedRowHeight = 110;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UINib *Nib = [UINib nibWithNibName:@"HBConfigurationOfCar" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];
    [self.view addSubview:_tableView];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadTableView];
    [self loadTopView];
    [self loadCollectionView];
    [self loadWithData];
}

- (void)loadTopView {
    _bimageArr = [[NSMutableArray alloc] init];
    _recommend = [[NSMutableArray alloc] init];


    self.view.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00];

    _scrollView = [[UIView alloc] init];
    _tableView.tableHeaderView = _scrollView;
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.size.equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f + mainScreenWidth * 10.f / 30.f + 150));
    }];

    _topView = [[UIView alloc] init];
    [_scrollView addSubview:_topView];
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);

        make.size.equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f + mainScreenWidth * 9.f / 30.f + 5));
    }];


    _loopView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenWidth * 9.f / 16.f) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = mainColor;
    _loopView.pageDotColor = [UIColor whiteColor];
    HBCarDetailViewController *__weak weakSelf = self;
    _loopView.clickItemOperationBlock = ^(NSInteger index) {
        NSArray *arr = [weakSelf.bimageArr copy];
        [XLPhotoBrowser showPhotoBrowserWithImages:arr currentImageIndex:index];
    };
    [_topView addSubview:_loopView];
    [_loopView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f));
    }];


    UIView *carStoreinfo = [[UIView alloc] initWithFrame:CGRectMake(0, _loopView.frame.origin.y + _loopView.frame.size.height - _loopView.frame.size.height * 2 / 5.f, mainScreenWidth, _loopView.frame.size.height * 2 / 5.f)];
    carStoreinfo.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:0.65];
    [_loopView addSubview:carStoreinfo];
    [carStoreinfo makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, _loopView.frame.size.height * 2 / 5.f));
        make.bottom.left.right.offset(0);
    }];

    _namelab = [[UILabel alloc] init];
    _namelab.textColor = [UIColor whiteColor];
    [carStoreinfo addSubview:_namelab];
    [_namelab makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(300, 20));
        make.top.left.offset(5);
    }];

    _pircelab = [[UILabel alloc] init];
    _pircelab.textColor = [UIColor whiteColor];
    _pircelab.font = [UIFont systemFontOfSize:13.f];
    [carStoreinfo addSubview:_pircelab];
    [_pircelab makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(300, 20));
        make.top.equalTo(_namelab.bottom).offset(5);
        make.left.offset(5);
    }];


    _activitylab = [[UILabel alloc] init];
    _activitylab.font = [UIFont systemFontOfSize:13.f];
    _activitylab.textColor = [UIColor whiteColor];
    [carStoreinfo addSubview:_activitylab];
    [_activitylab makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(300, 20));
        make.top.equalTo(_pircelab.bottom).offset(5);
        make.left.offset(5);
    }];


    NSUInteger padding = mainScreenWidth / 30.f;
    NSUInteger width = mainScreenWidth * 9.f / 30.f;


    UIImageView *asklowPriceBG = [[UIImageView alloc] init];
    [asklowPriceBG setBackgroundColor:[UIColor colorWithRed:0.94 green:0.77 blue:0.26 alpha:1.00]];
    [_topView addSubview:asklowPriceBG];

    UIImageView *onlineOrdingCarBG = [[UIImageView alloc] init];
    [onlineOrdingCarBG setBackgroundColor:[UIColor colorWithRed:0.37 green:0.69 blue:0.75 alpha:1.00]];
    [_topView addSubview:onlineOrdingCarBG];


    [asklowPriceBG makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(width, width));
        make.left.offset(padding);
        make.top.equalTo(_loopView.bottom).offset(padding);
    }];

    [onlineOrdingCarBG makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(width * 2, width));
        make.left.equalTo(asklowPriceBG.right).offset(padding);
        make.top.equalTo(_loopView.bottom).offset(padding);
    }];


    UIImageView *asklowPrice = [[UIImageView alloc] init];
    [asklowPrice setImage:[UIImage imageNamed:@"asklowpriceimg"]];
    [asklowPriceBG setUserInteractionEnabled:YES];
    [asklowPriceBG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAsklowPrice:)]];
    [asklowPriceBG addSubview:asklowPrice];
    [asklowPrice makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
        make.size.equalTo(CGSizeMake(50, 12));
    }];

    UIImageView *onlineOrdingCar = [[UIImageView alloc] initWithFrame:CGRectMake((mainScreenWidth * 18.f / 30.f - 100) / 2, (mainScreenWidth * 9.f / 30.f - 24) / 2, 100, 24)];
    [onlineOrdingCar setImage:[UIImage imageNamed:@"99yuanorder"]];
    [onlineOrdingCarBG setUserInteractionEnabled:YES];
    [onlineOrdingCarBG addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickonlineOrdingCar)]];
    [onlineOrdingCarBG addSubview:onlineOrdingCar];
    [onlineOrdingCar makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
        make.size.equalTo(CGSizeMake(100, 24));
    }];


    _recommendView = [[UIView alloc] init];
    [_scrollView addSubview:_recommendView];
    [_recommendView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, 200));
        make.top.equalTo(_topView.mas_bottom).offset(3);
        make.left.right.offset(0);
    }];

    UILabel *recommendCar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 40)];
    [recommendCar setBackgroundColor:[UIColor whiteColor]];
    recommendCar.text = @"  车型推荐";
    [recommendCar setTextColor:[UIColor colorWithRed:0.31 green:0.30 blue:0.29 alpha:1.00]];
    [_recommendView addSubview:recommendCar];
    [recommendCar makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(mainScreenWidth, 40));
        make.top.left.right.offset(0);
    }];
}


- (void)clickonlineOrdingCar {
    HBOrderingCarViewController *VC = [[HBOrderingCarViewController alloc] init];
    VC.SeriesOfcarModel = _SeriesOfcarModel;
    VC.CarStoreDetailModel = _CarStoreDetailModel;
    VC.StoreCarModel = _StoreCarModel;
    
    [self.navigationController pushViewController:VC animated:YES];

}


- (void)clickAsklowPrice:(id)s {
    HBAskLowPriceViewController *VC = [[HBAskLowPriceViewController alloc] init];
    VC.SeriesOfcarModel = _SeriesOfcarModel;
    VC.CarStoreDetailModel = _CarStoreDetailModel;
    VC.StoreCarModel = _StoreCarModel;
    VC.bid = _bid;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)loadWithData {
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.navigationController.view addSubview:_hud];
    [_hud show:YES];
    [HBNetRequest Get:SOMECAR para:@{@"mid":_SeriesOfcarModel.mid}
             complete:^(id data) {
        NSDictionary *car = data[@"car"];
        _configure = [car objectForKey:@"configure"];
        _allKeys = [_configure allKeys].copy;
        [self sortForKey];


        _name = [NSString stringWithFormat:@"%@", [car objectForKey:@"mname"]];
        _guidegprice = [[HBAuxiliary makeprice:[car objectForKey:@"guidegprice"]] stringByAppendingString:@"万"];
        _mtitle = [car objectForKey:@"mtitle"];
        _bid = [car objectForKey:@"bid"];

        _namelab.text = _name;
        _activitylab.text = _mtitle;
        _pircelab.text = [NSString stringWithFormat:@"%@万", _guidegprice];


        NSArray *recommend = [data objectForKey:@"recommend"];
        for (NSDictionary *dict in recommend) {
            HBRecommendModel *model = [[HBRecommendModel alloc] initWithDictionary:dict error:nil];
            [_recommend addObject:model];
        }
        //重载数据
        [_CollectionView reloadData];
        [_tableView reloadData];

        NSArray *mimage = car[@"mimage"];
        _loopView.imageURLStringsGroup = [HBAuxiliary loopaimage:mimage];
        [_hud hide:YES];
    }            fail:^(NSError *error) {
        [_hud hide:YES];
        NSLog(@"HBLog:%@", error);

    }];
}


- (void)sortForKey {
    if (!_allKeys) return;

    for (unsigned int i = 0; i < _allKeys.count; i++) {
        NSString *temp = _allKeys[i];
        if ([temp isEqualToString:@"基本参数"]) {
            // NSString *firstTemp = _allKeys[0];
            //[_allKeys exchangeObjectAtIndex:0 withObjectAtIndex:i];
        }
    }

}


#pragma mark tableView数据

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *itemStr = _allKeys[section];
    NSDictionary *dic = [_configure objectForKey:itemStr];
    return dic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBConfigurationOfCar *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL"];
    NSString *key = _allKeys[indexPath.section];
    NSDictionary *dic = [_configure objectForKey:key];

    NSArray *itemArr = dic.allKeys;
    NSString *item = itemArr[indexPath.row];

    NSString *info = [dic objectForKey:item];
    [cell item:item info:info];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeys.count;

}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _allKeys[section];
}


#pragma mark collectionView的操作------------

//section的数目
//每个section中cell的数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recommend.count;
}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBrecommendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NIBCELL" forIndexPath:indexPath];
    if (_recommend.count > 0) {
        HBRecommendModel *model = _recommend[indexPath.row];
        [cell loadmodel:model];

    }
    return cell;
}

//选中item后
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HBRecommendModel *model = _recommend[indexPath.row];
    HBCarDetailViewController *VC = [[HBCarDetailViewController alloc] init];
    VC.SeriesOfcarModel = _SeriesOfcarModel;
    VC.CarStoreDetailModel = _CarStoreDetailModel;
    VC.StoreCarModel = _StoreCarModel;

    [self.navigationController pushViewController:VC animated:YES];
}


@end
