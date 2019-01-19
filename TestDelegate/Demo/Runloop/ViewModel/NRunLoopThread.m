//
//  NRunLoopThread.m
//  TestDelegate
//
//  Created by 泽娄 on 2019/1/19.
//  Copyright © 2019 a. All rights reserved.
//

/// https://www.jianshu.com/p/58f44609bd50

#import "NRunLoopThread.h"
#import "NRunLopp.h"

/*
 实现这种模型的关键点在于：如何管理事件/消息，如何让线程在没有处理消息时休眠以避免资源占用、在有消息到来时立刻被唤醒。
 */


@interface NRunLoopThread ()<NRunLoppDelegate>{
    NRunLopp *_runloop;
    NSMutableArray *_commands;
}
@end


@implementation NRunLoopThread

static NRunLoopThread *instance = nil;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"subThread";
        _commands = [NSMutableArray array];
        _runloop = [[NRunLopp alloc] initWithDelegate:self];
    }return self;
}

/*
 Worker 让 CPU 几乎满了 😂，看来 Worker 轮询消息队列的方式有很大的性能问题。回看 Worker 中这样的代码：
 
 下面代码作用就是采用轮询的方式不断的向消息队列询问是否有新消息到达。这样的模式会有一个严重的问题：如果在很长一段时间内用户并没有输入新的 command，子线程还是会不断的轮询，就是因为这些不断的轮询导致 CPU 资源被占满。
 Worker 不断轮询消息队列的模式已经被我们证明是具有性能问题的了，那么是不是可以换一种思路？如果可以让 Main 和 Worker 的协作变为这样：
 
 Main 不断地接收到用户输入，将输入放到消息队列中，然后通知 Worker 说『Wake up，你有新的任务需要处理』
 Worker 开始处理消息队列中任务，任务处理完成之后，自动进入休眠，不再继续占用 CPU 资源，直到接收到下一次 Main 的通知
 
 作者：hsy0
 链接：https://juejin.im/post/5c400361518825258124f26b
 来源：掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */

- (void)main
{
    NSLog(@"[Worker] is running...");
    // 往 RunLoop 中添加 run loop source
    // 我们的 Main 会通过 rls 和 Worker 协调工作
    if (_runloop) {
        [_runloop run];
    }
    NSLog(@"[Worker] is stopping...");
}


// 告诉 Worker 任务来了
// 把 Worker 拎起来干事
- (void)notifyWakeUp
{
    [_runloop notifyWakeUp];
}


#pragma mark private method

/// 添加元素
- (void)pushCommand:(NSString *)command
{
    if ([command length] == 0) {
        return;
    }
    @synchronized (_commands) {
        [_commands addObject:command];
    }
}

/// 获取元素
- (NSString *)popCommand
{
    @synchronized (_commands) {
        NSString *last = [_commands lastObject];
        [_commands removeLastObject];
        return last;
    }
}

#pragma mark NRunLoppDelegate
- (void)runLoop:(NRunLopp *)runLoop
{
    NSString *last = [self popCommand];

    while (last) {
        NSLog(@"[Worker] executing command: %@", last);
        sleep(0.5); // 模拟耗时的计算所需的时间
        NSLog(@"[Worker] executed command: %@", last);
        last = [self popCommand];

        if (self.blcok) {
            self.blcok(last);
        }
    }
}

@end
