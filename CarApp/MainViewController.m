//
//  MainViewController.m
//  CarApp
//
//  Created by 管理员 on 2016/11/22.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "MainViewController.h"
#import "FoundViewController.h"
#import "HBMaintenanceCarViewController.h"
#import "MyInfoViewController.h"
#import "BaseNavigationController.h"
#import "HBBuyCarViewController.h"
#import "HBLoginViewController.h"

@interface MainViewController () <UITabBarControllerDelegate, UITabBarDelegate>
@property(nonatomic, strong) NSString *privateToken;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSonViewController];
}

#pragma mark 创建子控制器

- (void)loadSonViewController {
    NSArray *titles = @[@"购车", @"养车", @"发现", @"我的"];
    NSArray *images = @[@"itemBuyCar", @"itemMaintenanceCar", @"itemFound", @"itemMyInfo"];
    NSArray *imagesSelect = @[@"sitemBuyCar", @"sitemMaintenanceCar", @"sitemFound", @"sitemMyInfo"];
    self.tabBar.tintColor = mainColor;


    UITabBarItem *buyCarTabbar = [[UITabBarItem alloc] initWithTitle:titles[0]
                                                               image:[[UIImage imageNamed:images[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:
                                                               imagesSelect[0]]
                                                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    HBBuyCarViewController *buyCarVC = [[HBBuyCarViewController alloc] init];
    buyCarVC.tabBarItem = buyCarTabbar;
    BaseNavigationController *buyCarNav = [[BaseNavigationController alloc] initWithRootViewController:buyCarVC];

    UITabBarItem *maintenanceTabBar = [[UITabBarItem alloc] initWithTitle:titles[1]
                                                                    image:[[UIImage imageNamed:images[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                            selectedImage:[[UIImage imageNamed:imagesSelect[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    HBMaintenanceCarViewController *maintenanceCarVC = [[HBMaintenanceCarViewController alloc] init];
    maintenanceCarVC.tabBarItem = maintenanceTabBar;
    BaseNavigationController *maintenanceCarNav = [[BaseNavigationController alloc] initWithRootViewController:maintenanceCarVC];

    UITabBarItem *foundTabbar = [[UITabBarItem alloc] initWithTitle:titles[2]
                                                              image:[[UIImage imageNamed:images[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                      selectedImage:[[UIImage imageNamed:
                                                              imagesSelect[2]]
                                                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    FoundViewController *foundVC = [[FoundViewController alloc] init];
    foundVC.tabBarItem = foundTabbar;
    BaseNavigationController *foundNav = [[BaseNavigationController alloc] initWithRootViewController:foundVC];


    UITabBarItem *myInfoTabbar = [[UITabBarItem alloc] initWithTitle:titles[3]
                                                               image:[[UIImage imageNamed:images[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:
                                                               imagesSelect[3]]
                                                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    MyInfoViewController *myInfoVC = [[MyInfoViewController alloc] init];
    //HBMyinfoViewController *myInfoVC = [[HBMyinfoViewController alloc]init];

    myInfoVC.tabBarItem = myInfoTabbar;
    BaseNavigationController *myInfoNav = [[BaseNavigationController alloc] initWithRootViewController:myInfoVC];

    self.viewControllers = @[buyCarNav, maintenanceCarNav, foundNav, myInfoNav];
    self.delegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _privateToken = [userDefaults objectForKey:@"token"];
}


#pragma mark - 检查是否登录

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == tabBarController.viewControllers[3] /*判断第三个*/ && _privateToken == nil) {//如果判定没登录
        HBLoginViewController *loginViewController = [HBLoginViewController new];
        BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:loginViewController];
        [((BaseNavigationController *) tabBarController.selectedViewController) presentViewController:loginNav animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}


@end
