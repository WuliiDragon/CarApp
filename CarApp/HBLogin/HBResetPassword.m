//
//  HBResetPassword.m
//  CarApp
//
//  Created by 管理员 on 2017/4/1.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBResetPassword.h"
#import "HBAuxiliary.h"
#import "HBNetRequest.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HBUserItem.h"
#import <Toast/UIView+Toast.h>
#import "HBLoginViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"

@interface HBResetPassword () {
    BOOL passwordOk;
}
@property(strong, nonatomic) IBOutlet UITextField *passwordInput;
@property(strong, nonatomic) IBOutlet UIButton *setDone;
@property(nonatomic, strong) MBProgressHUD *hud;
@end

@implementation HBResetPassword

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
    title.image = [UIImage imageNamed:@"loginTitle"];
    self.navigationItem.titleView = title;
    [self.passwordInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.navigationController.view addSubview:_hud];
}


#pragma mark Textfiled相关

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _passwordInput) {
        if (textField.text.length >= 6 && textField.text.length <= 20)passwordOk = YES;
        else passwordOk = NO;
        if (textField.text.length >= 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
    if (passwordOk) {
        _setDone.enabled = YES;
    } else {_setDone.enabled = NO;}
}

- (IBAction)doneFound:(id)sender {
    if ([HBAuxiliary validatePassword:_passwordInput.text] && _respondCode) {//验证码正确 && 密码格式正确
        [_hud show:YES];
        [HBNetRequest Post:SETPWD para:@{@"upassword": _passwordInput.text,
                        @"code": _respondCode}
                  complete:^(id data) {
                      NSInteger status = [data[@"status"] integerValue];
                      if (status == 0) {
                          [self.view makeToast:@"错误" duration:2.0 position:CSToastPositionCenter];
                      }
                      if (status == 1) {
                          [_passwordInput resignFirstResponder];

                          AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

                          BaseNavigationController *NA = [[BaseNavigationController alloc] initWithRootViewController:[HBLoginViewController new]];
                          appDelegate.window.rootViewController = NA;
                      }
                      [_hud hide:YES];
                  } fail:^(NSError *error) {
                    [_hud hide:YES];
                }];

    } else {
        [self.view makeToast:@"密码格式错误" duration:2.0 position:CSToastPositionCenter];
    }


}

@end
