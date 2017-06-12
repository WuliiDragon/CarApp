//
//  HBRegisteredViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/3/28.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBRegisteredViewController.h"
#import "HBAuxiliary.h"
#import <Toast/UIView+Toast.h>
#import "HBNetRequest.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HBUserItem.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface HBRegisteredViewController () <UITextFieldDelegate> {
    BOOL allOK;
    BOOL phoeOK;
    BOOL codeOk;
    BOOL passwordOk;
}
@property(strong, nonatomic) IBOutlet UITextField *phoneInput;
@property(strong, nonatomic) IBOutlet UITextField *verificationCodeInput;
@property(strong, nonatomic) IBOutlet UITextField *passwordInput;
@property(strong, nonatomic) IBOutlet UIButton *sendVerCode;
@property(strong, nonatomic) IBOutlet UIButton *registBtu;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) NSString *respondCode;

@property(nonatomic, strong) NSTimer *timer; // timer
@property(nonatomic, assign) int countDown; // 倒数计时用
@property(nonatomic, strong) NSDate *beforeDate; // 上次进入后台时间

@end

@implementation HBRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    passwordOk = codeOk = phoeOK = allOK = NO;


    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
    title.image = [UIImage imageNamed:@"loginTitle"];
    self.navigationItem.titleView = title;


    self.phoneInput.delegate = self;
    self.verificationCodeInput.delegate = self;
    self.passwordInput.delegate = self;


    [self.phoneInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verificationCodeInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark 倒计时相关

- (void)startCountDown {
    _countDown = 60;
    _sendVerCode.enabled = NO;
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES]; // 需要加入手动RunLoop，需要注意的是在NSTimer工作期间self是被强引用的
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes]; // 使用NSRunLoopCommonModes才能保证RunLoop切换模式时，NSTimer能正常工作。
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)timerFired:(NSTimer *)timer {
    switch (_countDown) {
        case 1:
            [_sendVerCode setTitle:@"发送验证码" forState:UIControlStateNormal];
            _sendVerCode.enabled = YES;
            [self stopTimer];
            break;
        default:
            _countDown -= 1;
            [_sendVerCode setTitle:[NSString stringWithFormat:@"重发(%d)", _countDown] forState:UIControlStateNormal];
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self stopTimer]; // 如果没有在合适的地方销毁定时器就会内存泄漏啦，delloc也不可能执行。正确的销毁定时器这里可以不用写这个方法了，这里只是提个醒
}

//避免重新回到前台错误
- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)enterBG {
    _beforeDate = [NSDate date];
}

- (void)enterFG {
    NSDate *now = [NSDate date];
    int interval = (int) ceil([now timeIntervalSinceDate:_beforeDate]);
    //减掉后台那段时间
    int val = _countDown - interval;
    if (val > 1) {
        _countDown -= interval;
    } else {
        _countDown = 1;
    }
}


#pragma mark Textfiled相关

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.phoneInput) {
        if (textField.text.length < 13) phoeOK = NO;
        if (textField.text.length >= 13) {
            _sendVerCode.enabled = YES;
            phoeOK = YES;
            textField.text = [textField.text substringToIndex:13];
        }
        if (textField.text.length < 13) _sendVerCode.enabled = NO;

    }


    if (textField == _verificationCodeInput) {
        if (textField.text.length < 6) codeOk = NO;
        if (textField.text.length == 6) codeOk = YES;

        if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }


    if (textField == _passwordInput) {
        if (textField.text.length >= 6 && textField.text.length <= 20)passwordOk = YES;
        else passwordOk = NO;
        if (textField.text.length >= 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }

    if (phoeOK && passwordOk && codeOk) {
        _registBtu.enabled = YES;
    } else {
        _registBtu.enabled = NO;
    }


}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneInput) {
        if (range.length == 0) {
            if (textField.text.length == 3 || textField.text.length == 8) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
    }
    return YES;
}


- (IBAction)sendVerification:(id)sender {
    NSString *phoneNum = self.phoneInput.text;
    phoneNum = [HBAuxiliary removeSpace:phoneNum];
    _hud = [[MBProgressHUD alloc] init];
    _hud.labelText = @"正在加载...";
    [self.navigationController.view addSubview:_hud];
    if ([HBAuxiliary validateMobile:phoneNum]) {
        phoeOK = true;
        [_hud show:YES];
        [HBNetRequest Get:[NSString stringWithFormat:@"%@?ulogin=%@", REGISTFRIST, phoneNum] para:nil
                 complete:^(id data) {
                     [HBAuxiliary saveCookie];
                     NSUInteger status = [data[@"status"] integerValue];
                     if (status == 0) [self hadRegist];
                     if (status == 1) {
                         [self startCountDown];
                         _respondCode = data[@"code"];
                     }
                     [_hud hide:YES];

                 } fail:^(NSError *error) {
                }];
    } else {
        [self.view makeToast:@"您输入的手机号码有误" duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)hadRegist {
    [self.view makeToast:@"您的手机号已注册" duration:2.0 position:CSToastPositionCenter];
}

- (IBAction)Regist:(id)sender {
    if ([_respondCode isEqualToString:_verificationCodeInput.text] &&
            [HBAuxiliary validatePassword:_passwordInput.text]) {//验证码正确 && 密码格式正确

        [_hud show:YES];
        [HBNetRequest Post:REGISTlast para:@{@"code": _verificationCodeInput.text,
                @"upassword": _passwordInput.text,
        }         complete:^(id data) {

            NSInteger status = [data[@"status"] integerValue];
            if (status == 1) {
                NSDictionary *userDic = data[@"user"];
                HBUserItem *user = [[HBUserItem alloc] initWithDictionary:userDic error:nil];
                [HBUserItem saveUser:user];
                [HBAuxiliary saveCookie];

                [_hud hide:YES];
                [self hiddenKeyboardForTap];
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                appDelegate.window.rootViewController = [MainViewController new];


            }


        }             fail:^(NSError *error) {
            [_hud hide:YES];
        }];

    }

}

- (void)hiddenKeyboardForTap {
    [_phoneInput resignFirstResponder];
    [_passwordInput resignFirstResponder];
    [_verificationCodeInput resignFirstResponder];
}

@end
