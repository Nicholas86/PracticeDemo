//
//  NRunloopViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2019/1/19.
//  Copyright © 2019 a. All rights reserved.
//
/*
 
 在使用 RunLoop 之前，先了解下它。具体的在 Run Loops，扼要的说：
 
 每个线程都有一个与之相关的 RunLoop
 与线程相关联的 RunLoop 需要手动的运行，以此让其开始处理任务。主线程已经为你自动的启动了与其关联的 RunLoop（注意命令行程序的主线程并没有这个自动开启的动作）
 RunLoop 需要以特定的 mode 去运行。『common mode』实际上是一组 modes，有相关的 API 可以向其中添加 mode
 RunLoop 的目的就是监控 timers 和 run loop sources。每一个 run loop source 需要注册到特定的 run loop 的特定 mode 上，并且只有当 run loop 运行在相应的 mode 上时，mode 中的 run loop source 才有机会在其准备好时被 run loop 所触发
 RunLoop 在其每一次的循环中，都会经历几个不同的场景，比如检查 timers、检查其他的 event sources。如果有需要被触发的 source，那么会触发与那个 source 相关的 callback
 除了使用 run loop source 之外，还可以创建 run loop observers 来追踪 run loop 的处理进度
 
 如果要更加深入的了解 RunLoop 推荐阅读 深入理解RunLoop。
 
 作者：hsy0
 链接：https://juejin.im/post/5c400361518825258124f26b
 来源：掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
#import "NRunloopViewController.h"
#import "NSubThread.h"
#import "NRunLoopThread.h"

@interface NRunloopViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation NRunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Runloop";
    
    self.view.backgroundColor = [UIColor  whiteColor];

    self.label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor redColor];
    _label.frame = CGRectMake(30, 100, 260, 60);
    [self.view addSubview:_label];
    
    /// [self normal];
    
    [self runloop];
}

- (void)normal
{
    NSubThread *thread = [NSubThread share];
    if (![thread isExecuting]) {
        [thread start];
    }
    
    thread.blcok = ^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = (NSString *)responseObject;
        });
    };
    
    for (int i = 0; i < 10000; i++) {
        NSString *cmd = [NSString stringWithFormat:@"%d", i];
        [thread  pushCommand:cmd];
        // 在主线程中 Log 这条信息，
        // 以此来表示主线程可以继续响应
        NSLog(@"[Main] added new command: %@", cmd);
    }
    
    return;
    
    int c = 0;
    do {
        c = getchar();
        // 忽略输入的换行
        // 这样 Log 内容更加清晰
        if (c == '\n')
            continue;
        
        NSString *cmd = [NSString stringWithCharacters:(const unichar*)&c length:1];
        [thread.commands addObject:cmd];
        // 在主线程中 Log 这条信息，
        // 以此来表示主线程可以继续响应
        NSLog(@"[Main] added new command: %@", cmd);
        
    } while (c != 'q');
    
}


- (void)runloop
{
    NRunLoopThread *thread = [[NRunLoopThread alloc] init];// [NRunLoopThread share];
    if (![thread isExecuting]) {
        [thread start];
    }
    
    thread.blcok = ^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = (NSString *)responseObject;
        });
    };
    
    for (int i = 0; i < 10000; i++) {
        NSString *cmd = [NSString stringWithFormat:@"%d", i];
        [thread  pushCommand:cmd];
        // 在主线程中 Log 这条信息，
        // 以此来表示主线程可以继续响应
        NSLog(@"[Main] added new command: %@", cmd);
        
        if (0 != [thread.commands count]) {
            [thread notifyWorker]; /// 唤醒runloop, 开始干活
        }
    }
    
}


@end
