//
//  HBRootViewController.h
//  CarApp
//
//  Created by 管理员 on 2016/11/30.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBNetRequest.h"
#import "HBAuxiliary.h"
@interface HBRootViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *dataSource;

- (void)request:(NSString *)method url:(NSString *)urlString para:(NSDictionary *)dict;

- (void)showHub:(BOOL)show;

-(void) parserData:(id)data;

//- (void)pushNextWithType:(NSString *)type Subtype:(NSString *)subtype Viewcontroller:(UIViewController *)viewController;

@end
