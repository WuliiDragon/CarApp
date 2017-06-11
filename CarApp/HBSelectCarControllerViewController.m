//
//  HBSelectCarControllerViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBSelectCarControllerViewController.h"
#import "HBTableViewCell.h"
#import "HBSelectCarModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface HBSelectCarControllerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *Cars;
    NSMutableArray *ModelCarArr;
    NSMutableDictionary *CarDic;
    NSMutableArray *totalArr;
    NSMutableArray *saveArr;//要保存的数据
    MBProgressHUD *hub;
    
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HBSelectCarControllerViewController
-(UITableView*)tableView{
    if(_tableView ==nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, [UIScreen mainScreen].bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        self.tableView.estimatedRowHeight = 10;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    UINib *Nib = [UINib nibWithNibName:@"HBTableViewCell" bundle:nil];
    [_tableView registerNib:Nib forCellReuseIdentifier:@"MYCELL"];
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Cars  = [[NSMutableArray alloc]init];
    CarDic = [[NSMutableDictionary alloc]init];
    ModelCarArr = [[NSMutableArray alloc]init];
    saveArr = [[NSMutableArray alloc] init];
    totalArr = [[NSMutableArray alloc] initWithCapacity:10];
    [self tableView];
    [self Getdata];
}








-(void)Getdata{
    [self showHub:YES];
    [self LoadFromLocal];
    if(totalArr.count>0){
         Cars = totalArr;
        [self getCarname];
        [_tableView reloadData];
        [self showHub:NO];
    }else{
        [self request:@"GET" url:@"http://api.jisuapi.com/car/brand?appkey=d4305b099393a00b" para:nil];
    }
   
}
-(void)parserData:(id)data{
    NSArray *array = data[@"result"];
    saveArr = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *mDictionary in array) {
        HBSelectCarModel *model = [[HBSelectCarModel alloc] init];
        model.initial = [mDictionary objectForKey:@"initial"];
        model.logo = [mDictionary objectForKey:@"logo"];
        model.ID = [mDictionary objectForKey:@"id"];
        model.name = [mDictionary objectForKey:@"name"];
        [totalArr addObject:model];
    }
    //判断数组里是否有元素
    if (totalArr.count > 0) {
        [self SaveToLocal];
    }
    Cars = totalArr;
    [self getCarname];
    [_tableView reloadData];
    [self showHub:NO];
}











#pragma mark - 按首字母排序成字典
-(void)getCarname{
    for (HBSelectCarModel *model in totalArr) {
        NSMutableArray *letterArr  = CarDic[model.initial];
        //判断数组里是否有元素，如果为nil，则实例化该数组，并在cityDict字典中插入一条新的数据
        if (letterArr == nil) {
            letterArr = [[NSMutableArray alloc] init];
            [CarDic setObject:letterArr forKey:model.initial];
        }
        //将新数据放到数组里
        [letterArr addObject:model];
    }
}
#pragma mark - 取到所有出现过的首字母数组
- (NSArray *)getDictAllKeys{
    //获得cityDict字典里的所有key值，
    NSArray *keys = [CarDic allKeys];
    //按升序进行排序（A B C D……）
    return [keys sortedArrayUsingSelector:@selector(compare:)];
}











#pragma mark - 引入索引的一个代理方法
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *keys = [self getDictAllKeys];//获得所有的key值
    return keys;
}
#pragma mark - section上的标题（A B C D……Z）
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [self getDictAllKeys];//获得所有的key值（A B C D……Z）
    return keys[section];
}
#pragma mark - section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *keys = [self getDictAllKeys];//获得所有的key值
    return keys.count;
}
#pragma mark - 每个section对应的cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = [self getDictAllKeys];//获得所有的key值
    NSString *keyStr = keys[section];//（A B C D……Z）
    NSArray *array = [CarDic objectForKey:keyStr];//所有section下key值所对应的value的值
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MYCELL";
    HBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[HBTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    NSArray *keys = [self getDictAllKeys];//获得所有的key值
    NSString *keyStr = keys[indexPath.section];
    NSArray *array = [CarDic objectForKey:keyStr];//所有section下key值所对应的value的值,array就是value值，存放的是model模型
    HBSelectCarModel *model = [array objectAtIndex:indexPath.row];
    [cell putdata:model];
    return cell;
}







#pragma mark - 从本地取数据
- (void)LoadFromLocal {
    //先清空数组里的元素
    [totalArr removeAllObjects];
    [saveArr removeAllObjects];
    NSString *name = [NSString stringWithFormat:@"MyCarslist.plist"];
    //获取本地数据,放到数组里
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[kDocumentPath stringByAppendingPathComponent:name]];
    for (NSDictionary *info in array) {
        [saveArr addObject:info];
    }
    for (NSDictionary *mDictionary in saveArr) {
        HBSelectCarModel *model = [[HBSelectCarModel alloc] init];
        model.initial = [mDictionary objectForKey:@"initial"];
        model.logo = [mDictionary objectForKey:@"logo"];
        model.ID = [mDictionary objectForKey:@"id"];
        model.name = [mDictionary objectForKey:@"name"];
        [totalArr addObject:model];
    }
}
#pragma mark - 保存到本地
- (void)SaveToLocal {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary *dict in saveArr) {
        [array addObject:dict];
    }
    //保存到MyCitylist.plist文件里
    NSString *name = [NSString stringWithFormat:@"MyCarslist.plist"];
    [array writeToFile:[kDocumentPath stringByAppendingPathComponent:name] atomically:YES];
}
@end
