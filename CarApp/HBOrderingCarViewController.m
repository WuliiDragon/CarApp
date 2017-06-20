//
//  HBOrderingCarViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/12/7.
//  Copyright © 2016年 dragon. All rights reserved.
//
#define SCREEN [UIScreen mainScreen].bounds.size

#import "HBOrderingCarViewController.h"
#import "AddressPickerView.h"
#import "HBColorSelectModel.h"
#import "HBColorSelectCell.h"

@interface HBOrderingCarViewController () <AddressPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    BOOL isSelectBuycarCity;
    UIButton *lastClick;

}

@property(strong, nonatomic) NSMutableArray *carColordata;
@property(strong, nonatomic) UICollectionView *carColorView;
@property(nonatomic, strong) AddressPickerView *pickerView;

@property(strong, nonatomic) IBOutlet UIButton *buyCity;
@property(strong, nonatomic) IBOutlet UIButton *numberPlateBtu;

@property(strong, nonatomic) IBOutlet UILabel *numberPlateCityLab;
@property(strong, nonatomic) IBOutlet UILabel *buyCityLable;
@property(strong, nonatomic) IBOutlet UIView *colorView;


@property(strong, nonatomic) IBOutlet UIStackView *buyTime;
@property(strong, nonatomic) IBOutlet UIStackView *buyWay;


@property(strong, nonatomic) IBOutlet UILabel *gname;
@property(strong, nonatomic) IBOutlet UILabel *mname;
@property(strong, nonatomic) IBOutlet UILabel *mtitle;

@property(strong, nonatomic) IBOutlet UIButton *uploadImg;

@property(strong, nonatomic) IBOutlet UIImageView *uploadImage;


@end

@implementation HBOrderingCarViewController
//懒加载
- (UICollectionView *)carColorView {
    if (_carColorView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //每个cell的大小
        layout.itemSize = CGSizeMake(80, 27);
        //collectionView 中所有的cell的视图矩形对 collectionView上下左右距离
        layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
        //设定collectionView的frame 以及collectionViewLayout
        _carColorView = [[UICollectionView alloc] initWithFrame:CGRectMake(mainScreenWidth * 5.f / 100.f, 30, mainScreenWidth * 90.f / 100.f, 40) collectionViewLayout:layout];

        //指定代理
        self.carColorView.dataSource = self;
        self.carColorView.delegate = self;

        //注册item类型 这里使用系统的类型 设置重用资源标识符
        UINib *nib = [UINib nibWithNibName:@"HBColorSelectCell" bundle:nil];
        [self.carColorView registerNib:nib forCellWithReuseIdentifier:@"NIBCELL"];


        [self.carColorView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];

        self.carColorView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
        self.carColorView.allowsMultipleSelection = YES;
        [_colorView addSubview:_carColorView];
    }
    return _carColorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self carColorView];
    isSelectBuycarCity = YES;
    [self Getdata];
    [self pickerView];
    for (UIButton *btu in _buyWay.subviews) {
        [btu addTarget:self action:@selector(SelectBuyWay:) forControlEvents:UIControlEventTouchUpInside];
        [btu setBackgroundImage:[UIImage imageNamed:@"kuang2"] forState:UIControlStateNormal];
    }
    for (UIButton *btu in _buyTime.subviews) {
        [btu addTarget:self action:@selector(SelectBuyTime:) forControlEvents:UIControlEventTouchUpInside];
        [btu setBackgroundImage:[UIImage imageNamed:@"kuang2"] forState:UIControlStateNormal];
    }
    [self.view addSubview:self.pickerView];
}

- (void)initdata {
    _gname.text = _carStoreDetailModel.gname;
    _mname.text = _seriesOfCarModel.mname;
    _mtitle.text = _seriesOfCarModel.mtitle;
    _carColordata = [[NSMutableArray alloc] init];
}

#pragma mark collectionView的操作------------

//返回section之间的最小距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

//section的数目
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section中cell的数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _carColordata.count;
}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBColorSelectModel *model =_carColordata[indexPath.row];
    HBColorSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NIBCELL" forIndexPath:indexPath];
    [cell loadmodel:model];
    return cell;
}


#pragma mark 购车方式和预计购车方式的选择

- (void)SelectBuyWay:(id)sender {
    UIButton *selectBtu = sender;
    selectBtu.backgroundColor = mainColor;
    for (UIButton *btu in _buyWay.subviews) {
        if (btu != selectBtu) {
            btu.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)SelectBuyTime:(id)sender {
    UIButton *selectBtu = sender;
    selectBtu.backgroundColor = mainColor;
    for (UIButton *btu in _buyTime.subviews) {
        if (btu != selectBtu) {
            btu.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (IBAction)upLoadImg:(id)sender {
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", @"拍照", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
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
    [self uploadImage:image];
}

- (void)uploadImage:(UIImage *)img {
    _uploadImage.image = img;
    _uploadImg.hidden = YES;
}


- (IBAction)numberPlateBtu:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        _pickerView.frame = CGRectMake(0, SCREEN.height - 280, SCREEN.width, 280);
        [UIView commitAnimations];
    }];
    isSelectBuycarCity = NO;
}

- (void)Getdata {
    [HBNetRequest Get:ONLINEORDINGCAR para:@{@"mid":_seriesOfCarModel.mid} complete:^(id data) {
        
        
        NSArray *colors = data[@"colors"];
        for (NSDictionary *dict in colors) {
            HBColorSelectModel *model = [[HBColorSelectModel alloc] initWithDictionary:dict error:nil];
            [_carColordata addObject:model];
        }
        [_carColorView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
    
    
}



- (AddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, SCREEN.height, SCREEN.width, 280)];
        _pickerView.delegate = self;
    }
    return _pickerView;
}


- (IBAction)city:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        _pickerView.frame = CGRectMake(0, SCREEN.height - 280, SCREEN.width, 280);
        [UIView commitAnimations];
    }];
    isSelectBuycarCity = YES;
}

- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area {
    [UIView animateWithDuration:0.5 animations:^{
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        _pickerView.frame = CGRectMake(0, SCREEN.height, SCREEN.width, 280);
        [UIView commitAnimations];
    }];
    if (!isSelectBuycarCity) {
        [_numberPlateCityLab sizeToFit];
        _numberPlateCityLab.text = [NSString stringWithFormat:@"%@-%@-%@", province, city, area];
    } else {
        [_buyCityLable sizeToFit];
        _buyCityLable.text = [NSString stringWithFormat:@"%@-%@-%@", province, city, area];
    }
}

- (void)cancelBtnClick {
    [UIView animateWithDuration:0.5 animations:^{
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        _pickerView.frame = CGRectMake(0, SCREEN.height, SCREEN.width, 280);
        [UIView commitAnimations];
    }];
}


@end
