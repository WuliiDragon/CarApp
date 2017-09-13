//
//  HBNewsViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/6/18.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBNewsViewController.h"
#import "HBNetRequest.h"
#import "HBAuxiliary.h"
@interface HBNewsViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *dateLab;
@property (strong, nonatomic) IBOutlet UILabel *ntitleLab;
@property (strong, nonatomic) IBOutlet UIButton *likeImgBtu;

@property(nonatomic,strong)NSString *nid;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *zanBtn;

@property(nonatomic,strong) UIView *preferencesView;
@property(nonatomic,strong) MBProgressHUD *hud;

@property (strong, nonatomic) IBOutlet UISwitch *ModelSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *fontSegCon;
@property (strong, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation HBNewsViewController

-(instancetype)initWithNid:(NSString *)nid{
    _nid = nid;
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _preferencesView = [[[NSBundle mainBundle] loadNibNamed:@"HBWebViewPreferences" owner:self options:nil] lastObject];
    [self.view addSubview:_preferencesView];
    [_preferencesView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).offset(0);
        make.right.left.offset(0);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, mainScreenHeight));
    }];


    DEFAULTS//设置字体夜间模式等
    [_ModelSwitch setOn:[defaults boolForKey:@"isNight"] ];
    NSInteger webViewFontSize = [defaults integerForKey:@"webViewFontSize"] ;
    switch (webViewFontSize) {
        case 80:
            [_fontSegCon setSelectedSegmentIndex:0];
            break;
        case 100:
            [_fontSegCon setSelectedSegmentIndex:1];
            break;
        case 120:
            [_fontSegCon setSelectedSegmentIndex:2];
            break;
    }
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    UILabel *Aa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    Aa.text = @"Aa";
    Aa.textColor = [UIColor whiteColor];
    [testView addSubview:Aa];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:testView];
    testView.userInteractionEnabled  = YES;
    [testView addActionWithblocks:^{
        [UIView animateWithDuration:0.2 animations:^{
            _preferencesView.y = mainScreenHeight - 64 - mainScreenHeight;
        } completion:^(BOOL finished) {
        }];
    }];
    
    
    _backView.userInteractionEnabled  = YES;
    [_backView addActionWithblocks:^{
        [UIView animateWithDuration:0.2 animations:^{
            _preferencesView.y = mainScreenHeight + 64 + mainScreenHeight;
        } completion:^(BOOL finished) {
        }];
    }];
    
    _webView.delegate = self;
    [_webView.scrollView setBounces:NO];//禁止弹簧效果

    self.hud = [[MBProgressHUD alloc]init];
    [self.view addSubview:self.hud];
    _hud.labelText = @"加载中";
    [self.hud show:YES];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [HBNetRequest Get:GETNEWS para:@{@"nid":_nid}
             complete:^(id data) {
                 NSInteger status = [data[@"status"] integerValue];
                 if (status==1) {
                     NSDictionary *news = data[@"news"];
                     NSString *ncontent = news[@"ncontent"];
                     _dateLab.text =news[@"date"];
                     _ntitleLab.text = news[@"ntitle"];
                     NSLog(@"HBLog:%ld",[news[@"linkNum"] integerValue]);
                     
                     
                     [_zanBtn  setSelected:[news[@"linkNum"] integerValue] > 0 ? YES : NO];
                     [_webView loadHTMLString:ncontent baseURL:nil];
                 }
    }
                 fail:^(NSError *error) {
                     [self.hud show:YES];
    }];
}
-(void)change:(NSInteger)value{
    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",(long)value];
    [_webView stringByEvaluatingJavaScriptFromString:str1];
    
}
- (IBAction)likeClick:(UIButton *)sender {
    [_likeImgBtu setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    DEFAULTS
    
    if([defaults boolForKey:@"isNight"]){//上次在夜间模式
        NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.backgroundColor='RGB(42, 55, 62)'"];
        [_webView stringByEvaluatingJavaScriptFromString:str1];
                 NSString* str2 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.color='RGB(147, 155, 158)'"];
        [_webView stringByEvaluatingJavaScriptFromString:str2];
        
        [_titleView setBackgroundColor:[UIColor colorWithRed:0.16 green:0.22 blue:0.24 alpha:1.00]];
        [_dateLab setTextColor:[UIColor whiteColor]];
        [_ntitleLab setTextColor:[UIColor whiteColor]];
       // [self.navigationController.navigationBar setBackgroundImage:[HBAuxiliary saImageWithSingleColor:[UIColor colorWithRed:0.16 green:0.22 blue:0.24 alpha:1.00]] forBarMetrics:UIBarMetricsDefault];

    }
    [self change: [[defaults objectForKey:@"webViewFontSize"] floatValue]];
    [self.hud hide:YES];
}

- (IBAction)FontChange:(UISegmentedControl *)sender {
    DEFAULTS
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self change:80];
            [defaults setInteger:80 forKey:@"webViewFontSize"];
            break;
        
        case 1:
            [self change:100];
            [defaults setInteger:100 forKey:@"webViewFontSize"];
            break;
        case 2:
            [self change:120.f];
            [defaults setInteger:120 forKey:@"webViewFontSize"];
            break;
        default:
            break;
    }
    [defaults synchronize];


}



- (IBAction)modelChange:(UISwitch *)sender {
    DEFAULTS
    if(sender.on){//改style
        [defaults setBool:YES forKey:@"isNight"];
        NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.backgroundColor='RGB(42, 55, 62)'"];
        [_webView stringByEvaluatingJavaScriptFromString:str1];
        
        NSString* str2 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.color='RGB(147, 155, 158)'"];
        [_webView stringByEvaluatingJavaScriptFromString:str2];
        
        [_titleView setBackgroundColor:[UIColor colorWithRed:0.16 green:0.22 blue:0.24 alpha:1.00]];
        [_dateLab setTextColor:[UIColor whiteColor]];
        [_ntitleLab setTextColor:[UIColor whiteColor]];
        //[self.navigationController.navigationBar setBackgroundImage:[HBAuxiliary saImageWithSingleColor:[UIColor colorWithRed:0.16 green:0.22 blue:0.24 alpha:1.00]] forBarMetrics:UIBarMetricsDefault];
    }else{
        [defaults setBool:NO forKey:@"isNight"];
        NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.backgroundColor='RGB(255, 255, 255)'"];
        [_webView stringByEvaluatingJavaScriptFromString:str1];
        
        
        NSString* str2 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.color='RGB(0, 0, 0)'"];
        [_webView stringByEvaluatingJavaScriptFromString:str2];
        
        [_titleView setBackgroundColor:[UIColor whiteColor]];
        [_dateLab setTextColor:[UIColor blackColor]];
        [_ntitleLab setTextColor:[UIColor blackColor]];
      //  [self.navigationController.navigationBar setBackgroundImage:[HBAuxiliary saImageWithSingleColor:mainColor] forBarMetrics:UIBarMetricsDefault];
    }
    [defaults synchronize];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[HBAuxiliary saImageWithSingleColor:mainColor] forBarMetrics:UIBarMetricsDefault];

}




@end
