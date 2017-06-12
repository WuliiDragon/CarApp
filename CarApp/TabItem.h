//
//  TabItem.h
//  CarApp
//
//  Created by 管理员 on 2016/11/22.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabItem : UIControl {
    UIImageView *_itemImageView;
    UILabel *_itemLabel;
}

- (void)setItemImage:(UIImage *)image forState:(UIControlState)state;

- (void)setItemTitle:(NSString *)title;

- (void)setItemSelected:(BOOL)isSelected;
@end
