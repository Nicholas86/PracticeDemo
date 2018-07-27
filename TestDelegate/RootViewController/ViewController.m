//
//  ViewController.m
//  TestDelegate
//
//  Created by a on 2018/2/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "ViewController.h"
#import "PopViewController.h"
#import "CustomBtn.h"
#import "NCacheManager.h"
#import "NDemoTableViewController.h"

#ifdef DEBUG
#import "YYFPSLabel.h" //渲染帧 60FPS
#endif

@interface ViewController ()<CustomBtnDelegate, CustomBtnDataSource, PopViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/*
 copy、retain、strong、assin、weak
 copy、retain、strong修饰数组, 正常
 assign修饰数组, 崩溃
 weak修饰数组, null
 */
@property (nonatomic, weak) NSArray *array;

@property (nonatomic, assign) NSInteger  page;

@property (nonatomic, copy) NSString *titleString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Demo";
    //高度默认为0,代理方法里面,再动态改变
    CustomBtn *customBtn = [[CustomBtn alloc] initWithFrame:CGRectMake(60, 500, 300, 0)];
    customBtn.backgroundColor = [UIColor  lightGrayColor];
    customBtn.delegate = self;
    customBtn.dataSource = self;
    [self.view   addSubview:customBtn];
    
    ///__weak、 __strong
    [self  weak_strong];

    //线程组
    //[self  dispatch_group];
    
    //添加FPS标签到window上
#ifdef DEBUG
    YYFPSLabel *yyFPSLabel = [[YYFPSLabel  alloc] init];
    [[UIApplication sharedApplication].keyWindow  addSubview:yyFPSLabel];
    yyFPSLabel.center = [UIApplication sharedApplication].keyWindow.center;
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按钮上覆盖一层view,测试 事件响应者链UIResponder
- (IBAction)pushBtn:(id)sender
{
    PopViewController *popVC = [[PopViewController alloc] init];
    popVC.delegate = self;
    [self.navigationController pushViewController:popVC animated:YES];
}

- (CGFloat)passTitleString:(NSString *)titleString
{
    //NSLog(@"传过来:%@", titleString);
    self.titleLabel.text = titleString;
    return 5.0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 5* section;
}


#pragma mark Demo
- (IBAction)matlabButton:(UIButton *)sender
{
    NDemoTableViewController *nDemoVC = [[NDemoTableViewController  alloc] init];
    [self.navigationController  pushViewController:nDemoVC animated:YES];
}

///清除缓存
- (IBAction)handleClearCache:(UIButton *)sender
{
    [[NCacheManager  share] removeAllObjects];
}

///__weak、 __strong
- (void)weak_strong
{
    self.page = 1; // 1不是对象
    
    /*
     将自己生成并持有的 (对象) 赋值给 __weak 修饰符的变量array, 即变量array持有对象的弱引用。
     因为带 __weak 修饰符的变量 (即弱引用) 不持有对象, 所以self.array会立即被释放。
     编译器会给出警告。
     */
    self.array = [[NSArray  alloc] initWithObjects:@"一", @"二",  nil];;
    NSLog(@"page, %ld", (long)self.page);
    NSLog(@"数组, %@", self.array);
    
    
    /*
     strong修饰字符串:
     我们只给self.titleString附了一次值,但是 self.titleString 的值改变了,
     这是因为把可变字符的地址指向了titleString,
     所以mutableString的值改变了,self.titleString也跟着改变。
     
     打印日志
     2018-07-27 09:48:03.217610+0800 TestDelegate[7946:2615834] *0, 看看指针地址, 指针地址:0x100100240
     2018-07-27 09:48:03.217627+0800 TestDelegate[7946:2615834] *1, hello, 指针地址:0x174270c80
     2018-07-27 09:48:03.217638+0800 TestDelegate[7946:2615834] *2, hello, 指针地址:0x174270c80
     2018-07-27 09:48:03.217649+0800 TestDelegate[7946:2615834] *3, helloWorld, 指针地址:0x174270c80
     
     copy修饰字符串: 正常
     所以正规用法: copy修饰字符串
     */
    
    self.titleString = @"看看指针地址";
    NSLog(@"*0, %@, 指针地址:%p", self.titleString, _titleString);
    
    NSMutableString *mutableString = [NSMutableString string];
    [mutableString appendString:@"hello"];
    NSLog(@"*1, %@, 指针地址:%p", mutableString, mutableString);

    self.titleString = mutableString;
    NSLog(@"*2, %@, 指针地址:%p",self.titleString, _titleString);
    
    [mutableString appendString:@"World"];
    NSLog(@"*3, %@, 指针地址:%p",self.titleString, _titleString);
}


///线程组
- (void)dispatch_group
{
    NSArray *titles = @[@"1", @"2", @"3", @"5", @"6", @"7"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSString *title in titles) {
        dispatch_group_async(group, queue, ^{
            NSLog(@"title: %@", title);
        });
    }
    
    NSLog(@"主线程1");
    
    /*
     1.
     dispatch_group_wait:阻塞当前主线程, 直到dispatch_group任务全部执行完毕
     必须上面for循环执行完毕, 才走下面的for循环
     打印日志
     2018-07-24 20:29:49.693691+0800 TestDelegate[6232:1946763] 主线程1
     2018-07-24 20:29:49.693728+0800 TestDelegate[6232:1946803] title: 1
     2018-07-24 20:29:49.693741+0800 TestDelegate[6232:1946803] title: 2
     2018-07-24 20:29:49.693751+0800 TestDelegate[6232:1946803] title: 3
     2018-07-24 20:29:49.693761+0800 TestDelegate[6232:1946803] title: 5
     2018-07-24 20:29:49.693783+0800 TestDelegate[6232:1946763] 主线程2
     2018-07-24 20:29:49.693980+0800 TestDelegate[6232:1946803] title啊: 1
     2018-07-24 20:29:49.694003+0800 TestDelegate[6232:1946803] title啊: 2
     2018-07-24 20:29:49.694015+0800 TestDelegate[6232:1946803] title啊: 3
     2018-07-24 20:29:49.694026+0800 TestDelegate[6232:1946803] title啊: 5
     2018-07-24 20:29:49.711286+0800 TestDelegate[6232:1946763] 刷新UI
     */
    //dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    /*
     2.
     不堵塞当前主线程
     测试结果: 上面的for循环和下面的for循环并发执行,下面for循环某一任务可能比上面for循环先执行完
     当所有for循环执行完毕后, 总是最后执行dispatch_group_notify函数, 将dispatch_group_notify
     函数放在for循环前面也一样
     
     说明dispatch_group_notify函数不堵塞当前线程
     
     打印日志:
     2018-07-24 20:38:04.179961+0800 TestDelegate[6250:1949178] 主线程1
     2018-07-24 20:38:04.179963+0800 TestDelegate[6250:1949205] title: 1
     2018-07-24 20:38:04.179982+0800 TestDelegate[6250:1949178] 主线程2
     2018-07-24 20:38:04.179984+0800 TestDelegate[6250:1949205] title: 2
     2018-07-24 20:38:04.180011+0800 TestDelegate[6250:1949205] title: 5
     2018-07-24 20:38:04.180021+0800 TestDelegate[6250:1949205] title: 6
     2018-07-24 20:38:04.180030+0800 TestDelegate[6250:1949205] title: 7
     2018-07-24 20:38:04.180071+0800 TestDelegate[6250:1949205] title啊: 1
     2018-07-24 20:38:04.180084+0800 TestDelegate[6250:1949205] title啊: 2
     2018-07-24 20:38:04.180095+0800 TestDelegate[6250:1949205] title啊: 3
     2018-07-24 20:38:04.180105+0800 TestDelegate[6250:1949205] title啊: 5
     2018-07-24 20:38:04.180116+0800 TestDelegate[6250:1949205] title啊: 6
     2018-07-24 20:38:04.180126+0800 TestDelegate[6250:1949205] title啊: 7
     2018-07-24 20:38:04.180146+0800 TestDelegate[6250:1949204] title: 3
     2018-07-24 20:38:04.196393+0800 TestDelegate[6250:1949178] 刷新UI
     */
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"刷新UI");
    });
    
    NSLog(@"主线程2");
    for (NSString *title in titles) {
        dispatch_group_async(group, queue, ^{
            NSLog(@"title啊: %@", title);
        });
    }
}


@end




