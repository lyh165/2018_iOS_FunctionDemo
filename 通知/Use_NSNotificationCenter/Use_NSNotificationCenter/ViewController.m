//
//  ViewController.m
//  Use_NSNotificationCenter
//
//  Created by lee on 2018/11/7.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "ViewController.h"
#import "LYH_ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_notificationBlockStr;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //1、注册通知：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ListeningNotificationMethod:) name:kNotificationName object:nil];
}
// 2、发送通知
- (IBAction)go2SendNotificationVC:(UIButton *)sender {
    [self presentViewController:[LYH_ViewController new] animated:YES completion:nil];
}

// 3、实现监听方法
-(void)ListeningNotificationMethod:(NSNotification *)notification
{
    NSString *notificationBlockStr = notification.userInfo[@"kNotificationName_Value"];
    NSLog(@"传递给来的数据 是 %@",notificationBlockStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lb_notificationBlockStr.text = [NSString stringWithFormat:@"step_3、LYH_ViewController通知过来的值: %@",notificationBlockStr];
    });
}

- (IBAction)RemoveNotication:(UIButton *)sender {
    NSLog(@"%s,关闭界面并且移除通知",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationName object:self];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationName object:self];
}

@end
