//
//  HBPayresult.m
//  CarApp
//
//  Created by 管理员 on 2017/4/22.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBPayresult.h"
#import "HBMainPayViewController.h"
@interface HBPayresult ()

@property (strong, nonatomic) IBOutlet UIImageView *resimg;

@property (strong, nonatomic) IBOutlet UILabel *resinfo;

@property (strong, nonatomic) IBOutlet UILabel *storeName;

@property (strong, nonatomic) IBOutlet UILabel *paymoney;
@property (strong, nonatomic) IBOutlet UILabel *payorder;

@end

@implementation HBPayresult

- (void)viewDidLoad {
    [super viewDidLoad];
    if([_result isEqualToString:@"Y"]){
    
    _resinfo.text = @"支付成功";
    
    }

    if([_result isEqualToString:@"C"]){
        
        _resinfo.text = @"支付取消";
        
    }
    if([_result isEqualToString:@"N"]){
        
        _resinfo.text = @"支付失败";
        
    }
    
    if([_result isEqualToString:@"D"]){
        
        _resinfo.text = @"订单处理中";
        
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)bake:(id)sender {
    
    NSArray *arr =  self.navigationController.viewControllers;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[HBMainPayViewController class]]){}
        
        [self.navigationController popToViewController:obj animated:YES];

        
        
    }];
    
    
    NSLog(@"HBLog:%@",arr);
    
}

@end
