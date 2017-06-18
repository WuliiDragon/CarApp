//
//  HBMaintenanceStore.m
//  CarApp
//
//  Created by 管理员 on 2017/3/17.
//  Copyright © 2017年 dragon. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

#import "HBMaintenanceStoreViewController.h"
#import "HBAuxiliary.h"
#import "SDCycleScrollView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MJRefresh.h"
#import "XLPhotoBrowser.h"

#import "HBCleanCell.h"
#import "HBNetRequest.h"
#import "HBMainPayViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ShopCarBar.h"
#import "HBPushShopCarView.h"
//#import "HBShoppingCartView.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "HBLoginViewController.h"

@interface HBMaintenanceStoreViewController () <UIScrollViewDelegate, SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, HBCellAnimationDelegate>
//控制器
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIScrollView *bgScroll;//三个tableview 的容器

//三个服务tableView
@property(nonatomic, strong) UITableView *tableViewClean;
@property(nonatomic, strong) UITableView *tableViewMaintenance;
@property(nonatomic, strong) UITableView *tableViewCleanDecoration;
//轮播图的容器
@property(strong, nonatomic) UIView *topView;
@property(nonatomic, strong) NSString *mbid;//该店的id
@property(nonatomic, strong) HBMiantenanceCarHomeModel *miantenanceModel;//该店的信息数据模型
//三个服务的数据源
@property(nonatomic, strong) NSMutableArray *decorationArr;
@property(nonatomic, strong) NSMutableArray *maincleanArr;
@property(nonatomic, strong) NSMutableArray *cleanArr;

//该店的信息
@property(nonatomic, strong) UILabel *timelab;//营业时间
@property(nonatomic, strong) UILabel *mbnamelab;//名称
@property(nonatomic, strong) UILabel *baddresslab;//地址
@property(nonatomic, strong) UILabel *distancelab;//距离
@property(nonatomic, strong) UILabel *bphonelab;//手机
//轮播图
@property(strong, nonatomic) SDCycleScrollView *loopView;
@property(strong, nonatomic) NSMutableArray *loopImgArr;//轮播图数据源
//提示
@property(strong, nonatomic) MBProgressHUD *hud;
//选中的服务订单
@property(nonatomic, strong) NSMutableArray *selectGoods;
//总数量 一件服务 * 服务个数
@property(nonatomic, assign) NSInteger counts;
//总价格
@property(nonatomic, assign) float price;
//价格和总数量lable
@property(strong, nonatomic) IBOutlet UILabel *priceLab;
@property(strong, nonatomic) IBOutlet UILabel *countLab;
@property(strong, nonatomic) IBOutlet ShopCarBar *ShopCarView;//底部购物车样式
@property(strong, nonatomic) UIView *ShopCarbar;

//包含向上弹出的购物车所有视图
@property(nonatomic, strong) HBPushShopCarView *payMethodView;

//
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIScrollView *contentView;
//@property (nonatomic,strong) HBShoppingCartView *shoppcartview;
@property(strong, nonatomic) UIView *bottomBtu;

@end

@implementation HBMaintenanceStoreViewController
- (instancetype)initWithStoreInfo:(HBMiantenanceCarHomeModel *)model {
    self = [super init];
    _miantenanceModel = model;
    _mbid = _miantenanceModel.mbid;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00];

    [self loadWithTopView];


    _counts = 0;
    _price = 0;
    _selectGoods = [[NSMutableArray alloc] init];
    _loopImgArr = [[NSMutableArray alloc] init];
    [self creatContent];
    [self createBottomLayer];
    [self loadWithData];

    _payMethodView = [[HBPushShopCarView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _payMethodView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    _payMethodView.bgView.backgroundColor = [UIColor clearColor];
    _payMethodView.frame = [UIScreen mainScreen].bounds;


    //订阅两个消息收到消息执行两个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClearAll:) name:@"ClearAll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData:) name:@"changeData" object:nil];

}

//加载view
- (void)loadWithTopView {
    _topView = [[UIView alloc] init];
    [self.view addSubview:_topView];
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f));
    }];

    _loopView = [[SDCycleScrollView alloc] init];
    _loopView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _loopView.currentPageDotColor = mainColor;
    _loopView.pageDotColor = [UIColor whiteColor];
    HBMaintenanceStoreViewController *__weak weakSelf = self;//防止循环引用
    _loopView.clickItemOperationBlock = ^(NSInteger index) {
        NSArray *arr = [weakSelf.loopImgArr copy];
        [XLPhotoBrowser showPhotoBrowserWithImages:arr currentImageIndex:index];
    };
    [_topView addSubview:_loopView];
    [_loopView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.offset(0);        //添加三个约束上左右
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, mainScreenWidth * 9.f / 16.f));  // 设置尺寸
    }];

    UIView *storeInfo = [[UIView alloc] init];
    storeInfo.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:0.65];
    [_loopView addSubview:storeInfo];
    [storeInfo makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, 80));
    }];
    _mbnamelab = [[UILabel alloc] init];
    _mbnamelab.textColor = [UIColor whiteColor];
    _mbnamelab.font = [UIFont systemFontOfSize:17.f];
    _mbnamelab.text = @"某某轮胎经营店某某轮胎经营店";

    _timelab = [[UILabel alloc] init];
    _timelab.textColor = [UIColor whiteColor];
    _timelab.font = [UIFont systemFontOfSize:13];
    _timelab.text = @"营业时间：12:00-19:00";

    _baddresslab = [[UILabel alloc] init];
    _baddresslab.textColor = [UIColor whiteColor];
    _baddresslab.font = [UIFont systemFontOfSize:13.f];
    _baddresslab.text = @"西安市碑林区和平门115号1楼";
    _baddresslab.textAlignment = NSTextAlignmentRight;


    _distancelab = [[UILabel alloc] init];
    _distancelab.textColor = [UIColor colorWithRed:0.81 green:0.15 blue:0.29 alpha:1.00];
    _distancelab.font = [UIFont systemFontOfSize:13.f];
    _distancelab.text = [HBAuxiliary distance:_miantenanceModel.distance];;
    _distancelab.textAlignment = NSTextAlignmentRight;

    UIImageView *distanceImg = [[UIImageView alloc] init];
    distanceImg.image = [UIImage imageNamed:@"distance"];

    UIImageView *phoneImg = [[UIImageView alloc] init];
    phoneImg.image = [UIImage imageNamed:@"phone"];
    [storeInfo addSubview:distanceImg];
    [storeInfo addSubview:phoneImg];
    [storeInfo addSubview:_timelab];
    [storeInfo addSubview:_mbnamelab];
    [storeInfo addSubview:_baddresslab];
    [storeInfo addSubview:_distancelab];

    [_mbnamelab makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(9);
        make.size.mas_equalTo(CGSizeMake(300, 15));
        //make.height.offset(15);
        make.right.equalTo(_distancelab.left).offset(-3);
    }];

    [_timelab makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_baddresslab.bottom).offset(3);
        make.left.offset(8);
        make.size.equalTo(CGSizeMake(mainScreenWidth, 16));
    }];

    [distanceImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [phoneImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(distanceImg.bottom).offset(5);
        make.right.offset(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    [_distancelab makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(distanceImg.left).offset(-5);
        make.left.mas_equalTo(_mbnamelab.right).offset(5);
        make.top.offset(8);
        make.size.equalTo(CGSizeMake(100, 16));
    }];

    [_baddresslab makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(phoneImg.left).offset(-5);
        make.top.equalTo(_distancelab.bottom).offset(8);
        make.size.equalTo(CGSizeMake(mainScreenWidth / 2, 16));
    }];


}


#pragma mark - segmentedControl相关

- (void)creatContent {
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"清洗", @"保养", @"装潢", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:16], NSFontAttributeName, nil];

    [self.segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica" size:16], NSFontAttributeName, nil];
    [self.segmentedControl setTitleTextAttributes:dic1 forState:UIControlStateSelected];


    [self.segmentedControl setTintColor:mainColor];

    self.segmentedControl.selectedSegmentIndex = 0;

    [self.segmentedControl addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    [_segmentedControl makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(4);
        make.right.offset(-4);
        make.top.equalTo(_topView.bottom).offset(3);
        make.size.equalTo(CGSizeMake(mainScreenWidth - 8, 40));
    }];
}

- (void)segmentedClick:(UISegmentedControl *)sender {

    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0: {
            self.bgScroll.contentOffset = CGPointMake(0, 0);
        }
            break;
        case 1: {
            self.bgScroll.contentOffset = CGPointMake(mainScreenWidth, 0);
        }
            break;
        case 2: {
            self.bgScroll.contentOffset = CGPointMake(mainScreenWidth * 2, 0);
        }
            break;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _bgScroll) {
        [UIView animateWithDuration:1 animations:^{
            self.segmentedControl.selectedSegmentIndex = (scrollView.contentOffset.x + (mainScreenWidth - 20) * 0.5) / (mainScreenWidth - 20);
        }];
    }

    //    if(scrollView == _tableViewClean){
    //       // [UIView animateWithDuration:1 animations:^{
    //
    //            CGPoint position = [_tableViewClean contentOffset];
    //
    //            [_bgScroll setContentOffset:position animated:YES];
    //
    //       // }];
    //    }
}


#pragma mark - Tableview相关

- (void)createBottomLayer {
    self.bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, mainScreenWidth, mainScreenHeight)];
    self.bgScroll.pagingEnabled = YES;
    [_bgScroll setShowsHorizontalScrollIndicator:NO];
    self.bgScroll.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.86 alpha:1.00];
    self.bgScroll.delegate = self;
    self.bgScroll.bounces = NO;
    self.bgScroll.contentSize = CGSizeMake(mainScreenWidth * 3, 0);
    [self.view addSubview:self.bgScroll];

    //三个指示器
    UIImageView *instructions = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth / 5 - 10, 2, 20, 13)];
    instructions.image = [UIImage imageNamed:@"instructions"];
    [self.bgScroll addSubview:instructions];

    UIImageView *instructions2 = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth + mainScreenWidth / 2 - 10, 2, 20, 13)];
    instructions2.image = [UIImage imageNamed:@"instructions"];
    [self.bgScroll addSubview:instructions2];

    UIImageView *instructions3 = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth * 2 + mainScreenWidth * 4 / 5, 2, 20, 13)];
    instructions3.image = [UIImage imageNamed:@"instructions"];
    [self.bgScroll addSubview:instructions3];

    [_bgScroll makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_segmentedControl.bottom).offset(2);
        make.bottom.offset(0);
        make.right.left.offset(0);
    }];


    _ShopCarbar = [[[NSBundle mainBundle] loadNibNamed:@"ShopCarBar" owner:self options:nil] lastObject];
    [self.view addSubview:_ShopCarbar];
    [_ShopCarbar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.right.left.offset(0);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, 50));
    }];
    [_ShopCarView addTargets:self actions:@selector(showShopCar:)];
    [_ShopCarView setHidden:YES];


    [self loadTableViewClean];
    [self loadTableViewMaintenance];
    [self load_ableViewCleanDecoration];


}

#pragma mark 加载view

- (void)loadTableViewClean {
    _tableViewClean = [[UITableView alloc] initWithFrame:CGRectMake(mainScreenWidth * 5 / 100.f, 15, mainScreenWidth - mainScreenWidth * 10 / 100.f, mainScreenHeight - mainScreenWidth * 9.f / 16.f - 125)];
    _tableViewClean.delegate = self;
    _tableViewClean.dataSource = self;
    _tableViewClean.emptyDataSetSource = self;
    _tableViewClean.emptyDataSetDelegate = self;
    _tableViewClean.tableFooterView = [UIView new];
    _tableViewClean.estimatedRowHeight = 110;
    _tableViewClean.rowHeight = UITableViewAutomaticDimension;
    _tableViewClean.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [_tableViewClean registerNib:[UINib nibWithNibName:@"HBCleanCell" bundle:nil] forCellReuseIdentifier:@"HBCleanCell"];
    [_bgScroll addSubview:_tableViewClean];
}

- (void)loadTableViewMaintenance {
    _tableViewMaintenance = [[UITableView alloc] initWithFrame:CGRectMake(mainScreenWidth + mainScreenWidth * 5 / 100.f, 15, mainScreenWidth - mainScreenWidth * 10 / 100.f, mainScreenHeight - mainScreenWidth * 9.f / 16.f - 125)];
    _tableViewMaintenance.delegate = self;
    _tableViewMaintenance.dataSource = self;
    _tableViewMaintenance.emptyDataSetSource = self;
    _tableViewMaintenance.emptyDataSetDelegate = self;
    _tableViewMaintenance.tableFooterView = [UIView new];
    _tableViewMaintenance.estimatedRowHeight = 110;
    _tableViewMaintenance.rowHeight = UITableViewAutomaticDimension;

    [_tableViewMaintenance registerNib:[UINib nibWithNibName:@"HBCleanCell" bundle:nil] forCellReuseIdentifier:@"HBCleanCell"];
    [_bgScroll addSubview:_tableViewMaintenance];


    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_tableViewMaintenance.x + _tableViewMaintenance.frame.size.height - 50, _tableViewMaintenance.y + _tableViewMaintenance.frame.size.height - 100, 50, 50)];
    [button setBackgroundColor:[UIColor colorWithHue:0.95 saturation:0.98 brightness:0.75 alpha:1.00]];
    [button setTitle:@"面付" forState:UIControlStateNormal];
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(5, 5);
    button.layer.shadowRadius = 5;
    button.layer.shadowOpacity = 0.5;
    [button.layer setCornerRadius:25];
    //切割超出圆角范围的子视图
    button.layer.masksToBounds = YES;
    [_bgScroll addSubview:button];

//    [button makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(_ShopCarbar.top).offset(2);
//        make.right.offset(2);
//    }];


}

- (void)load_ableViewCleanDecoration {
    _tableViewCleanDecoration = [[UITableView alloc] initWithFrame:CGRectMake(mainScreenWidth * 2 + mainScreenWidth * 5 / 100.f, 15, mainScreenWidth - mainScreenWidth * 10 / 100.f, mainScreenHeight - mainScreenWidth * 9.f / 16.f - 125)];
    _tableViewCleanDecoration.delegate = self;
    _tableViewCleanDecoration.dataSource = self;
    _tableViewCleanDecoration.emptyDataSetSource = self;
    _tableViewCleanDecoration.emptyDataSetDelegate = self;
    _tableViewCleanDecoration.tableFooterView = [UIView new];
    _tableViewCleanDecoration.estimatedRowHeight = 110;
    _tableViewCleanDecoration.rowHeight = UITableViewAutomaticDimension;
    _tableViewCleanDecoration.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableViewCleanDecoration registerNib:[UINib nibWithNibName:@"HBCleanCell" bundle:nil] forCellReuseIdentifier:@"HBCleanCell"];
    [_bgScroll addSubview:_tableViewCleanDecoration];


    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_tableViewCleanDecoration.x + _tableViewCleanDecoration.frame.size.height - 50, _tableViewCleanDecoration.y + _tableViewCleanDecoration.frame.size.height - 100, 50, 50)];
    [button setBackgroundColor:[UIColor colorWithHue:0.95 saturation:0.98 brightness:0.75 alpha:1.00]];
    [button setTitle:@"面付" forState:UIControlStateNormal];
    [button.layer setCornerRadius:25];
    button.layer.masksToBounds = YES;
    [_bgScroll addSubview:button];
//    [button makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(_ShopCarbar.top).offset(2);
//        make.right.offset(2);
//    }];



}


#pragma mark - 数据加载相关

- (void)loadWithData {
    _hud = [[MBProgressHUD alloc] init];
    [_hud setLabelText:@"正在加载..."];
    [self.navigationController.view addSubview:_hud];

    [_hud show:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@?mbid=%@", MAINTENANCECARSTORE, _mbid];
    [HBNetRequest Get:urlStr para:nil complete:^(id data) {
        NSDictionary *ycstore = data[@"ycstore"];
        NSDictionary *decoration = ycstore[@"decoration"];
        NSDictionary *mainclean = ycstore[@"mainclean"];
        NSDictionary *clean = ycstore[@"clean"];

        _mbnamelab.text = ycstore[@"mbname"];
        _bphonelab.text = ycstore[@"bphone"];
        _baddresslab.text = ycstore[@"baddress"];
        _timelab.text = [NSString stringWithFormat:@"营业时间 %@", ycstore[@"time"]];


        _decorationArr = [[NSMutableArray alloc] init];
        _maincleanArr = [[NSMutableArray alloc] init];
        _cleanArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in decoration) {
            HBCleanCellModel *model = [[HBCleanCellModel alloc] initWithDictionary:dict error:nil];
            [model initVar];
            [_decorationArr addObject:model];
        }

        for (NSDictionary *dict in mainclean) {
            HBCleanCellModel *model = [[HBCleanCellModel alloc] initWithDictionary:dict error:nil];
            [model initVar];
            [_maincleanArr addObject:model];
        }
        for (NSDictionary *dict in clean) {
            HBCleanCellModel *model = [[HBCleanCellModel alloc] initWithDictionary:dict error:nil];
            [model initVar];
            [_cleanArr addObject:model];
        }


        [_tableViewMaintenance reloadData];
        [_tableViewCleanDecoration reloadData];
        [_tableViewClean reloadData];

        [_hud hide:YES];
        NSArray *bimage = ycstore[@"bimage"];
        [self loopaimage:bimage];
        [_hud hide:YES afterDelay:0];

    }            fail:^(NSError *error) {

        NSLog(@"HBLog:%@", error);
        [_hud hide:YES];
    }];
}

- (void)loopaimage:(NSArray *)imgurlArr {
    for (NSString *dic in imgurlArr) {
        NSString *url = [NSString stringWithFormat:@"%@%@", mainUrl, dic];
        [_loopImgArr addObject:url];
    }
    _loopView.imageURLStringsGroup = _loopImgArr;
}


#pragma mark tableView数据

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger num = 0;
    if (tableView == _tableViewClean) {
        num = _cleanArr.count;
    }
    if (tableView == _tableViewCleanDecoration) {
        num = _decorationArr.count;
    }
    if (tableView == _tableViewMaintenance) {
        num = _maincleanArr.count;
    }

    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HBCleanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBCleanCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (tableView == _tableViewClean) {
        HBCleanCellModel *model = _cleanArr[indexPath.row];
        [cell.buy setHidden:NO];

        [cell loadDataByModel:model];
        return cell;
    }
    if (tableView == _tableViewCleanDecoration) {
        HBCleanCellModel *model = _decorationArr[indexPath.row];
        [cell loadDataByModel:model];
        return cell;
    }
    if (tableView == _tableViewMaintenance) {
        HBCleanCellModel *model = _maincleanArr[indexPath.row];
        [cell loadDataByModel:model];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark 购物车功能

- (void)tableView:(UITableView *)tableView changeStatus:(NSDictionary *)status didSelectIndexPath:(NSIndexPath *)indexPath {//在三个tableview上任意服务点击加减的代理方法
    
    if (tableView == _tableViewClean) {
        HBCleanCellModel *model = _cleanArr[indexPath.row];
        [model setCount:status[@"count"]];
        [model setReduceStatus:status[@"reduceStatus"]];
        [model setCountLabStatus:status[@"countLabStatus"]];
        [self updateSelectArrWithModel:model];
    }
    if (tableView == _tableViewCleanDecoration) {
        HBCleanCellModel *model = _decorationArr[indexPath.row];
        [model setCount:status[@"count"]];
        [model setReduceStatus:status[@"reduceStatus"]];
        [model setCountLabStatus:status[@"countLabStatus"]];
        [self updateSelectArrWithModel:model];
    }
    if (tableView == _tableViewMaintenance) {
        HBCleanCellModel *model = _maincleanArr[indexPath.row];
        [model setCount:status[@"count"]];
        [model setReduceStatus:status[@"reduceStatus"]];
        [model setCountLabStatus:status[@"countLabStatus"]];
        [_selectGoods addObject:model];
        [self updateSelectArrWithModel:model];
    }

    self.payMethodView.ShopCarData = _selectGoods;
    [self.payMethodView.tableViewShopCar reloadData];

    [self updatePriceAndCount];
    
    
    
    if ([_selectGoods count]==0)
        [_ShopCarView setHidden:YES];
    else
        [_ShopCarView setHidden:NO];

}

- (void)updateSelectArrWithModel:(HBCleanCellModel *)model {//更新selectGoods的数据
    if ([_selectGoods containsObject:model]) {
        if ([model.count isEqualToString:@"0"]) {
            [_selectGoods removeObject:model];
            return;
        }
        [_selectGoods replaceObjectAtIndex:[_selectGoods indexOfObject:model] withObject:model];
    } else {
        [_selectGoods addObject:model];
    }
}

- (IBAction)toPay:(UIButton *)sender {//点击去结算
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {//登录检测
        [HBAuxiliary alertWithTitle:@"您还未登录" message:@"是否登录？" button:@[@"登录", @"暂不登录"] done:^{
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            BaseNavigationController *NA = [[BaseNavigationController alloc] initWithRootViewController:[HBLoginViewController new]];
            appDelegate.window.rootViewController = NA;
        }                    cancel:^{
            return ;
        }];
        return ;

    }
    
    
    
    HBMainPayViewController *VC = [[HBMainPayViewController alloc] initWithOrderArr:_selectGoods totalPrice:_price payName:@"购物车自由组合套餐" maintanaceInfo:_miantenanceModel];
    [self.navigationController pushViewController:VC animated:YES];

}


- (void)showShopCar:(id)sender {//点击底部购物车
    if (_selectGoods.count == 0) return;
    [mainKeyWindow addSubview:self.payMethodView];
    float height = [self.payMethodView updateFrame];//重新计算 上推高度和tableview和购物车的frame
    [UIView animateWithDuration:0.5 animations:^{
        self.payMethodView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.payMethodView.bgView.y = mainScreenHeight - height;//上推
    }];

}


#pragma mark - 通知更新

- (void)ClearAll:(NSNotification *)Notification {
    [_ShopCarView setHidden:YES];
    
    [_cleanArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HBCleanCellModel *model = (HBCleanCellModel *) obj;
        model.count = @"0";
        model.reduceStatus = @"0";
        model.countLabStatus = @"0";
    }];

    [_tableViewClean reloadData];

    [_decorationArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HBCleanCellModel *model = (HBCleanCellModel *) obj;
        model.count = @"0";
        model.reduceStatus = @"0";
        model.countLabStatus = @"0";
    }];
    [_tableViewCleanDecoration reloadData];

    [_maincleanArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HBCleanCellModel *model = (HBCleanCellModel *) obj;
        model.count = @"0";
        model.reduceStatus = @"0";
        model.countLabStatus = @"0";
    }];
    [_tableViewMaintenance reloadData];
    [_priceLab setHidden:YES];
    [_countLab setHidden:YES];
}

- (void)changeData:(NSNotification *)Notification {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:Notification.userInfo];
    HBCleanCellModel *model = [dic objectForKey:@"model"];
    if ([model.count isEqualToString:@"0"]) {//如果goods的count为0
        model.count = @"0";
        model.reduceStatus = @"0";
        model.countLabStatus = @"0";

        [_selectGoods removeObject:model];//移除
        float height = [self.payMethodView updateFrame];//重新计算 上推高度和tableview和购物车的frame

        [UIView animateWithDuration:0.5 animations:^{
            self.payMethodView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.payMethodView.bgView.y = mainScreenHeight - height;//上推
        }                completion:^(BOOL finished) {
            [self.payMethodView.tableViewShopCar reloadData];//重载
        }];
    }
    if ([_selectGoods count] == 0) [self.payMethodView removeView];


    if ([model.type isEqualToString:@"1"]) {
        [_cleanArr replaceObjectAtIndex:[_cleanArr indexOfObject:model] withObject:model];
        [_tableViewClean reloadData];

    }

    if ([model.type isEqualToString:@"2"]) {
        [_maincleanArr replaceObjectAtIndex:[_maincleanArr indexOfObject:model] withObject:model];
        [_tableViewMaintenance reloadData];


    }

    if ([model.type isEqualToString:@"3"]) {
        [_decorationArr replaceObjectAtIndex:[_decorationArr indexOfObject:model] withObject:model];
        [_tableViewCleanDecoration reloadData];

    }

    [self updatePriceAndCount];
    if ([_selectGoods count]==0)
        [_ShopCarView setHidden:YES];
    else
        [_ShopCarView setHidden:NO];

}

- (void)updatePriceAndCount {

    _counts = 0;
    _price = 0;

    for (HBCleanCellModel *model in _selectGoods) {
        _counts += [model.count integerValue];
        _price += [model.newprice floatValue] * [model.count integerValue];
    }
    if (_counts == 0) {
        [_priceLab setHidden:YES];
        [_countLab setHidden:YES];
    } else {
        [_countLab setHidden:NO];
        [_priceLab setHidden:NO];
        [_countLab setText:[NSString stringWithFormat:@"%ld", (long) _counts]];
        [_priceLab setText:[NSString stringWithFormat:@"%.2f", _price]];
    }

}


//移除消息订阅
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
