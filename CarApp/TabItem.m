//
//  TabItem.m
//  CarApp
//
//  Created by 管理员 on 2016/11/22.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "TabItem.h"

@implementation TabItem

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        CGFloat itemWidth = CGRectGetWidth(frame);
        CGFloat itemHeight = CGRectGetHeight(frame);
        
        _itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake((itemWidth-22)/2, 10.f, 22.f, 20.f)];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_itemImageView];
        
        _itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, itemHeight-20, itemWidth, 20)];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        _itemLabel.textColor = [UIColor blackColor];
        _itemLabel.backgroundColor = [UIColor clearColor];
        _itemLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _itemLabel.highlightedTextColor = mainColor;
        [self addSubview:_itemLabel];
    }
    return self;
}
-(UIColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
- (void)setItemImage:(UIImage *)image forState:(BOOL) state{
    if(state == true){
        _itemImageView.image = image;
    }else if (state == false){
        _itemImageView.highlightedImage = image;
    }
}

- (void)setItemTitle:(NSString *)title{
    _itemLabel.text = title;
}

- (void)setItemSelected:(BOOL)isSelected{
    _itemImageView.highlighted = isSelected;
    _itemLabel.highlighted = isSelected;
}


@end
