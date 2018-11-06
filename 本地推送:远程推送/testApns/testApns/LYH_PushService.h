/*
 本类是用来 : 《封装 苹果远程推送方法的》
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LYH_PushService : NSObject
// 创建单例
+ (instancetype)defaultPushService;


- (void)Lyh_PushService_registNotification:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

//这个是为了在HomeScreen点击App图标进程序
- (void)LYH_BecomeActive:(UIApplication *)application;

//注册成功得到deviceToken
- (void)LYH_PushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
//注册失败报错
- (void)LYH_PushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

//这是处理发送过来的推送
- (void)LYH_PushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)LYH_PushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end
