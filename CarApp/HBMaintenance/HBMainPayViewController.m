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
#import "HBCouponsModel.h"
#import "AppDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HBLoginViewController.h"
#import "BaseNavigationController.h"
#import <Toast/UIView+Toast.h>
#import "HBMiantenanceCarHomeModel.h"
#import "HBPayresult.h"

#import "EzfMpAssist.h"

#import "HBOrderModel.h"
@interface HBMainPayViewController ()<UITableViewDataSource,UITableViewDelegate>
//枚举支付方式
typedef NS_ENUM(NSInteger, PAYWAY){
    PAYUNSELECT = 0,
    WEICHATPAY = 1,
    ALIPAY  = 2,
    UNIONPAY = 3
};

@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) UIButton *payBtu;
@property(strong,nonatomic) MBProgressHUD *hud;
@property(strong,nonatomic) HBCleanCellModel *model;
@property(strong,nonatomic) NSString *storeinfo;
@property(nonatomic,strong) HBMiantenanceCarHomeModel *miantenanceModel;


@property(assign,nonatomic) PAYWAY ENUMPAYWAY;

@property(assign,nonatomic) NSUInteger selectpayWay;

@property(strong,nonatomic) NSString *project;
@property(strong,nonatomic) NSString *price;
@property(strong,nonatomic) NSArray *payInfo;
@property(strong,nonatomic) HBCouponsModel *useCoupons;

@property(assign,nonatomic) NSString *currPrice ;

@property(strong,nonatomic) NSArray *payWay;
@property(strong,nonatomic) NSArray *payWayImg;


@property(strong,nonatomic) NSMutableArray *orderArr;


@end

@implementation HBMainPayViewController

//-(instancetype)initWithModel:(HBCleanCellModel * )model maintanaceInfo:(HBMiantenanceCarHomeModel *) maintanaceModel storeInfo:(NSString *)info project:(NSString *)project{
//    _model = model;
//    _miantenanceModel = maintanaceModel;
//    _storeinfo = info;
//    _project = project;
//    return self;
//}


-(instancetype)initWithOrderArr:(NSArray *)orderList totalPrice:(float)totalPrice payName:(NSString *)payName maintanaceInfo:(HBMiantenanceCarHomeModel *) maintanaceModel {
    _miantenanceModel = maintanaceModel;
    
    DEFAULTS
    NSString *uname = [defaults objectForKey:@"user"];
    NSString *uphone =  [defaults objectForKey:@"uphone"];
    NSString *uid =  [defaults objectForKey:@"uid"];
    _orderArr = [[NSMutableArray alloc] init];
    [orderList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HBCleanCellModel *model = (HBCleanCellModel *)obj;
        for (int i = 0; i<[model.count integerValue]; i++) {
            HBOrderModel *orderModel = [[HBOrderModel alloc] init];
            orderModel.mbid = model.mbid;
            orderModel.bmname=  maintanaceModel.mbname;
            orderModel.bphone=  maintanaceModel.bphone;
            orderModel.bmname=  maintanaceModel.mbname;
            orderModel.sname=   model.sname;
            orderModel.uname = uname;
            orderModel.uphone =  uphone;
            orderModel.type = model.type;
            orderModel.uid = uid;
            orderModel.price = model.newprice;
           // [ _orderArr addObject:[HBAuxiliary dictionaryToJson: [HBAuxiliary getObjectData:orderModel]]];
        [ _orderArr addObject:orderModel];
        }
         
    }];
    //NSLog(@"HBLog:%@", [self stringTOjson :_orderArr]);
    //NSLog(@"HBLog:%@",[[[self stringTOjson :_orderArr] stringByReplacingOccurrencesOfString:@"\\n""" withString:@""] stringByReplacingOccurrencesOfString:@"\\""" withString:@""]);

    return self;
}


-(NSString *)stringTOjson:(id)temps   //把字典和数组转换成json字符串
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:temps
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _ENUMPAYWAY = PAYUNSELECT;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hud = [[MBProgressHUD alloc] init];
    [self.navigationController.view addSubview:_hud];
    //titleView设置图片
    UIView *titlestoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 15)];
    UIImageView *titlestoreImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,45,15)];
    titlestoreImg.image = [UIImage imageNamed:@"paytitle"];
    [titlestoreView addSubview:titlestoreImg];
    self.navigationItem.titleView = titlestoreView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _payInfo = [[NSArray alloc] initWithObjects:@"服务商家",@"服务项目",@"订单金额",@"优惠券" ,nil];
    _payWay = [[NSArray alloc] initWithObjects:@"微信支付",@"支付宝支付",@"银联支付", nil];
    _payWayImg = [[NSArray alloc] initWithObjects:@"wechat",@"alipay",@"unionpay", nil];
    [ self loadTableView];
    _payBtu = [[UIButton alloc] init];
    _currPrice = _model.newprice ;
    _ENUMPAYWAY = PAYUNSELECT;
    
    [_payBtu setTitle:[NSString stringWithFormat:@"需支付%@元",_currPrice] forState:UIControlStateNormal];
    _payBtu.layer.cornerRadius = 5;
    _payBtu.layer.masksToBounds = YES;
    [_payBtu setBackgroundImage:[UIImage imageNamed:@"btuline"] forState:UIControlStateNormal];
    [self.view addSubview:_payBtu];
    [_payBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth*2/3.f, 50));
    }];
    [_payBtu addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];
    
    
}



-(void)clickPay{
    DEFAULTS
    
    //未登录
    if(![defaults objectForKey:@"token"]){
        
        [HBAuxiliary alertWithTitle:@"您还未登录" message:@"是否登录？" button:@[@"登录",@"暂不登录"]done:^{
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            BaseNavigationController *NA = [[BaseNavigationController alloc] initWithRootViewController:[HBLoginViewController new]];
            appDelegate.window.rootViewController =NA;
        } cancel:^{
            //return ;
        }];
        
        return;
        
    }
    if(_ENUMPAYWAY != PAYUNSELECT){
        
        switch (_ENUMPAYWAY) {
            case WEICHATPAY:
                [self createOrdersWithBankId :@"991" ];
                break;
                
                
            case ALIPAY:
                [self createOrdersWithBankId :@"992" ];
                break;
            case UNIONPAY:
                
                [self createOrdersWithBankId :@"999" ];
                
                break;
                
            default:
                return;
                break;
        }
    }else{
        [self.view makeToast:@"还没选择支付方式" duration:1.5 position:CSToastPositionBottom];
        return;
        
    }
}




-(void) createOrdersWithBankId:(NSString *) bankId{
    
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc]init];
    
    DEFAULTS
    
    [par setObject:_miantenanceModel.mbname forKey:@"bmname"];
    [par setObject: @"0.01"  forKey:@"price"];
    [par setObject:(_useCoupons.rid == nil) ? @"":_useCoupons.rid  forKey:@"ruid"];
    
    [par setObject:_project forKey:@"sname"];
    [par setObject:_miantenanceModel.mbid forKey:@"mbid"];
    [par setObject:[defaults objectForKey:@"uid"] forKey:@"uid"];
    [par setObject:[defaults objectForKey:@"uname"] forKey:@"uname"];
    //[par setObject:[defaults objectForKey:@"uname"] forKey:@"uname"];
    [par setObject:[defaults objectForKey:@"token"] forKey:@"token"];
    //[par setObject:[defaults objectForKey:@"phone"] forKey:@"uphone"];
    [par setObject:_model.newprice forKey:@"realprice"];
    
    
    _hud.labelText = @"正在生成订单";
    [_hud show:YES];
    [HBNetRequest Post:ADDORDER para:par complete:^(id data) {
        [self pay:data bankId:bankId];
        
    } fail:^(NSError *error) {
        
        _hud.labelText = @"获取订单失败";
        [_hud hide:YES afterDelay:1.0];
    }];
    
    
}



-(void) pay:(id)data bankId:(NSString *)bankId{
    NSUInteger status = [data[@"status"] integerValue];
    if(status == 1){
        DEFAULTS
        NSDictionary *ycorder = data[@"ycorder"];
        NSString *goodid = ycorder[@"goodid"];
        
        NSMutableDictionary *par = [[NSMutableDictionary alloc]init];
        [par setObject:goodid forKey:@"goodid"];
        [par setObject: bankId  forKey:@"bankId"];
        [par setObject:[defaults objectForKey:@"token"] forKey:@"token"];
        
        
        [HBNetRequest Post:PAYMENT para:par complete:^(id data) {
            NSLog(@"HBLog:%@",data);
            
            [self payment:data];
        } fail:^(NSError *error) {
            NSLog(@"HBLog:%@",data);
            
            _hud.labelText = @"获取订单失败";
            [_hud hide:YES afterDelay:1.0];
        }];
    }else{
        _hud.labelText = @"获取订单失败";
        [_hud hide: YES afterDelay:1.0];
    }
}
-(void) payment :(id)data{
    NSUInteger status = [data[@"status"] integerValue];
    
    
    if(status==1){
        [_hud hide:YES afterDelay:1.0];
        NSDictionary *paycode = data[@"paycode"];
        
        NSString * qid = paycode[@"qid"];
        [[EzfMpAssist defaultAssist] startPay:qid
                                   fromScheme:@"ronglian10001mobilepay"
                                         mode:@"01"
                               viewController:self
                                completeBlock:^(NSString *result) {
                                    HBPayresult *resVC = [[HBPayresult alloc] init];
                                    resVC.result = result;
                                    [self.navigationController pushViewController:resVC animated:YES];
                                    NSLog(@"HBLog:%@",result);
                                }];
        
        
        
    }
    
    
    
    
}





-(void)loadTableView{
    //指定大小
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth,400)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    //预估行高estimatedRowHeight,达到cell高度的自适应
    self.tableView.estimatedRowHeight =30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    //注册nib以及重用资源符
    UINib *PayInfoCell = [UINib nibWithNibName:@"HBPayInfoCell" bundle:nil];
    [_tableView registerNib:PayInfoCell forCellReuseIdentifier:@"PayInfoCell"];
    
    UINib *PayWayCell = [UINib nibWithNibName:@"HBPayWayCell" bundle:nil];
    [_tableView registerNib:PayWayCell forCellReuseIdentifier:@"PayWayCell"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return _payInfo.count;
    if (section==1) return _payWay.count;
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}





-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
//避免重新回到前台错误
-(void)setupNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
}

//-(void)enterBG {
//    NSLog(@"HBLog:进入后台");
//}
//-(void)enterFG {
//    NSLog(@"HBLog:进入前台");
//
//
//  }




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        HBPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayInfoCell" forIndexPath:indexPath];
        
        
        switch (indexPath.row) {
            case 0:
                [cell ItemString:_payInfo[indexPath.row] InfoString:_storeinfo];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                break;
            case 1:
                [cell ItemString:_payInfo[indexPath.row] InfoString:_project];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 2:
                [cell ItemString:_payInfo[indexPath.row] InfoString:[_model.oldprice stringByAppendingString:@"元"]];
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
    if(indexPath.section==1){
        HBPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayWayCell"];
        
        if(indexPath.row==0){
            //[cell.select setHighlighted:YES];
        }
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell imgName:_payWayImg[indexPath.row] payWay:_payWay[indexPath.row]];
        return cell;
    }
    
    return [UITableViewCell new];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==1)
        return @"选择支付方式";
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 20;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:{
                _ENUMPAYWAY = WEICHATPAY;
            }
                break;
                
            case 1:
                _ENUMPAYWAY = ALIPAY;
                
                break;
            case 2:
                _ENUMPAYWAY = UNIONPAY;
                
                break;
            default:
                _ENUMPAYWAY = PAYUNSELECT;
                break;
                
                
                
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    if (indexPath.section==0&&indexPath.row==3) {
        
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSLog(@"HBLog:%@",obj);
            
            
        }];
        
        
        HBCouponsViewController *vc = [[HBCouponsViewController alloc] initWithCouponsArr:_model];
        
        
        
        
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.block = ^(HBCouponsModel *coupons){
            
            _useCoupons = coupons;
            float subPrice = [coupons.price floatValue];
            float currPrice1 = [_model.newprice floatValue];
            
            if(currPrice1>subPrice){
                currPrice1 = currPrice1 - subPrice;
                _currPrice = [NSString stringWithFormat:@"%.2f",currPrice1];
                [_payBtu setTitle:_currPrice forState:UIControlStateNormal];
            }
            
        };
        
    }
}



@end
