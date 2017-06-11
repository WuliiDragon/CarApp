//
//  HBAuxiliary.m
//  CarApp
//
//  Created by 管理员 on 2016/11/29.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBAuxiliary.h"
#import <MapKit/MapKit.h>

@implementation HBAuxiliary
+(NSString *)makeprice:(NSString *)str{
    if(str==nil){
        return @"";
    }
    return [NSString stringWithFormat:@"%.2f", [str floatValue]];
}
#pragma mark - 保存到本地
+ (void)SaveToLocal :(id)data path:(NSString *)str {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary *dict in data) {
        [array addObject:dict];
    }
    //保存到.plist文件里
    NSString *name = [[NSString stringWithFormat:@"%@",str] stringByAppendingFormat:@"%@",@".plist"];
    [array writeToFile:[kDocumentPath stringByAppendingPathComponent:name] atomically:YES];
}
+(NSString*) distance :(NSString *)distance {
    NSInteger intDistance = [distance integerValue];
    if(intDistance>1000){
        return  [NSString stringWithFormat:@"%.1f km",(float)intDistance/1000];
        
    }else{
        return  [NSString stringWithFormat:@"%ld m",(long)intDistance];
    }
}


#pragma mark - 获取本地数据
+ (id)LoadFromLocalpath :(NSString *)str {
    //先清空数组里的元素
    NSString *name = [[NSString stringWithFormat:@"%@",str] stringByAppendingFormat:@"%@",@".plist"];
    //获取本地数据,放到数组里
    id object = [NSMutableArray arrayWithContentsOfFile:[kDocumentPath stringByAppendingPathComponent:name]];
    return object;
}


+ (UIImage*)saImageWithSingleColor:(UIColor *)color{
    UIGraphicsBeginImageContext(CGSizeMake(1.0f, 1.0f));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(void)alertWithTitle:(NSString *)title message:(NSString *)message button:(NSUInteger)buttons done:(void (^)())act{
    //创建一个新窗口 用于显示警告框
    UIApplication* application = [UIApplication sharedApplication];
    UIWindow* oldWindow = application.keyWindow;
    UIWindow* Window = [[UIWindow alloc]initWithFrame:oldWindow.frame];
    Window.backgroundColor = [UIColor clearColor];//背景色透明
    
    //实例化一个控制器 用于弹出警告框
    UIViewController* VC = [[UIViewController alloc]init];
    VC.view.backgroundColor = [UIColor clearColor];
    Window.rootViewController = VC;
    
    //实例化警告框
    UIAlertController* AlertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //确定按钮
    UIAlertAction* OKButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(act){
            act();
        }
        [oldWindow makeKeyAndVisible];
    }];
    [AlertC addAction:OKButton];
    //若传入2表示两个窗口添加一个取消窗口
    if (buttons==2) {
        UIAlertAction* CancleButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [AlertC addAction: CancleButton];
    }
    //显示新增窗口
    [Window makeKeyAndVisible];
    //弹出警告框
    [VC presentViewController:AlertC animated:YES completion:nil];
}

+(void)alertWithTitle:(NSString *)title message:(NSString *)message button:(NSUInteger)buttons inController:(UIViewController*)controller done:(void (^)())act{
    UIAlertController* AlertController = [UIAlertController alertControllerWithTitle:@"确定" message:message preferredStyle:UIAlertControllerStyleAlert];
    //确定按钮
    UIAlertAction* OKButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(act){
            act();
        }
    }];
    [AlertController addAction:OKButton];
    
    //若传入2表示两个窗口添加一个取消窗口
    if (buttons==2) {
        UIAlertAction* CancleButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction: CancleButton];
    }
    //显示新增窗口
    //弹出警告框
    [controller presentViewController:AlertController animated:YES completion:nil];
    
}
+(void) alertWithTitle:(NSString*)title message:(NSString*)message button:(NSArray*)buttons done:(void (^)())agree cancel:(void (^)())disagree{
    //创建一个新窗口，用于显示警告框
    UIApplication * application = [UIApplication sharedApplication];
    UIWindow * oldWindow = application.keyWindow;
    UIWindow *window = [[UIWindow alloc] initWithFrame:oldWindow.bounds];
    window.backgroundColor = [UIColor clearColor];//窗口的背景颜色
    //实例化一个控制器，用于弹出警告框
    UIViewController * controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = [UIColor clearColor];
    window.rootViewController = controller;
    //实例化警告框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //第一个按钮
    UIAlertAction * btn1 = [UIAlertAction actionWithTitle:buttons[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(agree){
            agree();
            [oldWindow makeKeyAndVisible];
        }
    }];
    [alertController addAction:btn1];
    //第一个按钮
    UIAlertAction * btn2 = [UIAlertAction actionWithTitle:buttons[1] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(disagree){
            disagree();
            [oldWindow makeKeyAndVisible];
        }
    }];
    [alertController addAction:btn2];
    //显示新增窗口
    [window makeKeyAndVisible];
    
    //弹出警告框
    [controller presentViewController:alertController animated:YES completion:nil];
    
}
//转场动画
+ (CATransition *)transitWithProperties:(NSDictionary *)propertites
{
    __autoreleasing CATransition *transition = [CATransition animation];
    NSString *type = propertites[@"type"];
    transition.type = type ? type:@"fade";
    
    NSString *subType = propertites[@"subType"];
    transition.subtype = subType ? subType : kCATransitionFromRight ;
    NSString *duration = propertites[@"duration"];
    transition.duration = duration ? [duration floatValue]:1.0;
    
    NSString *timimgFountion = propertites[@"timimgFountion"];
    CAMediaTimingFunction *tf = nil;
    if(timimgFountion)
    {
        tf = [CAMediaTimingFunction functionWithName:timimgFountion];
    }
    transition.timingFunction = tf ? tf :UIViewAnimationCurveEaseInOut;
    
    NSString *fillMode = propertites[@"fileMode"];
    transition.fillMode = fillMode ? fillMode : @"removed";
    
    return transition ;
}
//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//用户名
+ (BOOL) validateUserName:(NSString *)name rule:(NSString*)rule
{
    NSString *userNameRegex;
    
    //默认规则用户名由大小写26个英文字母和数组组成，长度6-20位
    if (!rule) {
        userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    }
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:name];
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord  rule:(NSString*)rule
{
    NSString *passWordRegex;
    if (!rule) {//默认验证规则由大小写26个英文字母和数组组成，长度6-20位
        passWordRegex= @"^[a-zA-Z0-9]{6,20}+$";
    }
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

+ (BOOL) validatePassword:(NSString *)passWord{
    
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:passWord];
    
}

//身份证号码正则表达式
+(BOOL)validateIdentityCard:(NSString *)identityCard{
    BOOL flag;
    if(identityCard.length==0){
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
+(UIColor *) colorWithHexString: (NSString *)color{
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

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate{
    //设置源日期时期
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //设置转换后的目标日期时区
    NSTimeZone *destinationZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准实践的偏移量
    NSInteger soureGEMOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGEMOffset = [destinationZone secondsFromGMTForDate:anyDate];
    //现在时间偏移量的差值
    NSTimeInterval  intercal = destinationGEMOffset - soureGEMOffset;
    //转为现在的时间
    __autoreleasing NSDate* destinaDateNow = [[NSDate alloc] initWithTimeInterval:intercal sinceDate:anyDate];
    return destinaDateNow;
}


+(NSString *)removeSpace:(NSString *)str{
    NSMutableString *strM = [NSMutableString stringWithString:str];
    [strM replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, strM.length)];
    return [strM copy];
}







+(void)saveCookie{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [defaults setObject: cookiesData forKey: @"Cookies"];
    [defaults synchronize];
}

+(NSHTTPCookieStorage*)getCookies{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"Cookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    return cookieStorage;
}


+(void)loadCookies{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: @"Cookies"];
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    
}



+(NSMutableArray *)loopaimage :(NSArray *) imgurlArr{
    NSMutableArray *imgarr = [[NSMutableArray alloc]init];
    NSString *str = mainUrl;
    for (NSString *Urlstr in imgurlArr) {
        NSString *url = [str stringByAppendingFormat:@"%@",Urlstr];
        [imgarr addObject:url];
    }
    return imgarr;
    
}




+(void)turnToMapWithLatitude :(NSString *)toLatitude ToLongitude :(NSString *)toLongitude addressName:(NSString *)address{
    DEFAULTS
    NSString *curLatitude  =  [defaults objectForKey:@"latitude"];
    NSString *curLongitude  =[defaults objectForKey:@"longitude"];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){//手写用高德
        
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=行吧&backScheme=com.dragonChina.CarApp&lat=%@&lon=%@&dev=0&style=0",
                                toLatitude,
                                toLongitude
                                ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         
                                     }];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }
        
    }else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {//百度
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%@,%@&destination=latlng:%@,%@|name:%@&mode=driving&src=dangdang://&coord_type=gcj02",
                                curLatitude,
                                curLongitude,
                                toLatitude,
                                toLongitude,
                                address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }else {//自带
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([toLatitude floatValue], [toLongitude floatValue]);
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
                [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                               MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    
    }
    
    
    
    //        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([_models.latitude floatValue], [self.models.longitude floatValue]);
    //        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    //        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:@{@"name":@"name"}]];
    //        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
    //                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    //                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    //
    
    
    //   NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"行/吧",urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    
    
    //            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%@,%@&destination=latlng:%@,%@|name:%@&mode=driving&src=dangdang://&coord_type=gcj02",
    //                                    [defaults objectForKey:@"latitude"],
    //                                    [defaults objectForKey:@"longitude"],
    //                                    _models.latitude,
    //                                    _models.longitude,
    //                                    _models.baddress
    //                                    ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    
    
    //        NSURL *myLocationScheme = [NSURL URLWithString:@"baidumap://map/marker?location=40.047669,116.313082&title=我的位置&content=百度奎科大厦&src=webapp.marker.yourCompanyName.yourAppName"];
    //        if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) {//iOS10以后,使用新API
    //            [[UIApplication sharedApplication] openURL:myLocationScheme options:@{}
    //                                     completionHandler:^(BOOL success) {
    //                                         NSLog(@"scheme调用结束");
    //
    //
    //                                     }]; }
    //        else {
    //            //iOS10以前,使用旧API
    //            [[UIApplication sharedApplication] openURL:myLocationScheme];
    //        }
    

}
+(UIWebView *)turnTOPhoneWithNumBer:(NSString *)telStr{

    UIWebView *callWebView = [[UIWebView alloc] init];
    NSURL *telURL          = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telStr]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    return callWebView;
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}





+ (NSDictionary*)getObjectData:(id)obj {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0;i < propsCount; i++) {
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil) {
            
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}

+ (id)getObjectInternal:(id)obj {
    
    if([obj isKindOfClass:[NSString class]]
       ||
       [obj isKindOfClass:[NSNumber class]]
       ||
       [obj isKindOfClass:[NSNull class]]) {
        
        return obj;
        
    }
    if([obj isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0; i < objarr.count; i++) {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
    
}



@end
