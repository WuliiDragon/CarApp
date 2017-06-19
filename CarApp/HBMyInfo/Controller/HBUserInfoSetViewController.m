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
@interface HBUserInfoSetViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong) NSArray *titlelab;
@property(strong,nonatomic) UITextField *passInput;

@end

@implementation HBUserInfoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titlelab = [[NSArray alloc] initWithObjects:@"头像", @"手机号", @"姓名", @"邮箱",@"地址", nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    }


-(void)showAlertWith :(NSString *)title Message:(NSString *)message{
    UIAlertController* alert=   [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction* action) {
                                                       [alert dismissViewControllerAnimated: YES completion: nil];
                                                       
                                                   }];
    
    
    
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault
                                               handler:^(UIAlertAction* action) {
                                                   
                                               }];
    [alert addAction: cancel];
    [alert addAction: ok];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _passInput = textField;
    }];
    
    [self presentViewController: alert animated: YES completion: nil];



}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    if (indexPath.row==0) {
        NSString *str = mainUrl;
        NSString *urlStr = [str stringByAppendingFormat:@"/carshop%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"uimage"]] ;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
        [cell.imageView setFrame:CGRectMake(mainScreenWidth-30, 0, 30, 30)];
    }

    
    cell.textLabel.text = _titlelab[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){//上传头像
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标准的Action Sheet样式"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction* action) {
                                                           [alertController dismissViewControllerAnimated: YES completion: nil];
                                                           
                                                       }];
        [alertController addAction:cancel];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction* action) {
            
        }];
        [alertController addAction:moreAction];
        //原来如此:style:UIAlertActionStyleDefault
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:OKAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
        
        
        
//        UIActionSheet *sheet;
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", @"拍照", nil];
//        } else {
//            sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
//        }
//        sheet.tag = 255;
//        [sheet showInView:self.view];
    }



}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 255) {
        NSInteger souseType = 0;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                    break;
                case 2:
                    souseType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    souseType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
            
        } else {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                souseType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = souseType;
        [self presentViewController:imagePicker animated:YES completion:^{
        }];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [self image:image scaleToSize:CGSizeMake(150, 150)];
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
                                                                        }];
    
}

-(UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size{
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
