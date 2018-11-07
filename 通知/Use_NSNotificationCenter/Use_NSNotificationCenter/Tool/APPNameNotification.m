#import "APPNameNotification.h"

NSString *const kNotificationName = @"kNotificationName";



@implementation APPNameNotification
@end



/**
 NSString *const 和 const NSString * 的区别
 https://www.cnblogs.com/wobuyayi/p/8074592.html
 
 由于NSString是指针变量，
 因此只要保证NSString类型的《变量存储的指针不可变》就可以《定义一个不可更改的NSString变量》，
 定义方法： NSString *const str = @"111";
 */
