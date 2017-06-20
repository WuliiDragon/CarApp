//
//  TableViewController.m
//  CarApp
//
//  Created by 管理员 on 2017/6/19.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBUserInfoSetViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "HBNetRequest.h"
#import <Toast/UIView+Toast.h>
#import "UIImageView+WebCache.h"
#import "HBUserImageCell.h"
#import "HBAuxiliary.h"
@interface HBUserInfoSetViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong) NSArray *titlelab;
@property(strong,nonatomic) UITextField *input;

@end

@implementation HBUserInfoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titlelab = [[NSArray alloc] initWithObjects:@"头像", @"手机号", @"姓名", @"邮箱",@"地址", nil];//title
    [self.tableView registerNib:[UINib nibWithNibName:@"HBUserImageCell" bundle:nil] forCellReuseIdentifier:@"HBUserImageCell"];
    self.tableView.estimatedRowHeight = 55;
    
    UIButton *btu = [[UIButton alloc] init];
    [btu setTitle:@"修改信息" forState:UIControlStateNormal];
    [btu addActionWithblocks:^{
        DEFAULTS
        [HBNetRequest Post:UPDATEUSERINFO para:@{@"uphone":[defaults objectForKey:@"uphone"] ? [defaults objectForKey:@"uphone"]:@"",
                                                 @"uname":[defaults objectForKey:@"uname"] ?[defaults objectForKey:@"uname"] :@"",
                                                 @"uaddress":[defaults objectForKey:@"uaddress"] ? [defaults objectForKey:@"uaddress"]:@"",
                                                 @"uemail":[defaults objectForKey:@"uemail"] ?[defaults objectForKey:@"uemail"]:@"",
                                                 @"uid":[defaults objectForKey:@"uid"],
                                                 @"token":[defaults objectForKey:@"token"],
                                                 
                                                 } complete:^(id data) {
                                                     NSInteger status = [data[@"status"] integerValue];
                                                     if (status==1) {
                                                      [self.view makeToast:@"修改成功" ];
                                                     }else{
                                                         [self.view makeToast:@"修改失败" ];
                                                     }
            
            
        } fail:^(NSError *error) {
            [self.view makeToast:@"网络错误，修改失败" ];
        }];
        
    }];
    [btu setBackgroundColor:[UIColor redColor]];
    btu.layer.masksToBounds = YES;
    btu.layer.cornerRadius = 10;
    
    [self.view addSubview:btu];
    
    [btu makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(0);
        make.top.offset(400);
        make.size.equalTo(CGSizeMake(300,50));
        
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    }


-(void)showAlertWith :(NSString *)title Message:(NSString *)message withUserInfo:(NSString *)info{
    UIAlertController* alert=   [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault
                                               handler:^(UIAlertAction* action) {
                                                   if ([_input.text isEqualToString:@""]) {
                                                       [self.view makeToast:@"内容不能为空"];

                                                       return ;
                                                   }
                                                   
                                                   
                                                   DEFAULTS
                                                   if([info isEqualToString:@"uphone"]){//手机号码验证
                                                       if ([HBAuxiliary validateMobile :_input.text ]) {
                                                            [defaults setObject:_input.text forKey:info];
                                                           [self.tableView reloadData];
                                                       }else{
                                                           [self.view makeToast:@"手机号不正确"];
                                                       }
                                                   
                                                   }else{//非手机
                                                       [defaults setObject:_input.text forKey:info];
                                                       [self.tableView reloadData];
                                                   }
                                                   
                                                   
                                                   
                                                   
                                               }];
    [alert addAction: cancel];
    [alert addAction: ok];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if ([info isEqualToString:@"uphone"]) {
            textField.keyboardType  = UIKeyboardTypePhonePad;
        }
        _input = textField;
    }];
    [self presentViewController: alert animated: YES completion: nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        
        HBUserImageCell *UserImageCell = [tableView dequeueReusableCellWithIdentifier:@"HBUserImageCell"];
        NSString *str = mainUrl;
        NSString *urlStr = [str stringByAppendingFormat:@"/carshop%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"uimage"]] ;
        [UserImageCell.userImg sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
        UserImageCell.userImg.layer.masksToBounds = YES;
        UserImageCell.userImg.layer.cornerRadius = 25;
        return UserImageCell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (indexPath.row==1) {
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"uphone"] ==[NSNull null] ? @"未设置" :[[NSUserDefaults standardUserDefaults] objectForKey:@"uphone"] ;
    }
    if (indexPath.row==2) {
        cell.detailTextLabel.text = ![[NSUserDefaults standardUserDefaults] objectForKey:@"uname"] ? @"未设置" :[[NSUserDefaults standardUserDefaults] objectForKey:@"uname"];
    }
    if (indexPath.row==3) {
        cell.detailTextLabel.text = ![[NSUserDefaults standardUserDefaults] objectForKey:@"uemail"] ? @"未设置" :[[NSUserDefaults standardUserDefaults] objectForKey:@"uemail"];
    }
    if (indexPath.row==4) {
        cell.detailTextLabel.text =![[NSUserDefaults standardUserDefaults] objectForKey:@"uaddress"] ? @"未设置" :[[NSUserDefaults standardUserDefaults] objectForKey:@"uaddress"];;
    }
    cell.textLabel.text = _titlelab[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){//上传头像
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换头像"
                                                                                 message:@"选择照片方式"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction* action) {
                                                               [self photoWithType:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertController addAction:camera];
        UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册选择"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction* action) {
                                                           
                                                          [self photoWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                       }];
        [alertController addAction:album];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
        

    }
    
    if(indexPath.row==1)  [self showAlertWith:@"修改信息" Message:@"手机号码" withUserInfo:@"uphone"];
    if(indexPath.row==2)  [self showAlertWith:@"修改信息" Message:@"姓名" withUserInfo:@"uname"];
    if(indexPath.row==3)  [self showAlertWith:@"修改信息" Message:@"邮箱" withUserInfo:@"uemail"];
    if(indexPath.row==4)  [self showAlertWith:@"修改信息" Message:@"地址" withUserInfo:@"uaddress"];
}



-(void)photoWithType:(NSUInteger )type{

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = type;
    [self presentViewController:imagePicker animated:YES completion:^{
        
        
    }];


}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
   // image = [self image:image scaleToSize:CGSizeMake(150, 150)];
    [HBNetRequest postWithImage:image Url:USERUPLOAD params:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],
                                                            @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
                                                                        } successBlock:^(id responseObject) {
                                                                            if ([responseObject[@"status"] integerValue]==1) {
                                                                                [self.view makeToast:@"上传成功" ];
                                                                                NSString *url = responseObject[@"url"];
                                                                                DEFAULTS
                                                                                [defaults setObject:url forKey:@"uimage"];
                                                                                [defaults synchronize];
                                                                                [self.tableView reloadData];
                                                                                
                                                                            }
                                                                            NSLog(@"HBLog:%@",responseObject);
                                                                        } Failure:^(NSError *error) {
                                                                            NSLog(@"HBLog:%@",error);
                                                                            [self.view makeToast:@"上传失败" ];
                                                                        }];
    
}

-(UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size{//改变大小
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(size);
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
