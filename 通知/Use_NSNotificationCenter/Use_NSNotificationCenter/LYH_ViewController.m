//
//  LYH_ViewController.m
//  Use_NSNotificationCenter
//
//  Created by lee on 2018/11/7.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "LYH_ViewController.h"

@interface LYH_ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf_sendNotificationContent;

@end

@implementation LYH_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
// 2、发送通知
- (IBAction)sendNotification:(UIButton *)sender {
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.tf_sendNotificationContent.text,@"kNotificationName_Value",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationName object:nil userInfo:dict];
    // 发送完通知之后，并且回退到之前的界面
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
