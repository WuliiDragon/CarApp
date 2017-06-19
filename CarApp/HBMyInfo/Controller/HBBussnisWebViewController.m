//
//  HBBussnisWebViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/6/18.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBBussnisWebViewController.h"
#import "HBNetRequest.h"
@interface HBBussnisWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong) MBProgressHUD *hud;

@end

@implementation HBBussnisWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
    [_webView.scrollView setBounces:NO];//禁止弹簧效果
    
    self.hud = [[MBProgressHUD alloc]init];
    [self.view addSubview:self.hud];
    _hud.labelText = @"加载中";
    [self.hud show:YES];
    
    NSURL* url = [NSURL URLWithString:BUSSNISOWER];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud hide:YES];
}

@end
