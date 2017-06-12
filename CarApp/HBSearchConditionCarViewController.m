//
//  HBSearchConditionCarViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/12/4.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBSearchConditionCarViewController.h"
#import "HBSearchConditionModel.h"
#import "HBSearchConditioncell.h"
#import "MUDoubleThumbSlider.h"
#import "HBSearchResultViewController.h"

@interface HBSearchConditionCarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    //价格最大最小值
    NSInteger min;
    NSInteger max;
}
@property(nonatomic, strong) MUDoubleThumbSlider *slider;
@property(nonatomic, strong) UIBarButtonItem *barButtion;
@property(nonatomic, strong) UIBarButtonItem *reset;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *SliderView;
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, strong) UILabel *Slildertitle;
@property(nonatomic, strong) UILabel *minprice;
@property(nonatomic, strong) UILabel *maxprice;
@property(nonatomic, strong) UILabel *selectItem;
@property(nonatomic, strong) NSMutableArray *selectItemArr;
@property(nonatomic, strong) NSMutableDictionary *keyDic;


@end

@implementation HBSearchConditionCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionView];
    [self initAndLoad];
}

- (void)initAndLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    _selectItemArr = [[NSMutableArray alloc] init];
    _keyDic = [[NSMutableDictionary alloc] init];
    min = 0;
    max = 100;


    //取到数据并重载
    _data = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SelectCarModel" ofType:@"plist"]];
    [self.collectionView reloadData];

    //显示顶部选中条件的Lable
    _selectItem = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, mainScreenWidth, 30)];
    _selectItem.text = @"全部条件";
    _selectItem.font = [UIFont systemFontOfSize:11.f];

    //滑动显示价格的View
    _SliderView = [[UIView alloc] initWithFrame:CGRectMake(0, _selectItem.frame.size.height, mainScreenWidth, 130)];
    _Slildertitle = [[UILabel alloc] initWithFrame:CGRectMake((mainScreenWidth - mainScreenWidth * 9.f / 10.f) / 2.f, 8, mainScreenWidth * 9.f / 10.f, 20)];
    _Slildertitle.text = @"价格";
    [_SliderView addSubview:_Slildertitle];


    //最大值与最小值Lable
    _minprice = [[UILabel alloc] initWithFrame:CGRectMake((mainScreenWidth - mainScreenWidth * 9.f / 10.f), _Slildertitle.origin.y + _Slildertitle.frame.size.height, mainScreenWidth / 2.f, 30)];
    _minprice.text = @"0万";
    _minprice.textColor = [UIColor orangeColor];
    _minprice.font = [UIFont systemFontOfSize:14.f];
    _maxprice = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth / 2.f - (mainScreenWidth - mainScreenWidth * 9.f / 10.f), _Slildertitle.origin.y + _Slildertitle.frame.size.height, mainScreenWidth / 2.f, 30)];
    _maxprice.text = @">100万";
    _maxprice.textColor = [UIColor orangeColor];
    _maxprice.font = [UIFont systemFontOfSize:14.f];
    _maxprice.textAlignment = NSTextAlignmentRight;

    //价格选择条
    _slider = [[MUDoubleThumbSlider alloc] initWithFrame:CGRectMake((mainScreenWidth - mainScreenWidth * 9.f / 10.f) / 2.f, _minprice.origin.y + _minprice.frame.size.height + 8, mainScreenWidth * 9.f / 10.f, 28)];
    _slider.continuous = YES;
    [_slider addTarget:self action:@selector(SliderChange) forControlEvents:UIControlEventValueChanged];
    [_SliderView addSubview:_slider];


    [_SliderView addSubview:_minprice];
    [_SliderView addSubview:_maxprice];

    //底部筛选按钮
    self.navigationController.toolbarHidden = NO;
    _barButtion = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(ClickScreening)];
    _reset = [[UIBarButtonItem alloc] initWithTitle:@"重置条件" style:UIBarButtonItemStylePlain target:self action:@selector(Clickreset)];
    _barButtion.width = mainScreenWidth / 3;
    _reset.width = mainScreenWidth / 2;
    _barButtion.tintColor = [UIColor whiteColor];
    _reset.tintColor = [UIColor whiteColor];
    NSArray *arr = [[NSArray alloc] initWithObjects:_reset, _barButtion, nil];
    self.toolbarItems = arr;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:0.37 green:0.69 blue:0.75 alpha:1.00];
    [self.view addSubview:_selectItem];
    [self.view addSubview:_SliderView];
}

- (void)Clickreset {
    [_keyDic removeAllObjects];
    [_selectItemArr removeAllObjects];
    _selectItem.text = @"全部条件";
    NSArray *selectArr = _collectionView.indexPathsForSelectedItems;
    for (NSIndexPath *indexpath in selectArr) {
        HBSearchConditioncell *cell = (HBSearchConditioncell *) [_collectionView cellForItemAtIndexPath:indexpath];
        cell.selected = NO;
        cell.select.image = [UIImage imageNamed:@"kuang2"];
        cell.item.textColor = [UIColor darkTextColor];
    }
    [self.collectionView reloadData];

}

//筛选点击事件
- (void)ClickScreening {
    NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
    NSArray *keyArr = [[NSArray alloc] initWithArray:_keyDic.allKeys];
    for (int i = 0; i < _keyDic.count; i++) {
        NSString *key = keyArr[i];
        NSArray *arr = [_keyDic objectForKey:key];
        NSString *items = [[NSString alloc] init];
        for (NSString *item in arr) {
            items = [items stringByAppendingFormat:@"%@,", item];
        }
        NSMutableString *citystring = [[NSMutableString alloc] initWithString:items];

        [citystring deleteCharactersInRange:NSMakeRange(items.length - 1, 1)];
        [itemDic setValue:citystring forKey:key];
    }


    [itemDic setValue:[NSString stringWithFormat:@"%ld", (long) min * 100] forKey:@"minprice"];
    [itemDic setValue:[NSString stringWithFormat:@"%ld", (long) max * 100] forKey:@"maxprice"];

    HBSearchResultViewController *VC = [[HBSearchResultViewController alloc] init];
    VC.itemDic = itemDic;
    VC.seleteItem = _selectItem.text;
    [self.navigationController pushViewController:VC animated:YES];
}


//Slider滑动监听
- (void)SliderChange {

    NSString *minStr = [NSString stringWithFormat:@"%f", _slider.minValue * 100];
    NSString *maxStr = [NSString stringWithFormat:@"%f", _slider.maxValue * 100];

    //转为int
    min = [minStr intValue];
    max = [maxStr intValue];

    if (max == 100) {
        _maxprice.text = [NSString stringWithFormat:@"%@", @">100万"];
    }

    //改变文字
    _minprice.text = [[NSString stringWithFormat:@"%ld", (long) min] stringByAppendingFormat:@"%@", @"万"];
    _maxprice.text = [[NSString stringWithFormat:@"%ld", (long) max] stringByAppendingFormat:@"%@", @"万"];


}


//view即将离开时隐藏Toolbar
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.toolbarHidden = NO;

}


//选中的项目字典 每个key下的value可能是多个，所以进行按key排练
- (void)AddToArr:(NSDictionary *)dic {
    NSMutableArray *letterArr = _keyDic[[dic objectForKey:@"key"]];
    if (letterArr == nil) {
        letterArr = [[NSMutableArray alloc] init];
        [_keyDic setObject:letterArr forKey:[dic objectForKey:@"key"]];
    }
    [letterArr addObject:[dic objectForKey:@"item"]];
}

//当取消选中时需要从字典中移除
- (void)RemoveToArr:(NSDictionary *)dic {
    NSMutableArray *letterArr = _keyDic[[dic objectForKey:@"key"]];
    if (letterArr != nil) {
        for (NSString *str in letterArr) {
            if ([[dic objectForKey:@"item"] isEqualToString:str]) {
                [letterArr removeObject:str];
                break;
            }
        }
        if (letterArr.count == 0) {
            [_keyDic removeObjectForKey:[dic objectForKey:@"key"]];
        }
    }

}

//对顶部显示字符串的数组进行删除
- (void)DeleteToArr:(NSString *)str {
    if ([_selectItemArr containsObject:str]) {
        [_selectItemArr removeObject:str];
    }
}

//更新顶部字符串的
- (void)displaylable {
    NSString *info = [[NSString alloc] init];
    for (NSString *str in _selectItemArr) {
        info = [info stringByAppendingFormat:@"%@/", str];
    }
    _selectItem.text = info;
}


#pragma mark collectionView的操作------------

//返回section之间的最小距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.f;
}

//section的数目
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _data.count;
}

//每个section中cell的数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic = _data[section];
    NSArray *arr = dic[@"item"];
    return arr.count;
}

//加载cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HBSearchConditioncell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NIBCELL" forIndexPath:indexPath];
    NSDictionary *dic = _data[indexPath.section];
    NSArray *arr = [dic objectForKey:@"item"];
    cell.item.text = arr[indexPath.row];
    if (cell.selected) {
        cell.select.image = [UIImage imageNamed:@"kuang1"];

    } else {
        cell.select.image = [UIImage imageNamed:@"kuang2"];
    }

    cell.item.textColor = [UIColor darkGrayColor];
    return cell;
}

//设置头尾视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(mainScreenWidth, 50);
}


//选中item后
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //将点中的项目将字符和key加到_selectItemArr中
    NSDictionary *getDic = _data[indexPath.section];
    NSArray *arr = getDic[@"item"];
    NSString *key = getDic[@"key"];
    NSString *itemStr = arr[indexPath.row];
    NSMutableDictionary *putDic = [[NSMutableDictionary alloc] init];
    [putDic setObject:key forKey:@"key"];
    [putDic setObject:itemStr forKey:@"item"];
    [_selectItemArr addObject:itemStr];
    [self AddToArr:putDic];
    HBSearchConditioncell *cell = (HBSearchConditioncell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:YES];
    cell.select.image = [UIImage imageNamed:@"kuang1"];
    cell.item.textColor = mainColor;
    [self displaylable];
}

//再次选中item后
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    HBSearchConditioncell *cell = (HBSearchConditioncell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:NO];
    cell.item.textColor = [UIColor darkTextColor];
    cell.select.image = [UIImage imageNamed:@"kuang2"];

    NSDictionary *getDic = _data[indexPath.section];
    NSArray *arr = getDic[@"item"];
    NSString *key = getDic[@"key"];
    NSString *itemStr = arr[indexPath.row];

    NSMutableDictionary *putDic = [[NSMutableDictionary alloc] init];
    [putDic setObject:key forKey:@"key"];
    [putDic setObject:itemStr forKey:@"item"];


    [self DeleteToArr:itemStr];
    [self RemoveToArr:putDic];
    [self displaylable];
}

// 返回头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HEADER" forIndexPath:indexPath];
    for (UIView *subview in reusableView.subviews) {
        [subview removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, mainScreenWidth, 50)];
    //HBSearchConditionModel *model = self.dataSource[indexPath.section];
    NSDictionary *dic = _data[indexPath.section];
    label.text = [dic objectForKey:@"title"];
    [reusableView addSubview:label];
    return reusableView;
}

//懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 35);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 130, mainScreenWidth, mainScreenHeight - 200) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
        UINib *nib = [UINib nibWithNibName:@"HBSearchConditioncell" bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"NIBCELL"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


@end
