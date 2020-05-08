//
//  ViewController.m
//  DeadLockTest
//
//  Created by 安仲强 on 2020/4/9.
//  Copyright © 2020 安仲强. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self mainThreadDeadLockTest];
    
//    [self mainThreadDeadLockTest2];
    
//    [self deadLockTest];
    // Do any additional setup after loading the view.
}
//常见的死锁1
- (void)mainThreadDeadLockTest {
    NSLog(@"begin");
    dispatch_sync(dispatch_get_main_queue(), ^{
        // 发生死锁下面的代码不会执行
        NSLog(@"middle");
    });
    // 发生死锁下面的代码不会执行，当然函数也不会返回，后果也最为严重
    NSLog(@"end");
}
//这种情况不会死锁，因为创建的串行队列跟主队列不是同一个串行队列！！
- (void)mainThreadDeadLockTest2 {
    NSLog(@"begin");
    dispatch_queue_t series = dispatch_queue_create("com.series", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(series, ^{
        
        NSLog(@"middle");
    });
    
    NSLog(@"end");
}
//常见的死锁2
- (void)deadLockTest {
    // 其它线程的死锁
    dispatch_queue_t serialQueue = dispatch_queue_create("serial_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        // 串行队列block1
        NSLog(@"begin");
        dispatch_sync(serialQueue, ^{
            // 串行队列block2 发生死锁，下面的代码不会执行
            NSLog(@"middle");
        });
        // 不会打印
        NSLog(@"end");
    });
    // 函数会返回，不影响主线程
    NSLog(@"return");
}
@end
