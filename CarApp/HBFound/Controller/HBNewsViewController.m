//
//  HBNewsViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/6/18.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBNewsViewController.h"
#import "HBNetRequest.h"

@interface HBNewsViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *dateLab;
@property (strong, nonatomic) IBOutlet UILabel *ntitleLab;
@property (strong, nonatomic) IBOutlet UIButton *likeImgBtu;

@property(nonatomic,strong)NSString *nid;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,strong) MBProgressHUD *hud;

@end

@implementation HBNewsViewController

-(instancetype)initWithNid:(NSString *)nid{
    _nid = nid;
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
    [_webView.scrollView setBounces:NO];//禁止弹簧效果

    self.hud = [[MBProgressHUD alloc]init];
    [self.view addSubview:self.hud];
    _hud.labelText = @"加载中";
    [self.hud show:YES];

    
    [HBNetRequest Get:GETNEWS para:@{@"nid":_nid}
             complete:^(id data) {
                 NSInteger status = [data[@"status"] integerValue];
                 if (status==1) {
                     NSDictionary *news = data[@"news"];
                     NSString *ncontent = news[@"ncontent"];
                     _dateLab.text =news[@"date"];
                     _ntitleLab.text = news[@"ntitle"];
                     [_webView loadHTMLString:ncontent baseURL:nil];
                 }
    }
                 fail:^(NSError *error) {
                     [self.hud show:YES];
    }];
    
}
- (IBAction)likeClick:(UIButton *)sender {
    [_likeImgBtu setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud hide:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
