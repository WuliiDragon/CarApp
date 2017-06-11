//
//  HBAuxiliary.h
//  CarApp
//
//  Created by 管理员 on 2016/11/29.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HBAuxiliary : NSObject
+ (BOOL)DeviceIsIOS8orLater;
+ (BOOL)DeviceIsIpone6orLater;
+ (UIImage*)saImageWithSingleColor:(UIColor *)color;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message button:(NSUInteger)buttons done:(void(^)())act;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message button:(NSArray *)buttons done:(void (^)())agree cancel:(void(^)())disagree;

+ (CATransition *)transitWithProperties:(NSDictionary *)propertites;

+ (CGFloat)dynamicHeightWithString:(NSString *)string width:(CGFloat)width attribute:(NSDictionary *)attrs;

+ (void)layerCornerRadius:(CALayer *)dest radius:(float)radius width:(float)width color:(UIColor *)color;

+ (BOOL)validateUserName:(NSString *)name rule:(NSString *)rule;

+ (BOOL)validateMobile:(NSString *)mobile;

+ (BOOL)validateIdentityCard:(NSString *)identityCard;
+ (BOOL) validatePassword:(NSString *)passWord  rule:(NSString*)rule;
+ (BOOL) validatePassword:(NSString *)passWord;




+ (BOOL)validateEmail:(NSString *)email;
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+(UIColor *) colorWithHexString: (NSString *)color;
+ (id)LoadFromLocalpath :(NSString *)str ;
+ (void)SaveToLocal :(id)data path :(NSString *)str ;
+(NSString*) distance :(NSString *)distance;
+(NSString *)makeprice:(NSString *)str;
+(NSString *)removeSpace:(NSString *)str;


//cookie相关
+(void)saveCookie;
+(NSHTTPCookieStorage*)getCookies;
+(void)loadCookies;



+(NSMutableArray *)loopaimage :(NSArray *) imgurlArr;



+(void)turnToMapWithLatitude :(NSString *)toLatitude ToLongitude :(NSString *)toLongitude addressName:(NSString *)address;
+(UIWebView *)turnTOPhoneWithNumBer:(NSString *)telStr;



+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary*)getObjectData:(id)obj ;
@end
