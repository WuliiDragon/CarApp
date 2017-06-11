//
//  MyInfoViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/12/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "MyInfoViewController.h"
#import "HBMenuItem.h"
#import "HBInfoSetTableViewController.h"


#import <objc/runtime.h>
#define Width   [UIScreen mainScreen].bounds.size.width*308.f/1000.f
#define inser   [UIScreen mainScreen].bounds.size.width*5.f/1000.f
@interface MyInfoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong) UIView *Header;
@property(nonatomic, strong) UICollectionView *CollectionView;
@property(nonatomic, strong) NSArray *menuItem;
@end

@implementation MyInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    _menuItem = [NSArray arrayWithObjects:@"我的订单",@"购物车",@"优惠券",@"收藏夹",@"邀请好友",@"每日签到",@"兑换专区",@"联系我们",@"设置", nil];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(Width,Width);
    layout.sectionInset = UIEdgeInsetsMake(inser,inser,inser,inser);
    _CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth ,mainScreenHeight-64) collectionViewLayout:layout];
    self.CollectionView.dataSource = self;
    self.CollectionView.delegate = self;
    self.CollectionView.showsVerticalScrollIndicator = NO;
    UINib *nib = [UINib nibWithNibName:@"HBMenuItem" bundle:nil];
    [self.CollectionView registerNib:nib forCellWithReuseIdentifier:@"NIBCELL"];
    [self.CollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];
    self.CollectionView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00];
    [self.view addSubview:_CollectionView];
    
    
    _Header= [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 200)];
    _Header.backgroundColor = [UIColor colorWithRed:0.37 green:0.69 blue:0.75 alpha:1.00];
    
    
    
    
    UIImageView *userimg = [[UIImageView alloc] init];
    userimg.image = [UIImage imageNamed:@"userimg"];
    [_Header addSubview:userimg];
    [userimg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
        make.width.offset(70);
        make.height.offset(70);
    }];
    
  

}

#pragma mark collectionView的操作------------
//section的数目
//每个section中cell的数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _menuItem.count;
}
//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HBMenuItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NIBCELL" forIndexPath:indexPath];
    [cell title:_menuItem[indexPath.row] image:[NSString stringWithFormat:@"%ld" ,(long)(indexPath.row+1)]];
    return cell;
}
//选中item后
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 8:{
            HBInfoSetTableViewController *vc = [[HBInfoSetTableViewController alloc] init];
            
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HEADER" forIndexPath:indexPath];
    [reusableView addSubview:_Header];
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(mainScreenWidth, 200);
}


@end
