//
//  HBFoundPassword.m
//  CarApp
//
//  Created by 管理员 on 2017/4/1.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBFoundPassword.h"
#import "HBResetPassword.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HBAuxiliary.h"
#import <Toast/UIView+Toast.h>
#import "HBNetRequest.h"
@interface HBFoundPassword ()<UITextFieldDelegate>
{
    BOOL allOK;
    BOOL phoeOK;
    BOOL codeOk;
}
@property (strong, nonatomic) IBOutlet UIButton *nextBtu;
@property (strong, nonatomic) IBOutlet UITextField *phoneInput;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeInput;
@property (strong, nonatomic) IBOutlet UIButton *sendVerCode;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property(nonatomic,strong)MBProgressHUD *hud;



@property(nonatomic,strong)NSTimer *timer; // timer
@property(nonatomic,assign)int countDown; // 倒数计时用
@property(nonatomic,strong)NSDate *beforeDate; // 上次进入后台时间


@property(nonatomic,strong)NSString *respondCode;

@end

@implementation HBFoundPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
    title.image = [UIImage imageNamed:@"loginTitle"];
    self.navigationItem.titleView =title;
    
    self.phoneInput.delegate = self;
    self.verificationCodeInput.delegate =  self;

    [self.phoneInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verificationCodeInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark 倒计时相关
-(void)startCountDown {
    _countDown = 60;
    
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
    }
}
-(void)timerFired:(NSTimer *)timer {
    switch (_countDown) {
        case 1:
            [_sendVerCode setTitle:@"发送验证码" forState:UIControlStateNormal];
            _sendVerCode.enabled = YES;
            [self stopTimer];
            break;
        default:
            _countDown -=1;
            _sendVerCode.enabled = NO;
            [_sendVerCode setTitle:[NSString stringWithFormat:@"重发(%d)",_countDown] forState:UIControlStateNormal];
            break;
    }
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self stopTimer];
}
-(void)setupNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)enterBG {
    _beforeDate = [NSDate date];
}
-(void)enterFG {
    NSDate * now = [NSDate date];
    int interval = (int)ceil([now timeIntervalSinceDate:_beforeDate]);
    int val = _countDown - interval;
    if(val > 1){
        _countDown -= interval;
    }else{
        _countDown = 1;
    }
}




#pragma mark Textfiled相关
-(void)textFieldDidChange:(UITextField * )textField{
    if (textField == self.phoneInput) {
        if (textField.text.length < 13)   phoeOK = NO;
        if (textField.text.length >= 13) {
            _sendVerCode.enabled = YES;
            phoeOK = YES;
            textField.text = [textField.text substringToIndex:13];
        }
        if(textField.text.length < 13) _sendVerCode.enabled = NO;
        
    }
    
    
    
    
    if (textField == _verificationCodeInput) {
        if(textField.text.length < 6) codeOk = NO;
        if(textField.text.length==6) codeOk = YES;
        if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
    

    if(phoeOK&&codeOk){
        _nextBtu.enabled = YES;
    }else{
        _nextBtu.enabled = NO;
    }
    
    
}//手机号格式
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==_phoneInput) {
        if (range.length == 0){
            if (textField.text.length == 3 ||textField.text.length == 8) {
                textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
            }
        }
    }
    return YES;
}







- (IBAction)sendVerification:(id)sender {
    NSString *phoneNum = self.phoneInput.text;
    phoneNum = [HBAuxiliary removeSpace:phoneNum];
    _hud = [[MBProgressHUD alloc]init];
    _hud.labelText = @"正在加载...";
    [self.navigationController.view addSubview:_hud];
    if([HBAuxiliary validateMobile:phoneNum]){
        phoeOK = true;
        [_hud show:YES];
        [HBNetRequest Get:[NSString stringWithFormat:@"%@?ulogin=%@",FINDPWD,phoneNum] para:nil
                 complete:^(id data) {
                     NSUInteger status = [data[@"status"] integerValue];
                     [HBAuxiliary saveCookie];
                     if(status==0)  [self hadNotRegist];
                     if(status==1) {
                         [self startCountDown];
                         _respondCode =data[@"code"];
                     }
                     [_hud hide:YES];
                 } fail:^(NSError *error) {
                     
                 }];
    }else{
        [self.view makeToast:@"您输入的手机号码有误" duration:2.0 position:CSToastPositionCenter];
    }
}

-(void)hadNotRegist{
    [self.view makeToast:@"您还未注册过账户" duration:2.0 position:CSToastPositionCenter];
}

- (void)hiddenKeyboardForTap{
    [_phoneInput resignFirstResponder];
    [_verificationCodeInput resignFirstResponder];
}

- (IBAction)nextClick:(id)sender {
    if([_respondCode isEqualToString:_verificationCodeInput.text]){
        HBResetPassword *vc = [[HBResetPassword alloc] init];
        if(_respondCode) vc.respondCode = _respondCode;
        
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
