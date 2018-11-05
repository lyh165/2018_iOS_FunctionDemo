#import "ViewController.h"
#import <UserNotifications/UserNotifications.h> // 导入通知的库
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 去推送本地通知
 */
- (IBAction)go2PushLocalDelivery:(UIButton *)sender
{
    [self custom_sendLocalDelivery];
}

- (void)custom_sendLocalDelivery
{
    // 10系统以上
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        // 1.设置触发条件
        UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:.5f repeats:NO];
        // 2.创建通知内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"标题1";
        content.subtitle = @"副标题";
        content.body = @"我是lyh";
        content.badge = @([UIApplication sharedApplication].applicationIconBadgeNumber + 1);
        content.sound = [UNNotificationSound defaultSound];
        NSString *detail = @"其实他是假lyh";
        // 封装推送的信息
        content.userInfo = @{
                             @"detail":detail
                             };
        // 3.通知标识
        NSString *requestIdentifier = [NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]];
        // 4.创建通知请求，将1，2，3添加到请求中
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
        // 5.将通知请求添加到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
            if (!error)
            {
                NSLog(@"推送已经添加成功");
            }
        }];
    } else { // iOS10以下
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"我是lyh";
        notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        notification.soundName = UILocalNotificationDefaultSoundName;
        NSString *detail = @"其实他是假lyh";
        notification.userInfo = @{
                                  @"detail":detail
                                  };
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 执行此代码之前进入后台
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        });
    }
}

@end
