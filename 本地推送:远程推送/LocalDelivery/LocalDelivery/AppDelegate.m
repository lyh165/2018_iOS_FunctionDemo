/*
 本项目的功能: 《本地推送》
 参考 https://www.jianshu.com/p/e770cebc86b6
 收到消息的内容 https://www.jianshu.com/p/b27a3a99652b
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


#pragma mark - delegate start
//#pragma mark - iOS10-UNUserNotificationCenterDelegate
// 弹出通知
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

//- didno

// 点击通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSLog(@"点击了推送");
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"--ios10 官方-后台收到push通知：%@",userInfo);
        
    }else{
        NSLog(@"--ios10 官方-后台收到本地通知:{\n body：%@,\n title:%@,subtitle:%@,badge:%@,\nsound:%@,\nuserinfo:%@\n}",response.notification.request.content.body,response.notification.request.content.title,response.notification.request.content.subtitle, response.notification.request.content.badge,response.notification.request.content.sound,userInfo);
        
    }
    
    //
    completionHandler();
}

#pragma mark delegate end



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


//
//


#pragma mark - 点击了远程通知
/*
 // iOS 6 之前的远程通知点击
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
 // 取得 APNs 标准信息内容
 NSDictionary *aps = [userInfo valueForKey:@"aps"];
 NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
 NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
 NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
 
 // 取得Extras字段内容
 NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
 NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
 
 }
 // iOS 7 之后的远程通知点击
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)   (UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"this is iOS7 Remote Notification");
    
    // iOS 10 以下 Required
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        //iOS10以下的通知处理代码
        return;
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
*/



@end
