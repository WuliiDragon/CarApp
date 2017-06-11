//
//  HBConfigurationOfCar.m
//  CarApp
//
//  Created by 管理员 on 2016/12/24.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBConfigurationOfCar.h"

@implementation HBConfigurationOfCar

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)item:(NSString *) item info:(NSString *)info{
    [_info setWidth:mainScreenWidth/2.3f];
    //[_item setWidth:mainScreenWidth/2.3f];
    _item.text = item;
    //if(info.length>5){
     //   _info.font= [UIFont systemFontOfSize:11];
    //}
    _info.text = info;
    
}
@end
