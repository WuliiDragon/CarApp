//
//  HBInstallment ViewController.m
//  CarApp
//
//  Created by Dragon on 2017/1/8.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBInstallmentViewController.h"
#import "HBSearchConditioncell.h"
#import <Masonry/Masonry.h>


@interface HBInstallmentViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) UICollectionView *firstcollectionView;
@property(nonatomic, strong) UICollectionView *othercollectionView;
@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UILabel *priceTitle;
@property(nonatomic, strong) UILabel *price;

@property(nonatomic, strong) UILabel *firstPriceTitle;
@property(nonatomic, strong) UILabel *firstPrice;

@property(nonatomic, strong) UILabel *otherTimeTitle;
@property(nonatomic, strong) UILabel *otherTime;

@property(nonatomic, strong) UILabel *payPriceTitle;
@property(nonatomic, strong) UILabel *payPrice;

@property(nonatomic, strong) UIButton *applyForLoanBtu;


@property(nonatomic, strong) NSArray *titleArr;
@property(nonatomic, strong) NSArray *firstPayArr;
@property(nonatomic, strong) NSArray *otherPayTimeArr;
@property(nonatomic, strong) NSString *firstPriceStr;
@property(nonatomic, strong) NSString *otherTimeStr;

@end

@implementation HBInstallmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    heightArr[0] = 30;
    heightArr[1] = 200;
    heightArr[2] = 100;
    heightArr[3] = 30;
    _firstPriceStr = @"00%";
    _otherTimeStr = @"12期";
    _firstPayArr = [NSArray arrayWithObjects:@"0%", @"10%", @"20%", @"30%", @"40%", @"50%", @"60%", @"70%", @"80%", @"90%", nil];
    _otherPayTimeArr = [NSArray arrayWithObjects:@"12期", @"24期", @"36期 ", nil];


    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize = CGSizeMake(mainScreenWidth, mainScreenHeight);
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, mainScreenHeight));
        //make.top.left.right.bottom.offset(0);
    }];


    _priceTitle = [[UILabel alloc] init];
    _priceTitle.text = @"  购车总价";
    [_scrollView addSubview:_priceTitle];
    [_priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth / 2, 30));
    }];

    _price = [[UILabel alloc] init];
    _price.textAlignment = NSTextAlignmentRight;
    _price.text = [NSString stringWithFormat:@"%@ 万元", [HBAuxiliary makeprice:_gprice]];
    [_scrollView addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth / 2, 30));
    }];


    [self loadFirstcollectionView];
    [self loadOthercollectionView];


    _payPriceTitle = [[UILabel alloc] init];
    _payPriceTitle.text = @" 您选择的购车方案需要每月支付:";
    [_scrollView addSubview:_payPriceTitle];
    [_payPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_othercollectionView.mas_bottom).offset(3);
        make.right.offset(0);
        make.left.offset(0);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, 30));
    }];


    _payPrice = [[UILabel alloc] init];
    [_scrollView addSubview:_payPrice];
    [_payPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payPriceTitle.mas_bottom).offset(3);
        make.right.offset(0);
        make.left.offset(0);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, 30));
    }];
    NSString *result = [NSString stringWithFormat:@"%.1f元", [_gprice floatValue] * 10000 * (1 + [_stage12 floatValue]) / 12];
    _payPrice.text = result;


    _applyForLoanBtu = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth / 10.f, _payPrice.y + _payPrice.height + 4, mainScreenWidth * 8.f / 10.f, 80)];

    [_applyForLoanBtu setTitle:@"申请贷款" forState:UIControlStateNormal];
    [_applyForLoanBtu setBackgroundColor:mainColor];
    [_applyForLoanBtu addTarget:self action:@selector(clickApplyForLoanBtu) forControlEvents:UIControlEventTouchUpInside];

    [_scrollView addSubview:_applyForLoanBtu];
    [_applyForLoanBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payPrice.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth * 8.f / 10.f, 30));
    }];


}

- (void)loadFirstcollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(mainScreenWidth / 4, 35);
    _firstcollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _firstPriceTitle.y + _firstPriceTitle.height, mainScreenWidth, 35 * 5.f) collectionViewLayout:layout];
    _firstcollectionView.dataSource = self;
    _firstcollectionView.delegate = self;

    [_firstcollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    UINib *nib = [UINib nibWithNibName:@"HBSearchConditioncell" bundle:nil];
    [_firstcollectionView registerNib:nib forCellWithReuseIdentifier:@"NIBCELL"];
    _firstcollectionView.backgroundColor = [UIColor clearColor];

    _firstPriceTitle = [[UILabel alloc] init];
    _firstPriceTitle.text = @"首付比例";
    _firstPrice = [[UILabel alloc] init];
    [_scrollView addSubview:_firstPriceTitle];
    [_firstPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceTitle.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth / 2, 30));
    }];
    [_scrollView addSubview:_firstcollectionView];
    [_firstcollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, 35 * 5.f));
        make.top.mas_equalTo(_firstPriceTitle.mas_bottom).offset(3);
//        make.right.equalTo(_scrollView.mas_right).offset(3);
//        make.left.equalTo(_scrollView.mas_left).offset(3);
    }];
}

- (void)clickApplyForLoanBtu {
}


- (void)loadOthercollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(mainScreenWidth / 4, 35);
    _othercollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _otherTimeTitle.y + _otherTimeTitle.height, mainScreenWidth, 35 * 1.4f) collectionViewLayout:layout];

    _othercollectionView.dataSource = self;
    _othercollectionView.delegate = self;
    [_othercollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    UINib *nib = [UINib nibWithNibName:@"HBSearchConditioncell" bundle:nil];
    [_othercollectionView registerNib:nib forCellWithReuseIdentifier:@"NIBCELL"];
    _othercollectionView.backgroundColor = [UIColor clearColor];


    _otherTimeTitle = [[UILabel alloc] init];
    _otherTimeTitle.text = @"贷款期限";
    _otherTime = [[UILabel alloc] init];
    [_scrollView addSubview:_otherTimeTitle];
    [_otherTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstcollectionView.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth / 2, 30));
    }];
    [_scrollView addSubview:_otherTime];
    [_otherTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstcollectionView.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth / 2, 30));
    }];

    [_scrollView addSubview:_othercollectionView];
    [_othercollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mainScreenWidth, 35 * 1.4f));
        make.top.equalTo(_otherTimeTitle.mas_bottom).offset(3);
    }];
}


#pragma mark collectionView的操作------------

//section的数目
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section中cell的数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView == _firstcollectionView ? _firstPayArr.count : collectionView == _othercollectionView ? _otherPayTimeArr.count : 0;

}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBSearchConditioncell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NIBCELL" forIndexPath:indexPath];

    if (collectionView == _firstcollectionView) {
        cell.item.text = _firstPayArr[indexPath.row];
    }
    if (collectionView == _othercollectionView) {
        cell.item.text = _otherPayTimeArr[indexPath.row];
    }

    if (indexPath.row == 0) {
        //cell.select.backgroundColor = mainColor;
        cell.select.image = [UIImage imageNamed:@"kuang1"];
        cell.item.textColor = mainColor;
    } else {
        cell.select.image = [UIImage imageNamed:@"kuang2"];
    }
    cell.item.textColor = [UIColor darkGrayColor];
    return cell;
}

//选中item后
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HBSearchConditioncell *cell = (HBSearchConditioncell *) [collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:YES];
    cell.select.image = [UIImage imageNamed:@"kuang1"];
    cell.item.textColor = mainColor;
    NSArray *cells = collectionView.visibleCells;
    for (UICollectionViewCell *temp in cells) {
        HBSearchConditioncell *tempCell = (HBSearchConditioncell *) temp;
        if (tempCell != cell) {
            [tempCell setSelected:NO];
            tempCell.select.image = [UIImage imageNamed:@"kuang2"];
            tempCell.item.textColor = [UIColor darkGrayColor];
        }
    }

    if (collectionView == _firstcollectionView) {
        _firstPriceStr = cell.item.text;
    }
    if (collectionView == _othercollectionView) {
        _otherTimeStr = cell.item.text;
    }



    //按字符取出 两个数据
    NSArray *firstcon = [_firstPriceStr componentsSeparatedByString:@"%"];
    NSString *temp = firstcon[0];
    int firstPayInt = [temp intValue];

    NSArray *otherTime = [_otherTimeStr componentsSeparatedByString:@"期"];
    temp = otherTime[0];
    int otherTimeInt = [temp intValue];

    //转为浮点型方变计算
    float stage12F = [_stage12 floatValue];
    float stage24F = [_stage24 floatValue];
    float stage36F = [_stage36 floatValue];
    float price = [_gprice floatValue];
    //判空
    if (stage12F != 0 && stage24F != 0 && stage36F != 0) {
        float resultF;
        switch (otherTimeInt) {
            case 12: {
                resultF = ((price * 10000 * (1 - firstPayInt * 0.01)) * (1 + stage12F) / 12);
                NSString *result12 = [NSString stringWithFormat:@"%.1f元", resultF];
                _payPrice.text = result12;
            }
                break;
            case 24: {
                resultF = ((price * 10000 * (1 - firstPayInt * 0.01)) * (1 + stage24F) / 24);
                NSString *result24 = [NSString stringWithFormat:@"%.1f元", resultF];
                _payPrice.text = result24;

            }
                break;
            case 36: {
                resultF = ((price * 10000 * (1 - firstPayInt * 0.01)) * (1 + stage36F) / 36);
                NSString *result36 = [NSString stringWithFormat:@"%.1f元", resultF];
                _payPrice.text = result36;
            }
                break;
            default:
                break;
        }
    }
}

@end
