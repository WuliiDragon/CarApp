//
//  EzfMpAssist.h
//  AppDemo
//
//  Created by jspt on 14-10-25.
//  Copyright (c) 2014年 ronglian. All rights reserved.
/**
 * 定义支付结果回调block
 * @param result 支付结果 Y:支付成功;N:支付失败;C:支付取消;D处理中；
 * 
 */
typedef void (^PaymentResultBlock)(NSString *result);

/**
 * 支付接口
 */
@interface EzfMpAssist : NSObject <UIAlertViewDelegate>

/**
 * 获取支付插件实例
 * @return EzfMpAssist
 */
+ (EzfMpAssist *)defaultAssist;

/**
 * 启动支付
 * @param tn 流水号
 * @param schemeStr appscheme
 * @param mode 环境类型
 * @param mUIViewController 调用的controller
 * @param completionBlock 回调方法
 */
- (void)startPay:(NSString *)tn fromScheme:(NSString *)schemeStr mode:(NSString *)mode viewController:(UIViewController *)mUIViewController completeBlock:(PaymentResultBlock)completionBlock;

/**
 * 拦截解析支付结果
 * @param url 回调url
 */
- (void)handlePaymentResult:(NSURL *)url;

/**
 * 注册微信appid
 * @param appid 微信appid
 */
- (void)regWechatApp:(NSString *)appid;

@end
