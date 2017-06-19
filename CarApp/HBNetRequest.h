//
//  HBNetRequest.h
//  CarApp
//
//  Created by 管理员 on 2016/11/29.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^ComoleteCallBack)(id data);//请求完成时调用
typedef void (^FailureCallBack)(NSError *error);//
@interface HBNetRequest : NSObject
//功能：get方式请求数据
//参数：urlString 网址
//     paras 一个字典，请求参数
//     complete 请求完成时的回调
//     failure  请求出错的回调
//返回值：无
+ (void)Get:(NSString *)urlString para:(id)paras complete:(ComoleteCallBack)complete fail:(FailureCallBack)failure;

//功能：post方式请求数据
//参数：urlString 网址
//     paras 一个字典，请求参数
//     complete 请求完成时的回调
//     failure  请求出错的回调
//返回值：无
+ (void)Post:(NSString *)urlString para:(id)paras complete:(ComoleteCallBack)complete fail:(FailureCallBack)failure;
+ (void)postWithImage:(UIImage *)Image Url:(NSString *)url params:(NSDictionary *)params successBlock:(void(^)(id responseObject))completion Failure:(FailureCallBack)failureBlock;
@end
