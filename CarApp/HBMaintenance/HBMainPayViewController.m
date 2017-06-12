//
//  HBMainPayViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/4/5.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBMainPayViewController.h"
#import "HBPayInfoCell.h"
#import "HBPayWayCell.h"
#import <Masonry/Masonry.h>
#import "HBNetRequest.h"
#import "HBAuxiliary.h"
#import "HBCouponsViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HBLoginViewController.h"
#import "BaseNavigationController.h"
#import <Toast/UIView+Toast.h>
#import "HBPayresult.h"

#import "EzfMpAssist.h"

#import "HBOrderModel.h"

@interface HBMainPayViewController () <UITableViewDataSource, UITableViewDelegate>
//枚举支付方式
typedef NS_ENUM(NSInteger, PAYWAY) {
    PAYUNSELECT = 0,
    WEICHATPAY = 1,
    ALIPAY = 2,
    UNIONPAY = 3
};

//显示的TableView
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIButton *payBtu;//支付按钮
@property(strong, nonatomic) MBProgressHUD *hud;//提示

@property(strong, nonatomic) NSString *payName;//支付名称
@property(strong, nonatomic) NSArray *orderList;//支付对象数组
@property(assign, nonatomic) float totalPrice;//支付总价  --> 一直在变动

@property(nonatomic, strong) HBMiantenanceCarHomeModel *miantenanceModel;//店铺数据模型

//用于显示在本界面的一些固定信息
@property(strong, nonatomic) NSArray *payInfo;//支付的一些信息
@property(strong, nonatomic) NSArray *payWay;//支付方式标题
@property(strong, nonatomic) NSArray *payWayImg;//支付方式图片



@property(strong, nonatomic) NSString *storeinfo;



//支付方式
@property(assign, nonatomic) PAYWAY ENUMPAYWAY;
@property(strong, nonatomic) HBCouponsModel *useCoupons;//优惠券模型
@property(assign, nonatomic) Boolean *isFirstToCoupons;//是否第一次进入优惠券界面
@property(strong, nonatomic) __block NSString  *types;
@property(strong, nonatomic) __block NSMutableArray *CouponsArr;

@property(assign, nonatomic) NSUInteger selectpayWay;
@property(strong, nonatomic) NSString *project;
@property(strong, nonatomic) NSString *price;

@property(assign, nonatomic) NSString *currPrice;



//用于发送请求的订单数组
@property(strong, nonatomic) NSMutableArray *orderArr;
@property(strong, nonatomic) NSMutableDictionary *reusltDic;
@end

@implementation HBMainPayViewController

//初始化 需要选中订单  总价  支付名称 保养点店的信息
- (instancetype)initWithOrderArr:(NSArray *)orderList totalPrice:(float)totalPrice payName:(NSString *)payName maintanaceInfo:(HBMiantenanceCarHomeModel *)maintanaceModel {
    _miantenanceModel = maintanaceModel;
    _payName = payName;
    _totalPrice = totalPrice;
    _orderList = orderList;

    //NSLog(@"HBLog:%@", [self stringTOjson :_orderArr]);
    //NSLog(@"HBLog:%@",[[[self stringTOjson :_orderArr] stringByReplacingOccurrencesOfString:@"\\n""" withString:@""] stringByReplacingOccurrencesOfString:@"\\""" withString:@""]);
    return self;
}


- (NSString *)stringTOjson:(id)temps   //把字典和数组转换成json字符串
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temps
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    return strs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _ENUMPAYWAY = PAYUNSELECT;//默认为未选择
    _isFirstToCoupons  = YES;
    _CouponsArr = [NSMutableArray array];
    
    _hud = [[MBProgressHUD alloc] init];
    [self.navigationController.view addSubview:_hud];

    //titleView设置图片
    UIView *titleStoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 15)];
    UIImageView *titleStoreImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 15)];
    titleStoreImg.image = [UIImage imageNamed:@"paytitle"];
    [titleStoreView addSubview:titleStoreImg];
    self.navigationItem.titleView = titleStoreView;
    
    [self loadTableView];
    

    //支付按钮
    _payBtu = [[UIButton alloc] init];
    [_payBtu setTitle:[NSString stringWithFormat:@"需支付%.2f元", _totalPrice] forState:UIControlStateNormal];
    _payBtu.layer.cornerRadius = 5;
    _payBtu.layer.masksToBounds = YES;
    [_payBtu setBackgroundImage:[UIImage imageNamed:@"btuline"] forState:UIControlStateNormal];
    [self.view addSubview:_payBtu];
    [_payBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth * 2 / 3.f, 50));
    }];
    [_payBtu addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
    
    
    _types = [[NSString alloc] init];//用于统计三种服务类型 1,2,3
    [_orderList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HBCleanCellModel *model = (HBCleanCellModel *) obj;
            if (![_types containsString:model.type])   _types = [_types stringByAppendingFormat:@"%@,",model.type];
    }];
    _types = [_types substringToIndex:[_types length]-1];


}


- (void)clickPay {//点击支付按钮
    
    //禁用屏幕左滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    DEFAULTS
    NSString *uname = [defaults objectForKey:@"user"];
    NSString *uphone = [defaults objectForKey:@"uphone"];
    NSString *uid = [defaults objectForKey:@"uid"];
    _orderArr = [[NSMutableArray alloc] init];
    
    _types = [[NSString alloc] init];//用于统计三种服务类型 1,2,3
    [_orderList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HBCleanCellModel *model = (HBCleanCellModel *) obj;
        for (int i = 0; i < [model.count integerValue]; i++) {
            if (![_types containsString:model.type]) {
             _types = [_types stringByAppendingFormat:@"%@,",model.type];
            }
            HBOrderModel *orderModel = [[HBOrderModel alloc] init];
            orderModel.mbid = model.mbid;
            orderModel.bmname = _miantenanceModel.mbname;
            orderModel.bphone = _miantenanceModel.bphone;
            orderModel.bmname = _miantenanceModel.mbname;
            orderModel.sname = model.sname;
            orderModel.uname = uname;
            orderModel.uphone = uphone;
            orderModel.type = model.type;
            orderModel.uid = uid;
            
            //orderModel.rid = uid;
            orderModel.price = [NSString stringWithFormat:@"%f",_totalPrice];
            [_orderArr addObject:[HBAuxiliary getObjectData:orderModel]];
        }
    }];
    _types = [_types substringToIndex:[_types length]-1];


    if (![defaults objectForKey:@"token"]) {//是否登录
        [HBAuxiliary alertWithTitle:@"您还未登录" message:@"是否登录？" button:@[@"登录", @"暂不登录"] done:^{
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            BaseNavigationController *NA = [[BaseNavigationController alloc] initWithRootViewController:[HBLoginViewController new]];
            appDelegate.window.rootViewController = NA;
        }                    cancel:^{

        }];
        return;
    }

    if (_ENUMPAYWAY != PAYUNSELECT) {//判断是否选择了支付方式
        switch (_ENUMPAYWAY) {//不同支付有不同的bankid
            case WEICHATPAY:
                [self createOrdersWithBankId:@"991"];
                break;
            case ALIPAY:
                [self createOrdersWithBankId:@"992"];
                break;
            case UNIONPAY:
                [self createOrdersWithBankId:@"999"];
                break;

            default:
                return;
                break;
        }
    } else {//尚未选择支付方式
        [self.view makeToast:@"还没选择支付方式" duration:1.5 position:CSToastPositionBottom];
        return;
    }
}

- (void)createOrdersWithBankId:(NSString *)bankId {

    DEFAULTS

//    [par setObject:_miantenanceModel.mbname forKey:@"bmname"];
//    [par setObject: @"0.01"  forKey:@"price"];
//    [par setObject:(_useCoupons.rid == nil) ? @"":_useCoupons.rid  forKey:@"ruid"];
//    [par setObject:_project forKey:@"sname"];
//    [par setObject:_miantenanceModel.mbid forKey:@"mbid"];
//    
//    [par setObject:[defaults objectForKey:@"uid"] forKey:@"uid"];
//    [par setObject:[defaults objectForKey:@"uname"] forKey:@"uname"];
//    //[par setObject:[defaults objectForKey:@"uname"] forKey:@"uname"];
//    [par setObject:[defaults objectForKey:@"token"] forKey:@"token"];
//    //[par setObject:[defaults objectForKey:@"phone"] forKey:@"uphone"];
//    [par setObject:_model.newprice forKey:@"realprice"];



    _hud.labelText = @"正在生成订单";
    [_hud show:YES];
    //转换字符串去"\"和"\n"
    NSDictionary *par = @{@"orderList": [[[self stringTOjson:_orderArr] stringByReplacingOccurrencesOfString:@"\\n""" withString:@""] stringByReplacingOccurrencesOfString:@"\\""" withString:@""], @"token": [defaults objectForKey:@"token"]};
    [HBNetRequest Post:ADDORDER para:par complete:^(id data) {//用来请求goodid和
        [self pay:data bankId:bankId];
    }             fail:^(NSError *error) {//请求失败
        _hud.labelText = @"网络错误，获取订单失败";
        [_hud hide:YES afterDelay:1.0];
    }];
}


- (void)pay:(id)data bankId:(NSString *)bankId {//请求成功
    NSInteger status = [data[@"status"] integerValue];
    if (status == 1) {//判断状态
        DEFAULTS
        _reusltDic = data[@"ycorder"];
        [HBNetRequest Post:PAYMENT para:@{
                @"goodid":_reusltDic[@"goodid"],
                @"bankId":bankId,
                @"token":[defaults objectForKey:@"token"]
        } complete:^(id datas) {
            [self payment:datas];
        }             fail:^(NSError *error) {//请求错误
            _hud.labelText = @"网络错误，获取订单失败";
            [_hud hide:YES afterDelay:1.0];
        }];
    } else {//状态码不对
        _hud.labelText = @"信息错误，获取订单失败";
        [_hud hide:YES afterDelay:1.0];
    }
}

- (void)payment:(id)data {
    NSInteger status = [data[@"status"] integerValue];
    if (status == 1) {//状态正确
        [_hud hide:YES afterDelay:1.0];
        NSDictionary *paycode = data[@"paycode"];
        [[EzfMpAssist defaultAssist] startPay:paycode[@"qid"] //支付
                                   fromScheme:@"ronglian10001mobilepay"
                                         mode:@"01"
                               viewController:self
                                completeBlock:^(NSString *result) {//支付完成界面
                                    HBPayresult *resVC = [[HBPayresult alloc] initWithResInfo:_reusltDic qid:paycode[@"qid"] resultCode:result];
                                    [self.navigationController pushViewController:resVC animated:YES];
                                    
                                    
                                    //滑动开启
                                    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
                                }];
    }
}


#pragma mark tableView相关
- (void)loadTableView {
    
    
    _payInfo = @[@"服务商家", @"服务项目", @"订单金额", @"优惠券"];
    _payWay = @[@"微信支付", @"支付宝支付", @"银联支付"];
    _payWayImg = @[@"wechat", @"alipay", @"unionpay"];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 400)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 30;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.scrollEnabled = NO;//禁止滑动
    [_tableView registerNib:[UINib nibWithNibName:@"HBPayInfoCell" bundle:nil] forCellReuseIdentifier:@"PayInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HBPayWayCell"  bundle:nil] forCellReuseIdentifier:@"PayWayCell" ];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {//两个section的row
    if (section == 0) return _payInfo.count;
    if (section == 1) return _payWay.count;
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {//section数量
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//装数据
        HBPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayInfoCell" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                [cell ItemString:_payInfo[indexPath.row] InfoString:_miantenanceModel.mbname];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                break;
            case 1:
                [cell ItemString:_payInfo[indexPath.row] InfoString:_payName];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 2:
                [cell ItemString:_payInfo[indexPath.row] InfoString:[NSString stringWithFormat:@"%.2f元", _totalPrice]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 3:
                [cell ItemString:_payInfo[indexPath.row] InfoString:@" > "];
                break;
            default:
                break;
        }
        return cell;
    }
    if (indexPath.section == 1) {
        HBPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayWayCell"];
        if (indexPath.row == 0) {
            //[cell.select setHighlighted:YES];
        }
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell imgName:_payWayImg[indexPath.row] payWay:_payWay[indexPath.row]];
        return cell;
    }

    return [UITableViewCell new];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {//section的header
    if (section == 1)
        return @"选择支付方式";
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                _ENUMPAYWAY = WEICHATPAY;//微信
                break;
            case 1:
                _ENUMPAYWAY = ALIPAY;//支付宝
                break;
            case 2:
                _ENUMPAYWAY = UNIONPAY;//银联
                break;
            default:
                _ENUMPAYWAY = PAYUNSELECT;//未选择
                break;
        }
    }
#pragma mark 优惠券界面以及返回数据
    if (indexPath.section == 0 && indexPath.row == 3) {//优惠券界面
  
            HBCouponsViewController *vc = [[HBCouponsViewController alloc] initTypes:_types modelArr:_CouponsArr totalPrice:_totalPrice];
            [self.navigationController pushViewController:vc animated:YES];

            vc.block = ^(HBCouponsModel *coupons,NSMutableArray *modelArr) {//优惠券返回数据
               
                _CouponsArr = modelArr;
                if([_CouponsArr count]==0){//优惠券用完
                    _CouponsArr = nil;
                }
                _useCoupons = coupons;
                float subPrice = [coupons.price floatValue];
                float currPrice1 = _totalPrice;
                if (currPrice1 > subPrice) {
                    _totalPrice = currPrice1 - subPrice;
                    _currPrice = [NSString stringWithFormat:@"需支付 ￥ %.2f", _totalPrice];
                    [_payBtu setTitle:_currPrice forState:UIControlStateNormal];
                    [self.tableView reloadData];
                }
            };
        
    }
}








@end
