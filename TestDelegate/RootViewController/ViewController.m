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
    
//    __block  int name = 10;
    NSObject *object = [[NSObject  alloc] init];
    NSLog(@"外部, Block1, object, %p, %@", &object, object);
    __block  NSObject *name = object;
    NSLog(@"外部, Block1, name, %p, %@", &name, name);
    object = nil;
    void (^Block1)(void) = ^{
        NSLog(@"内部, Block1, name, %p, %@", &name, name);
        
        //必须在这里释放掉
        //name = nil;
    };
    NSLog(@"外部, Block1, name, %p, %@", &name, name);
    object = nil;
    Block1();
    NSLog(@"外部, Block1, name, %p, %@", &name, name);
    /*
     2018-09-26 22:40:19.605850+0800 TestDelegate[2447:128652] 外部, Block1, object, 0x7ffeea7514d0, <NSObject: 0x60c000002a40>
     2018-09-26 22:40:19.605941+0800 TestDelegate[2447:128652] 外部, Block1, name, 0x7ffeea7514c8, <NSObject: 0x60c000002a40>
     2018-09-26 22:40:19.606046+0800 TestDelegate[2447:128652] 外部, Block1, name, 0x608000241d68, <NSObject: 0x60c000002a40>
     2018-09-26 22:40:19.606135+0800 TestDelegate[2447:128652] 内部, Block1, name, 0x608000241d68, <NSObject: 0x60c000002a40>
     
     */
/*
 必须记住在 block 底部释放掉 block 变量，这其实跟 MRC 的形式有些类似了，不太适合 ARC这种形式既能保证在 block 内部能够访问到 obj，又可以避免循环引用的问题，但是这种方法也不是完美的，其存在下面几个问题
 
 当在 block 外部修改了 blockObj 时，block 内部的值也会改变，反之在 block 内部修改 blockObj 在外部再使用时值也会改变。这就需要在写代码时注意这个特性可能会带来的一些隐患
 __block 其实提升了变量的作用域，在 block 内外访问的都是同一个 blockObj 可能会造成一些隐患

 
 */
    //添加FPS标签到window上
#ifdef DEBUG
    YYFPSLabel *yyFPSLabel = [[YYFPSLabel  alloc] init];
    [[UIApplication sharedApplication].keyWindow  addSubview:yyFPSLabel];
    yyFPSLabel.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, [UIApplication sharedApplication].keyWindow.center.y + 280);
#endif
    
    // [self   block];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)block
{
    NSObject *object = [[NSObject  alloc] init];
    NSLog(@"object, %p, %@", &object, object);
    __weak NSObject *weakObject = object;
    NSLog(@" 外部 weakObject, %p, %@", &weakObject, weakObject);

    void(^testBlock)(void) = ^(){
        NSLog(@"内部 weakObject, %p, %@", &weakObject, weakObject);
    };
    testBlock();
    object = nil;
    testBlock();
    
    /*
     2018-09-26 22:08:09.461173+0800 TestDelegate[1845:91024] object, 0x7ffee0f24358, <NSObject: 0x60c000005d30>
     2018-09-26 22:08:09.461275+0800 TestDelegate[1845:91024]  外部 weakObject, 0x7ffee0f24350, <NSObject: 0x60c000005d30>
     2018-09-26 22:08:09.461343+0800 TestDelegate[1845:91024] 内部 weakObject, 0x60800005b560, <NSObject: 0x60c000005d30>
     2018-09-26 22:08:09.461474+0800 TestDelegate[1845:91024] 内部 weakObject, 0x60800005b560, (null)
     */
    
    /*
     从上面的结果可以看到
     block 内的 weakObject 和外部的 weakObject 并不是同一个变量
     block 捕获了 weakObject 同时也是对 obj 进行了弱引用，当我在 block 外把 object 释放了之后，block 内也读不到这个变量了
     
     当 object 赋值 nil 时，block 内部的 weakObject 也为 nil 了，也就是说 object 实际上是被释放了，可见 __weak 是可以避免循环引用问题的
     */

    
    /************************************/
    
    NSObject *obj = [[NSObject alloc]init];
    NSLog(@"object2, %p, %@", &obj, obj);

    __weak NSObject *weakObj = obj;
    NSLog(@"外部2, weakObj, %p, %@", &weakObj, weakObj);

    void(^testBlock2)(void) = ^(){
        __strong NSObject *strongObj = weakObj;
        NSLog(@"内部2, strongObj, %p, %@", &strongObj, strongObj);
    };
    
    NSLog(@"外部2*, weakObj, %p, %@", &weakObj, weakObj);

    testBlock2();
    NSLog(@"外部2*, weakObj, %p, %@", &weakObj, weakObj);

    obj = nil;
    testBlock2();
    NSLog(@"外部2*, weakObj, %p, %@", &weakObj, weakObj);

    /*
     2018-09-26 22:09:01.690260+0800 TestDelegate[1868:92438] object2, 0x7ffee6041308, <NSObject: 0x604000013ea0>
     2018-09-26 22:09:01.690343+0800 TestDelegate[1868:92438] 外部2, weakObj, 0x7ffee6041300, <NSObject: 0x604000013ea0>
     2018-09-26 22:09:01.690418+0800 TestDelegate[1868:92438] 内部2, weakObj, 0x7ffee6041228, <NSObject: 0x604000013ea0>
     2018-09-26 22:09:01.690503+0800 TestDelegate[1868:92438] 内部2, weakObj, 0x7ffee6041228, (null)
     */
    
    /*
     https://www.cnblogs.com/yajunLi/p/6203222.html?utm_source=itdadao&utm_medium=referral
     如果你看过 AFNetworking 的源码，会发现 AFN 中作者会把变量在 block 外面先用 __weak 声明，在 block 内把前面 weak 声明的变量赋值给 __strong 修饰的变量这种写法。
     
     从上面例子我们看到即使在 block 内部用 __strong 强引用了外面的 weakObj ,
     但是一旦 obj 释放了之后，内部的 strongObj 同样会变成 nil，那么这种写法又有什么意义呢？
     */
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


@end




