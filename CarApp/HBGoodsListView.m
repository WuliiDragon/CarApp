//
//  HBGoodsListView.m
//  CarApp
//
//  Created by 管理员 on 2017/6/8.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "HBGoodsListView.h"
#import "HBGoodInfoCell.h"


@implementation HBGoodsListView

-(instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects{
    
    return [self initWithFrame:frame withObjects:objects canReorder:NO];
}
-(instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects canReorder:(BOOL)reOrder{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.objects = [NSMutableArray arrayWithArray:objects];
        [self layoutUI];
    }
    return self;
}

-(void)layoutUI{
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.tableView.bounces = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HBGoodInfoCell" bundle:nil] forCellReuseIdentifier:@"GoodslistCell"];
}
#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objects count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HBGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodslistCell" forIndexPath:indexPath];
//    
//    
//    HBCleanCellModel *model = [[OrderModel alloc]initWithDictionary:[self.objects objectAtIndex:indexPath.row]];
//    
//    
//    [cell ListModel:model];
//    cell.operationBlock=^(NSInteger number,BOOL plus){
//
//        NSMutableDictionary * dic = self.objects[indexPath.row];
//        //更新选中订单列表中的数量
//        [dic setValue:[NSNumber numberWithInteger:number] forKey:@"orderCount"];
//        
//        NSMutableDictionary *notification = [[NSMutableDictionary alloc]init];
//        [notification setValue:[NSNumber numberWithBool:plus] forKey:@"isAdd"];
//        [notification setValue:dic forKey:@"update"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:self userInfo:notification];
//    };
    return cell;
    
}
@end
