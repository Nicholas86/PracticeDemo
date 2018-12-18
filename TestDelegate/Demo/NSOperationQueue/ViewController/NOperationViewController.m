//
//  NOperationViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/16.
//  Copyright © 2018 a. All rights reserved.
//

#import "NOperationViewController.h"
#import "NonConcurrentOperation.h"
#import "NCreateInvocationOperation.h"
#import "NCreateBlockOperation.h"
#import "NUseOperationQueue.h"
#import "NManualExecuteOperation.h"

@interface NOperationViewController ()
@property (nonatomic,strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) int i;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"NSOperationQueue";
    self.i = 0;
    
    // [self testInvocationOperationWithData_userInput_1];
    // [self testInvocationOperationWithData_userInput_2];
    
    // [self testBlockOperation];
    
    // [self testExecuteOperationUsingOperationQueue];
    
    // [self testManualPerformOperation];
    
    // [self testInitWithData_1];
    // [self testInitWithData_2];
    
    [self testA];
}


- (void)testInvocationOperationWithData_userInput_1
{
    NCreateInvocationOperation *createInvocationOperation = [[NCreateInvocationOperation alloc] init];
    
    NSInvocationOperation *invocationOperation = [createInvocationOperation invocationOperationWithData:@"leichunfeng" userInput:@"Hello NSInvocationOperation!"];
    
    [invocationOperation start];
}

- (void)testInvocationOperationWithData_userInput_2
{
    NCreateInvocationOperation *createInvocationOperation = [[NCreateInvocationOperation alloc] init];
    
    NSInvocationOperation *invocationOperation = [createInvocationOperation invocationOperationWithData:@"leichunfeng" userInput:nil];
    
    [invocationOperation start];
}

- (void)testBlockOperation
{
    NCreateBlockOperation *createBlockOperation = [[NCreateBlockOperation alloc] init];
    
    NSBlockOperation *blockOperation = [createBlockOperation blockOperation];
    
    [blockOperation start];
}

- (void)testExecuteOperationUsingOperationQueue
{
    NUseOperationQueue *useOperationQueue = [[NUseOperationQueue alloc] init];
    [useOperationQueue executeOperationUsingOperationQueue];
}

- (void)testManualPerformOperation
{
    NManualExecuteOperation *manualExecuteOperation = [[NManualExecuteOperation alloc] init];
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Start executing blockOperation, mainThread: %@, currentThread: %@", [NSThread mainThread], [NSThread currentThread]);
        sleep(3);
        NSLog(@"Finish executing blockOperation");
    }];
    NSLog(@"isRead: %d", blockOperation.isReady);
    [manualExecuteOperation manualPerformOperation:blockOperation];
}

- (void)testInitWithData_1
{
    NonConcurrentOperation *nonConcurrentOperation = [[NonConcurrentOperation alloc] initWithData:@"nicholas"];
    [nonConcurrentOperation start];
}

- (void)testInitWithData_2
{
    NonConcurrentOperation *nonConcurrentOperation = [[NonConcurrentOperation alloc] initWithData:[NSString stringWithFormat:@"nicholas-%d", self.i]];
    [self.operationQueue addOperation:nonConcurrentOperation];
    // sleep(5);
    
    // [nonConcurrentOperation cancel];
    
    // [operationQueue waitUntilAllOperationsAreFinished];
}

- (void)testA
{
    //任务A、B、C异步处理，但是任务B的完成依赖于任务A的完成，任务C的完成依赖于任务B的完成。这就叫做线程间的依赖。可以通过[operation addDependency:Oper1]来添加依赖。
    
    // eg、分别下载图片1和logo图片，然后在新线程中合并两张图片（打上水印）。合并操作依赖于两个下载线程，这样就使用到了线程间的依赖。
    
    __block UIImage *image1 = nil;
    __block UIImage *logo = nil;
    
    //1 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //2 创建操作A
    NSBlockOperation *operationA = [NSBlockOperation blockOperationWithBlock:^{
        //下载图片1
        NSURL *url = [NSURL URLWithString:@"http://img3.duitang.com/uploads/item/201408/22/20140822234055_W3CrG.thumb.700_0.jpeg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image1 = [UIImage imageWithData:data];
        NSLog(@"图片下载完成1--%@",[NSThread currentThread]);
    }];
    
    //3 创建操作B
    NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
        //下载logo
        NSURL *url = [NSURL URLWithString:@"http://img0.bdstatic.com/img/image/imglogo-r.png"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        logo = [UIImage imageWithData:data];
        NSLog(@"logo下载完成--%@",[NSThread currentThread]);
    }];
    
    //4 创建操作C
    NSBlockOperation *operationC = [NSBlockOperation blockOperationWithBlock:^{
        //合成图片
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        [logo drawInRect:CGRectMake(0, 0, 100, 128)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"操作C--%@",[NSThread currentThread]);
        
        //获取主队列，回到主线程刷新UI
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            self.imageView.image = image;
            NSLog(@"合成图片--%@",[NSThread currentThread]);
        }];
        
    }];
    
    //4 创建依赖
    [operationC addDependency:operationA];
    [operationC addDependency:operationB];
    
    //5 加入队列
    [queue addOperations:@[operationA,operationB,operationC] waitUntilFinished:NO];
    
    NSLog(@"嗯");
}

- (IBAction)addOperationBtn:(UIButton *)sender {
    self.i ++;
    [self testInitWithData_2];
}

// 暂停
- (IBAction)suspendBtn:(UIButton *)sender {
    
    /*
     暂停队列任务
     
     使用场景：
     
     当正在下载时，如果碰到用户滚动界面UI时，暂停任务，为了用户体验。
     
     在用户停止滚动时，恢复任务。
     
     //暂停队列中的任务
     [queue setSuspended:YES];
     //恢复队列中的任务
     [queue setSuspended:NO];
     */
    self.operationQueue.suspended = !self.operationQueue.suspended;
    if (self.operationQueue.isSuspended) {
        NSLog(@"暂停");
    }else{
        NSLog(@"恢复");
    }
}

// 取消
- (IBAction)cancleOperationBtn:(UIButton *)sender {
    //只能取消所有队列的里面的操作，正在执行的无法取消
    //取消操作并不会影响队列的挂起状态
    [self.operationQueue cancelAllOperations];
    NSLog(@"取消队列里所有的操作");
    //取消队列的挂起状态
    //（只要是取消了队列的操作，我们就把队列处于不挂起状态,以便于后续的开始）
    self.operationQueue.suspended = NO;
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        // 2.设置最大并发操作数
        _operationQueue.maxConcurrentOperationCount = 1; // 串行队列, 当设置为1时, 同时执行的任务就只有一个
        // queue.maxConcurrentOperationCount = 2; // 并发队列
        // queue.maxConcurrentOperationCount = 8; // 并发队列
        
    }return _operationQueue;
}

/*
 5. NSOperationQueue 控制串行执行、并发执行
 之前我们说过，NSOperationQueue 创建的自定义队列同时具有串行、并发功能，上边我们演示了并发功能，那么他的串行功能是如何实现的？
 这里有个关键属性 maxConcurrentOperationCount，叫做最大并发操作数。用来控制一个特定队列中可以有多少个操作同时参与并发执行。
 
 注意：这里 maxConcurrentOperationCount 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。
 
 最大并发操作数：maxConcurrentOperationCount
 
 maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
 maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行。
 maxConcurrentOperationCount 大于1时，队列为并发队列。操作并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整为 min{自己设定的值，系统设定的默认最大值}。

链接：https://juejin.im/post/5a9e57af6fb9a028df222555

 
 可以看出：当最大并发操作数为1时，操作是按顺序串行执行的，并且一个操作完成之后，下一个操作才开始执行。当最大操作并发数为2时，操作是并发执行的，可以同时执行两个操作。而开启线程数量是由系统决定的，不需要我们来管理。

 */
@end
