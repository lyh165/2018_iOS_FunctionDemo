/*
 本项目的功能: 《远程推送》
 
 参考 https://www.jianshu.com/p/2c8cf1ccf625
 将注册成功的devicetoken 转成字符串 https://blog.csdn.net/wangzhen3416/article/details/52137120?locationNum=6&fps=1
 
 测试工具
    1、Easy APNs Provider (直接从AppStore下载)
    2、https://github.com/shaojiankui/SmartPush
 */


/**
 控制台警告信息
 but you still need to add "remote-notification" to the list of your supported UIBackgroundModes in your Info.plist.
 https://www.jb51.net/article/93136.htm
 
>>>>>>>>> 在项目 打开background modes 开启remote Notifications

 */
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h> // 导入通知的库

@interface AppDelegate ()
<
UNUserNotificationCenterDelegate
>
//遵循通知的协议
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self custom_registNotification:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

#pragma mark - customMethod start
/**
 注册通知
 */
- (void)custom_registNotification:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
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

#pragma mark  customMethod end

#pragma mark - NotificationDelegate start
// 注册通知成功之后,获取设备的唯一标识 deviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"注册推送成功并且获取device token %@",deviceToken);
    // 将 devicetoken上传到服务器
    
    /*
     // 获取devicetoken 二进制文件
     NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
     NSString* totalPath = [documentPath stringByAppendingPathComponent:@"aa"];
     [deviceToken writeToFile:totalPath atomically:NO];
     YHLog(@"--- devicetoken %@",deviceToken);
     YHLog(@"--- totalPath %@",totalPath);
     YHLog(@"--- documentPath %@",documentPath);
     */
    
    /**
     */
    // 方式1
    NSMutableString *deviceTokenString1 = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    int iCount = deviceToken.length;
    for (int i = 0; i < iCount; i++) {
        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    NSLog(@"方式1：%@", deviceTokenString1);
    // 方式2
    NSString *deviceTokenString2 = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"方式2：%@", deviceTokenString2);
    
    
}
// 注册推送失败的时候
//注冊消息推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册推送失败 : {%@}",error);
}

#pragma mark 弹出、点击通知
// 弹出通知的信息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSLog(@"弹出通知");
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"--ios10 官方-前台收到push通知：%@",userInfo);
        
    }else{
        
        NSLog(@"--ios10 官方-前台收到本地通知:{\n body：%@,\n title:%@,subtitle:%@,badge:%@,\nsound:%@,\nuserinfo:%@\n}",notification.request.content.body,notification.request.content.title,notification.request.content.subtitle, notification.request.content.badge,notification.request.content.sound,userInfo);
    }
    
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

// 收到推送的时候 (iOS7之后才会调用这个方法)
// iOS 7 之后的远程通知点击
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)   (UIBackgroundFetchResult))completionHandler {
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
//    NSString *customizeField1 = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSString *customizeField1 = [userInfo valueForKey:@"acme2"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    

    
    
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark  NotificationDelegate end


@end
