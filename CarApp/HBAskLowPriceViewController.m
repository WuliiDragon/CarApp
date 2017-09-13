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

@interface HBAskLowPriceViewController () <UITextFieldDelegate>
@property(nonatomic, strong) MBProgressHUD *hud;

@property(strong, nonatomic) IBOutlet UITextField *inputname;
@property(strong, nonatomic) IBOutlet UITextField *inputphone;
@property(strong, nonatomic) IBOutlet UILabel *bname;
@property(strong, nonatomic) IBOutlet UILabel *baddress;
@property(strong, nonatomic) IBOutlet UILabel *majorbusiness;
@property(strong, nonatomic) IBOutlet UILabel *title1;
@property(strong, nonatomic) IBOutlet UILabel *title2;
@property(strong, nonatomic) IBOutlet UIImageView *bimage;
@property(strong, nonatomic) IBOutlet UILabel *distance;
@property(strong, nonatomic) IBOutlet UILabel *bphone;
@property(strong, nonatomic) IBOutlet UILabel *carinfolab;

@end

@implementation HBAskLowPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *titlestoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    UIImageView *titlestoreImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    titlestoreImg.image = [UIImage imageNamed:@"asklowtitle"];
    [titlestoreView addSubview:titlestoreImg];
    self.navigationItem.titleView = titlestoreView;

    _inputphone.keyboardType = UIKeyboardTypePhonePad;
    _inputname.returnKeyType = UIKeyboardTypeNamePhonePad;
    _inputname.delegate = self;
    _inputphone.delegate = self;
    
    
    _distance.text = [HBAuxiliary distance:_StoreCarModel.distance];
    _carinfolab.text = _SeriesOfcarModel.mname;
    _bname.text = _StoreCarModel.bname;
    _baddress.text = _StoreCarModel.baddress;
    _majorbusiness.text = _StoreCarModel.majorbusiness;
    _title1.text = _StoreCarModel.title1;
    _title2.text = _StoreCarModel.title2;
    _bphone.text = _StoreCarModel.bphone;
    
    
    
    [HBNetRequest Get:ASKLOWPIR para: @{@"bid":_bid}
             complete:^(id data) {
                 NSDictionary *business = data[@"business"];
                 //_carinfolab.text = _carinfo;
                 _bname.text = [business objectForKey:@"bname"];
                 _baddress.text = [business objectForKey:@"baddress"];
                 _majorbusiness.text = [business objectForKey:@"majorbusiness"];
                 _title1.text = [business objectForKey:@"title1"];
                 _title2.text = [business objectForKey:@"title2"];
                 _bphone.text = [business objectForKey:@"bphone"];
                 
                 NSString *str = mainUrl;
                 NSString *urlStr = [str stringByAppendingFormat:@"%@", [business objectForKey:@"bshowImage"]];
                 [_bimage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];

    } fail:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}





//点击了提交按钮
- (IBAction)commit:(id)sender {

    [_inputname endEditing:YES];
    [_inputphone endEditing:YES];
    if ([_inputname.text isEqualToString:@""]) {
        [self.view makeToast:@"您还没输入姓名" duration:1.0 position:nil];
        return;
    }
    if (![HBAuxiliary isMobileNumber:_inputphone.text] || [_inputphone.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入正确手机号码" duration:1.0 position:nil];
        return;
    }


    [HBNetRequest Get:ASKLOWCOMMIT para:@{@"mid":_SeriesOfcarModel.mid ,
                                          @"uname": _inputname.text,
                                          @"phone":_inputphone.text} complete:^(id data) {
                                              NSUInteger status = [data[@"status"] integerValue];
                                              if (status == 1) {
                                                  [self.navigationController.view makeToast:@"我们已收到，会及时联系你" duration:1.0 position:CSToastPositionCenter];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              }
    } fail:^(NSError *error) {
        
        
        
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _inputphone) {
        if ((range.location - range.length) >= 11 && (range.location - range.length) != -1) {
            [_inputname endEditing:YES];
            [_inputphone endEditing:YES];
        } else {
        }
    }
    if (textField == _inputname) {

    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];  // 取消第一响应者
    return YES;
}

@end
