//
//  NResponderViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/20.
//  Copyright © 2018 a. All rights reserved.
//

#import "NResponderViewController.h"
#import "NRedView.h"
#import "NBlueView.h"
#import "NYellowView.h"
#import "NLightBtn.h"

@interface NResponderViewController ()
@property (nonatomic, strong) NRedView *redView;
@property (nonatomic, strong) NBlueView *blueView;
@property (nonatomic, strong) NYellowView *yellowView;
@property (nonatomic, strong) NLightBtn *lightBtn;
@end

@implementation NResponderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"响应者";
    
    self.redView = [[NRedView  alloc] initWithFrame:CGRectMake(20, 100, 340, 490)];
    _redView.backgroundColor = [UIColor  redColor];
    [self.view  addSubview: _redView];
    
    self.blueView = [[NBlueView  alloc] initWithFrame:CGRectMake(20, 30, 300, 450)];
    _blueView.backgroundColor = [UIColor  blueColor];
    [_redView  addSubview: _blueView];
    
    self.yellowView = [[NYellowView  alloc] initWithFrame:CGRectMake(30, 30, 180, 380)];
    _yellowView.backgroundColor = [UIColor  yellowColor];
    _yellowView.tag = 2000;
    [_blueView  addSubview: _yellowView];
    
    UIButton *btn0 = [UIButton  buttonWithType:UIButtonTypeCustom];
    btn0.frame = CGRectMake(20, 80, 150, 120);
    btn0.backgroundColor = [UIColor blackColor];
    [btn0  addTarget:self action:@selector(handleBlackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_yellowView  addSubview:btn0];
    
    //灰色按钮添加到父视图(黄色视图)上, 并且超出了父视图(黄色视图)
    /*
     测试点击超出父视图(黄色视图)区域
     所以针对超出父视图的button的点击,首先要让父视图的hitTest方法返回不为nil,也就是如果点击范围在button范围内,就让父视图的
     
     hitTest方法返回响应的按钮对象,这个过程中需要对点击事件的坐标进行处理,可以通过调用button的pointInside来确定点击的点是否在
     
     按钮上,以此来判断父视图是该返回按钮对象还是nil!

     在介绍事件传递时了解到，因为父控件（_yellowView）在调用 hitTest:withEvent:方法方法时，由于触摸点不在父控件范围内，所以无法让子控件（UIButton:_lightBtn）做为最合适的view去处理点击事件。
     解决方法就是，重写_yellowView的hitTest:withEvent:方法（准确的说是super调用hitTest:withEvent:), 当无法找到这个最合适的view时，先将触摸点坐标（point参数）转换到button所在坐标系，判断触摸点是否在button范围内，如果在，则返回button为处理事件最合适的view，这样button就能正确触发点击事件，代码如下:
     
     作者：BrightFuture
     链接：https://www.jianshu.com/p/933dd3ed2504
     來源：简书
     */
    self.lightBtn = [[NLightBtn  alloc] initWithFrame:CGRectMake(30, 230, 230, 120)];
    _lightBtn.tag = 1000;
    _lightBtn.backgroundColor = [UIColor  lightGrayColor];
    [_lightBtn setTitle:@"测试点击超出父视图(黄色视图)区域" forState:UIControlStateNormal];
    _lightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_lightBtn  addTarget:self action:@selector(handleLightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_yellowView  addSubview: _lightBtn];
    
    UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 15, 100, 90);
    btn.backgroundColor = [UIColor orangeColor];
    btn.tag = 3000;
    [btn  addTarget:self action:@selector(handleOrangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_lightBtn  addSubview:btn];
}

- (void)handleBlackBtn:(UIButton *)sender
{
    NSLog(@"黑色按钮触发事件");
    self.title = @"黑色按钮触发事件";
}

- (void)handleOrangeBtn:(UIButton *)sender
{
    NSLog(@"橘色按钮触发事件");
    self.title = @"橘色按钮触发事件";
}

- (void)handleLightBtn:(UIButton *)sender
{
    NSLog(@"灰色按钮触发事件");
    self.title = @"灰色按钮触发事件";
}


@end
