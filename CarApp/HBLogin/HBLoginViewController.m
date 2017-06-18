//
//  HBLoginViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/3/27.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBLoginViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "HBRegisteredViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HBNetRequest.h"
#import "HBUserItem.h"
#import "HBFoundPassword.h"
#import <Toast/UIView+Toast.h>
#import "HBAuxiliary.h"

@interface HBLoginViewController () <UITextFieldDelegate>
  

@property(strong, nonatomic) IBOutlet UITextField *accountInput;
@property(strong, nonatomic) IBOutlet UITextField *passwordInput;
@property(strong, nonatomic) IBOutlet UIButton *loginBtu;
@property(strong, nonatomic) IBOutlet UIButton *forgetPasswordBtu;
@property(nonatomic, strong) MBProgressHUD *hud;
@end

@implementation HBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
    title.image = [UIImage imageNamed:@"loginTitle"];
    self.navigationItem.titleView = title;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backMainController)];

    
    
    _passwordInput.returnKeyType = UIReturnKeyDone;
    _passwordInput.delegate = self;//设置代理


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

//点击界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)backMainController {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [MainViewController new];
}


- (IBAction)loginAction:(id)sender {

    
    NSLog(@"HBLog:%lu",_accountInput.text.length);
    NSLog(@"HBLog:%lu",_passwordInput.text.length);
    
    if (_accountInput.text.length > 1 && _passwordInput.text.length > 1) {
        _hud = [[MBProgressHUD alloc] init];
        _hud.labelText = @"正在登录...";
        [self.navigationController.view addSubview:_hud];
        [_hud show:YES];
        [HBNetRequest Post:LOGIN para:@{
                        @"ulogin": _accountInput.text,
                        @"upassword": _passwordInput.text}
                  complete:^(id data) {
                      NSUInteger status = [data[@"status"] integerValue];
                      if (status == 0) {
                          [self.view makeToast:@"用户名或者密码错误" duration:1.0 position:CSToastPositionCenter];
                          [_hud hide:YES];
                      }
                      if (status == 1) {
                          NSDictionary *userDic = data[@"user"];
                          HBUserItem *user = [[HBUserItem alloc] initWithDictionary:userDic error:nil];
                          [HBUserItem saveUser:user];
                          [HBAuxiliary saveCookie];
                          [_hud hide:YES];
                          [self hiddenKeyboardForTap];
//                          DEFAULTS
//                          [HBNetRequest Post:@"http://59.110.5.105/carshop/user/demo.action" para:@{@"":[defaults objectForKey:@"token"]} complete:^(id data) {
//                              
//                              
//                              NSLog(@"%@",[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
//                          } fail:^(NSError *error) {
//                              
//                          }];
                          AppDelegate *appDelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
                          appDelegate.window.rootViewController = [MainViewController new];
                      }
                  } fail:^(NSError *error) {
                    [_hud hide:YES];
                }];
    }else{
        [self.view makeToast:@"手机号码或者密码长度不对" duration:1.0 position:CSToastPositionCenter];
    }

}


- (IBAction)registered:(id)sender {
    HBRegisteredViewController *registeredVC = [[HBRegisteredViewController alloc] init];
    [self.navigationController pushViewController:registeredVC animated:YES];

}




- (IBAction)forgetPassword:(id)sender {
    HBFoundPassword *vc = [[HBFoundPassword alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)hiddenKeyboardForTap {
    [_accountInput resignFirstResponder];
    [_passwordInput resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self hiddenKeyboardForTap];
}


@end
