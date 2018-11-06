//
//  LYH_PushService.m
//  testApns
//
//  Created by lee on 2018/11/5.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "LYH_PushService.h"
#import <UserNotifications/UserNotifications.h> // 导入通知的库

@interface LYH_PushService () 
<
UNUserNotificationCenterDelegate
>
@end


@implementation LYH_PushService

#pragma mark - lifeCycle
- (instancetype)init{
    if (self = [super init]) {
        //code here...
    }
    return self;
}
+ (instancetype)defaultPushService{
    static LYH_PushService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc]init];
    });
    return instance;
}

#pragma mark - customMethod 《自定义方法》 start
- (void)Lyh_PushService_registNotification:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"推送注册成功");
            }
        }];
        [application registerForRemoteNotifications];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10) {//iOS8-iOS10
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else { //iOS8以下
        
        //        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
}
#pragma mark  customMethod 《自定义方法》 end

#pragma mark - 注册和授权
- (BOOL)LYH_PushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0f) {
        //iOS10-
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            //判断
        }];
    }else if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f){
        //iOS8-iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }else{
        //iOS8以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册远程推送通知 (获取DeviceToken)
    [application registerForRemoteNotifications];
    
    //这个是应用未启动但是通过点击通知的横幅来启动应用的时候
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        //如果有值，说明是通过远程推送来启动的
        //code here...
    }
    
    return YES;
}

//处理从后台到前台后的角标处理
-(void) LYH_BecomeActive:(UIApplication *)application{
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber = 0;
    }
}

#pragma mark - 远程推送的注册结果的相关方法
////成功
//- (void)LYH_PushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{   //获取设备相关信息
//    //获取设备的UUID
//    NSLog(@"")
//    NSString *deviceUuid;
//    UIDevice *dev = [UIDevice currentDevice];
//    NSString *deviceName = dev.name;
//    NSString *deviceModel = dev.model;
//    NSString *deviceSystemVersion = dev.systemVersion;
//    UIDevice *myDevice = [UIDevice currentDevice];
//    NSString *deviceUDID = [myDevice identifierForVendor].UUIDString;
//    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    
//    //获取用户的通知设置状态
//    NSString *pushBadge= @"disabled";
//    NSString *pushAlert = @"disabled";
//    NSString *pushSound = @"disabled";
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
//        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
//        if (UIUserNotificationTypeNone == setting.types) {
//            NSLog(@"推送关闭");
//        }else{
//            NSLog(@"推送打开");
//            pushBadge = (setting.types & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
//            pushAlert = (setting.types & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
//            pushSound = (setting.types & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";
//        }
//    }else{
//        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        if(UIRemoteNotificationTypeNone == type){
//            NSLog(@"推送关闭");
//        }else{
//            NSLog(@"推送打开");
//            pushBadge = (type & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
//            pushAlert = (type & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
//            pushSound = (type & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";
//        }
//    }
//    
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    id uuid = [defaults objectForKey:@"deviceUuid"];
//    if (uuid)
//        deviceUuid = (NSString *)uuid;
//    else {
//        CFStringRef cfUuid = CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
//        deviceUuid = (NSString *)CFBridgingRelease(cfUuid);
//        NSLog(@"%@",deviceUuid);
//        NSLog(@"%@",deviceUuid);
//        [defaults setObject:deviceUuid forKey:@"deviceUuid"];
////        [defaults release];
//    }
//    
//    
//    
//    NSString *deviceTokenString = [[[[deviceToken description]
//                                     stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                                    stringByReplacingOccurrencesOfString:@">" withString:@""]
//                                   stringByReplacingOccurrencesOfString: @" " withString: @""];
//    
//    NSString *host = @"http://www.baidu.com";//你们自己后台服务器的地址
//    
//    //时间戳
//    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
//    NSInteger time = interval;
//    NSString *timestamp = [NSString stringWithFormat:@"%zd",time];
//    
//    //MD5校验
//    NSString *md5String = [NSString stringWithFormat:@"%@%@%@",deviceTokenString,deviceUDID,timestamp];
//    NSString *credential = [Util encodeToMd5WithStr:md5String];
//    
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@?device_token=%@&device_uuid=%@&device_name=%@&device_version=%@&app_name=%@&timestamp=%@&push_badge=%@&push_alert=%@&push_sound=%@&credential=%@", host, deviceTokenString, deviceUDID, deviceModel, deviceSystemVersion, appName, timestamp, pushBadge, pushAlert, pushSound, credential];
//    
//    //打印值看一下，是否正确，当然打印的可以用一个宏判断一下
////    NSLog(@"😊😊%@", host);
////    NSLog(@"😊😊%@", gameId);
////    NSLog(@"😊😊%@", deviceTokenString);
////    NSLog(@"😊😊%@", deviceUDID);
////    NSLog(@"😊😊%@", deviceModel);
////    NSLog(@"😊😊%@", deviceSystemVersion);
////    NSLog(@"😊😊%@", appName);
////    NSLog(@"😊😊%@", timestamp);
////    NSLog(@"😊😊%@", pushBadge);
////    NSLog(@"😊😊%@", pushAlert);
////    NSLog(@"😊😊%@", pushSound);
////    NSLog(@"😊😊%@", credential);
////    NSLog(@"😊😊%@", urlString);
//    
//    //以下是发送DeviceToken给后台了，有人会问，为什么要传这么多参数，这个具体根据你们后台来哈，不要问我，问你们后台要传什么就传什么，但是DeviceToken是一定要传的
//    NSURL *url = [NSURL URLWithString:urlString];
//    if (!url) {
//        NSLog(@"传入的URL为空或者有非法字符,请检查参数");
//        return;
//    }
//    NSLog(@"%@",url);
//    
//    //发送异步请求
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setTimeoutInterval:5.0];
//    [request setHTTPMethod:@"GET"];
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//            if (httpResponse.statusCode == 200 && data) {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                if (dict && [dict[@"ret"] integerValue] == 0) {
//                    NSLog(@"上传deviceToken成功！deviceToken dict = %@",dict);
//                }else{
//                    NSLog(@"返回ret = %zd, msg = %@",[dict[@"ret"] integerValue],dict[@"msg"]);
//                }
//            }else if (error) {
//                NSLog(@"请求失败，error = %@",error);
//            }
//        });
//    }];
//    [task resume];
//}
//
////失败
//- (void)LYH_PushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//    NSLog(@"注册推送失败，error = %@", error);
//    //failed fix code here...
//}
//
//#pragma mark - 收到远程推送通知的相关方法
////iOS6及以下(前台是直接走这个方法不会出现提示的，后台是需要点击相应的通知才会走这个方法的)
//- (void)LYH_PushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    [self LYH_PushApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
//}
//
////iOS7及以上
//- (void)LYH_PushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    NSLog(@"%@", userInfo);
//    
//    
//    //注意HomeScreen上一经弹出推送系统就会给App的applicationIconBadgeNumber设为对应值
//    if (application.applicationIconBadgeNumber > 0) {
//        application.applicationIconBadgeNumber = 0;
//    }
//    
//    
//    
//    NSLog(@"remote notification: %@",[userInfo description]);
//    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
//    
//    NSString *alert = [apsInfo objectForKey:@"alert"];
//    NSLog(@"Received Push Alert: %@", alert);
//    NSString *sound = [apsInfo objectForKey:@"sound"];
//    NSLog(@"Received Push Sound: %@", sound);
//    NSString *badge = [apsInfo objectForKey:@"badge"];
//    NSLog(@"Received Push Badge: %@", badge);
//    
//    //这是播放音效
////    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    
//    //处理customInfo
//    if ([userInfo objectForKey:@"custom"] != nil) {
//        //custom handle code here...
//    }
//    completionHandler(UIBackgroundFetchResultNoData);
//}




@end
