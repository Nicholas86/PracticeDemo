//
//  NRunLoopThread.m
//  TestDelegate
//
//  Created by 泽娄 on 2019/1/19.
//  Copyright © 2019 a. All rights reserved.
//

/// https://www.jianshu.com/p/58f44609bd50

#import "NRunLoopThread.h"

@interface NRunLoopThread ()

@property (nonatomic, strong, readwrite) NSMutableArray *commands;

@property (nonatomic, assign) CFRunLoopSourceRef rlSource;

@end


@implementation NRunLoopThread

static NRunLoopThread *instance = nil;

// Main 除了需要标记相关的 run loop source 是 ready-to-be-fired 之外，
// 还需要调用 CFRunLoopWakeUp 来唤醒指定的 RunLoop
// RunLoop 是不能手动创建的，所以必须注册这个回调来向 Main 暴露 Worker
// 的 RunLoop，这样在 Main 中才知道要唤醒谁
static CFRunLoopRef workerRunLoop = nil;

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
        [self runLoopSource];
    }return self;
}

- (void)runLoopSource
{
    // run loop source 的上下文
    // 就是一些 run loop source 相关的选项以及回调
    // 另外我们这的第一个参数是 0，必须是 0
    // 这样创建的 run loop source 就被添加在
    // run loop 中的 _sources0，作为用户创建的
    // 非自动触发的

    // (__bridge void *)(self) 必须写, 否则void *info为空
    CFRunLoopSourceContext context = {
        0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        RunLoopSourceScheduleRoutine,
        NULL,
        RunLoopSourcePerformRoutine
    };

    CFRunLoopSourceRef runLoopSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);

    _rlSource = runLoopSource;
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
    CFRunLoopAddSource(CFRunLoopGetCurrent(), _rlSource, kCFRunLoopDefaultMode);
    // 线程需要手动运行 RunLoop
    CFRunLoopRun();
    NSLog(@"[Worker] is stopping...");
}


// run loop source 相关的回调函数
// 在外部代码标记了 run loop 中的某个 run loop source
// 是 ready-to-be-fired 时，那么在未来的某一时刻 run loop
// 发现该 run loop source 需要被触发，那么就会调用到这个与其
// 相关的回调
void RunLoopSourcePerformRoutine(void *info)
{
    // 如果该方法被调用，那么说明其相关的 run loop source
    // 已经准备好。在这个程序中就是 Main 通知了 Worker 『任务来了』
    NRunLoopThread *thread = (__bridge NRunLoopThread *)info;
    
    NSLog(@"[Worker] executing command, thread: %@", thread);

    NSString *last = [thread popCommand];
    
    while (last) {
        NSLog(@"[Worker] executing command: %@", last);
        sleep(0.5); // 模拟耗时的计算所需的时间
        NSLog(@"[Worker] executed command: %@", last);
        last = [thread popCommand];
        
        if (thread.blcok) {
            thread.blcok(last);
        }
    }
}


// 这也是一个 run loop source 相关的回调，它发生在 run loop source 被添加到
// run loop 时，通过注册这个回调来获取 Worker 的 run loop
void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode)
{
    workerRunLoop = rl;
}

// 告诉 Worker 任务来了
// 把 Worker 拎起来干事
-(void)notifyWorker
{
    if (workerRunLoop) {
        CFRunLoopSourceSignal(_rlSource);
        CFRunLoopWakeUp(workerRunLoop);
    }
}


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


- (void)dealloc
{
    NSLog(@"dealloc");
    workerRunLoop = nil;
    CFRelease(_rlSource);
}

@end
