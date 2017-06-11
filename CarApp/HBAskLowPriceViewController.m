//
//  AskLowPriceViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/27.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBAskLowPriceViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"

@interface HBAskLowPriceViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *inputname;
@property (strong, nonatomic) IBOutlet UITextField *inputphone;
@property (strong, nonatomic) IBOutlet UILabel *bname;
@property (strong, nonatomic) IBOutlet UILabel *baddress;
@property (strong, nonatomic) IBOutlet UILabel *majorbusiness;
@property (strong, nonatomic) IBOutlet UILabel *title1;
@property (strong, nonatomic) IBOutlet UILabel *title2;
@property (strong, nonatomic) IBOutlet UIImageView *bimage;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *bphone;
@property (strong, nonatomic) IBOutlet UILabel *carinfolab;

@end

@implementation HBAskLowPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetData];
    _distance.text = [HBAuxiliary distance:_distanceStr];
    UIView *titlestoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    UIImageView *titlestoreImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80 , 20)];
    titlestoreImg.image = [UIImage imageNamed:@"asklowtitle"];
    [titlestoreView addSubview:titlestoreImg];
    self.navigationItem.titleView = titlestoreView;
    
    
    
    _inputphone.keyboardType = UIKeyboardTypePhonePad;
    _inputname.returnKeyType = UIKeyboardTypeNamePhonePad;
    _inputname.delegate = self;
    _inputphone.delegate = self;
    

    NSString *str = mainUrl;
    NSString *urlStr = [str stringByAppendingFormat:@"%@",_storeCarModel.bshowImage];
    [_bimage sd_setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
    
    
    _carinfolab.text  = _seriesOfCarModel.mname;
}

-(void)GetData{
    [self request:@"GET" url:[NSString stringWithFormat:@"%@%@",ASKLOWPIR,_bid]para:nil];
}


-(void)parserData:(id)data{
    NSDictionary *business = data[@"business"];
    _carinfolab.text = _carinfo;
    _bname.text = [business objectForKey:@"bname"];
    _baddress.text = [business objectForKey:@"baddress"];
    _majorbusiness.text = [business objectForKey:@"majorbusiness"];
    _title1.text = [business objectForKey:@"title1"];
    _title2.text = [business objectForKey:@"title2"];
    //_distance.text = [business objectForKey:@"baddress"];
    _bphone.text = [business objectForKey:@"bphone"];
}





-(void)postparse:(id)data{
    NSNumber *status =data[@"status"];
    NSString *statuStr = [NSString stringWithFormat:@"%@",status];
    if([statuStr isEqualToString:@"1"]){
        [self.view makeToast:@"提交成功" duration:3.0 position:nil];
        [self showHub:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if([statuStr isEqualToString:@"0"]||[statuStr isEqualToString:@"-1"]){
        [self.view makeToast:@"提交失败" duration:1.0 position:nil];
        [self showHub:NO];
    }
}



-(void)postfailure{
    [self showHub:NO];
     [self.view makeToast:@"提交失败" duration:1.0 position:nil];
}

//点击了提交按钮
- (IBAction)commit:(id)sender {
    
    [_inputname endEditing:YES];
    [_inputphone endEditing:YES];
    if([_inputname.text isEqualToString:@""]){
        [self.view makeToast:@"您还没输入姓名" duration:1.0 position:nil];
        return;
    }
    if(![HBAuxiliary isMobileNumber:_inputphone.text]||[_inputphone.text isEqualToString:@""]){
        [self.view makeToast:@"请输入正确手机号码" duration:1.0 position:nil];
        return;
    }
    
    NSMutableDictionary* parameter = [[NSMutableDictionary alloc]init];
    [parameter setValue:_inputname.text forKey:@"uname"];
    [parameter setValue:_inputphone.text forKey:@"phone"];
    [parameter setValue:_mid forKey:@"mid"];

    [self showHub:YES];
    NSString *str= ASKLOWCOMMIT;
    NSString *url = [NSString stringWithFormat:@"%@?mid=%@&uname=%@&phone=%@" ,str,_mid,_inputname.text,_inputphone.text];
    [self request:@"POST" url:url para:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==_inputphone){
        if((range.location - range.length) >=11&&(range.location - range.length)!=-1){
            [_inputname endEditing:YES];
            [_inputphone endEditing:YES];
        }else{
        }
    }
    if(textField==_inputname){
    
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];  // 取消第一响应者
    return YES;
}

@end
