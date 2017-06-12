//
//  HBNetRequest.m
//  CarApp
//
//  Created by 管理员 on 2016/11/29.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBNetRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation HBNetRequest
+ (void)Get:(NSString *)urlString para:(id)paras complete:(ComoleteCallBack)complete fail:(FailureCallBack)failure {
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];


    [manage.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manage.requestSerializer.timeoutInterval = 8.f;
    [manage.requestSerializer didChangeValueForKey:@"timeoutInterval"];


    //manage.responseSerializer.acceptableContentTypes =  [manage.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //manage.responseSerializer.acceptableContentTypes= [NSSet setWithObject:@"text/html"];

    // AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    // [manage setRequestSerializer:jsonRequestSerializer];

    [manage GET:urlString parameters:paras progress:^(NSProgress *_Nonnull downloadProgress) {
    }   success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (complete) complete(responseObject);//调用block将请求数据返回
    }   failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        if (failure) failure(error);//将错误信息返回
    }];
}

+ (void)Post:(NSString *)urlString para:(id)paras complete:(ComoleteCallBack)complete fail:(FailureCallBack)failure {


    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];

    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manage.responseSerializer = [AFHTTPResponseSerializer serializer];



    [manage POST:urlString parameters:paras progress:^(NSProgress *_Nonnull uploadProgress) {
    }    success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {


        if (complete) complete(responseObject);
    }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {


        if (failure) failure(error);//将错误信息返回
    }];


}

@end
