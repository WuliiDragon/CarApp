//
//  HBResetPwdViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/6/20.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBResetPwdViewController.h"
#import "HBNetRequest.h"
@interface HBResetPwdViewController ()
@property (strong, nonatomic) IBOutlet UITextField *oldPwd;
@property (strong, nonatomic) IBOutlet UITextField *newpwd;
@end

@implementation HBResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
//点击界面
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)changeClick:(id)sender {
    if ([_oldPwd .text length] >1 && [_newpwd.text length] > 1) {
        [self.view endEditing:YES];

        [HBNetRequest Post:UPDATEUSERPWD para:@{@"old":_oldPwd.text,
                                                @"news":_newpwd.text,
                                                @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                                                @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]
                                                } complete:^(id data) {
                                                    NSInteger status = [data[@"status"] integerValue];
                                                    if (status==1) {
                                                        [self.navigationController.view makeToast:@"密码修改成功"];
                                                        [self.navigationController popViewControllerAnimated:YES ];
                                                    }else{
                                                    
                                                    [self.view makeToast:@"密码修改失败"];
                                                    }
                                                } fail:^(NSError *error) {
                                                    [self.view makeToast:@"网络错误，密码修改失败"];
                                                }];
            }else{
        [self.view makeToast:@"长度不正确"];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];

}
@end
