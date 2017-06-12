//
//  AppDelegate.m
//  CarApp
//
//  Created by 管理员 on 2016/11/22.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "HBAuxiliary.h"
#import "EzfMpAssist.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //打印沙河路径
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);

    [HBAuxiliary loadCookies];

    [[EzfMpAssist defaultAssist] regWechatApp:@"wx9b4839c6e3ffbe1e"];

    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight)];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[MainViewController alloc] init];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    //说明：当应用程序即将失去焦点时，被调用。比如电话呼叫，都将导致应用失去焦点 ，或者当用户退出应用程序。
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //说明：当应用进入后台时被调用，如果要让应用在后台运行，需要在这里进行设置
    //
    //，使用这个方法来释放共享资源，保存用户数据，废止定时器，并存储足够的应用程序状态信息的情况下被终止后，将应用程序恢复到目前的状态。
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //说明：当应用从后台将要重新回到前台时候调用，可以在这里恢复数据，或刷新界面。
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //说明：当应用程序获取到焦点后
}


- (void)applicationWillTerminate:(UIApplication *)application {
    //说明：当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值（自动设置）。不支持多任务的时候调用
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
//说明：iPhone设备只有有限的内存，如果为应用程序分配了太多内存操作系统会终止应用程序的运行，在终止前会执行这个方法，通常可以在这里进行内存清理工作防止程序被终止
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
//说明：当系统时间发生改变时执行
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
//说明：当应用加载完成后被调用
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
//说明：当StatusBar将要变化时执行
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //说明：打开url时
    return nil;
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    //说明：当StatusBar框方向变化完成后执行
}

- (void)application:(UIApplication *)application didChangeSetStatusBarFrame:(CGRect)oldStatusBarFrame {
    //说明：当StatusBar框变化完成后执行
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //处理返回支付结果
    [[EzfMpAssist defaultAssist] handlePaymentResult:url];
    return YES;

}

@end
