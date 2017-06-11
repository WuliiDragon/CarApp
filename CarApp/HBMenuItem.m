//
//  HBMenuItem.m
//  CarApp
//
//  Created by 管理员 on 2016/12/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBMenuItem.h"

@implementation HBMenuItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void) title:(NSString *) title image :(NSString *)index{
    _title.text = title;
    _img.image = [UIImage imageNamed:index];
}
@end
