//
//  BaseNavigationController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/22.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "BaseNavigationController.h"
#import "HBAuxiliary.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[HBAuxiliary saImageWithSingleColor:mainColor] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *vc = self.topViewController;
    UIStatusBarStyle style = [vc preferredStatusBarStyle];
    return style;
}
@end
