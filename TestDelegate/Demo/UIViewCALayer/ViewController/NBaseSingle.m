//
//  NBaseSingle.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/13.
//  Copyright © 2018 a. All rights reserved.
//

#import "NBaseSingle.h"
@interface NBaseSingle ()
@property(nonatomic,readwrite, retain)dispatch_source_t timer;
@property (nonatomic, copy) dispatch_block_t block;
@end

@implementation NBaseSingle

static NBaseSingle *instance = nil;

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


- (void)creatTimerWithBlock:(dispatch_block_t )block
{
    if (self.timer) {
        [self cancleTimer];
    }
    self.block = block;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //定时间隔时间
    uint64_t nsec = (uint64_t)(5 * NSEC_PER_SEC);
    //给定时器源设置一个时间，这个时间就是间隔执行的时间
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, nsec), nsec, 0);
    //给定时器源设置一个定时器触发时要执行的代码块
    dispatch_source_set_event_handler(timer, ^{
        self.block();
        [self sendHeart];
    });
    //开始定时器
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)sendHeart
{
    NSLog(@"发送心跳");
}

- (void)cancleTimer
{
    if (self.timer) {
        NSLog(@"取消定时器");
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    self.block = nil;
}

@end
