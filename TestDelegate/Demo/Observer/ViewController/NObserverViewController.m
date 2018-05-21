//
//  NObserverViewController.m
//  TestDelegate
//
//  Created by a on 2018/5/21.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NObserverViewController.h"

@interface NObserverViewController ()
@property (nonatomic, assign) int page;
@end

@implementation NObserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"观察者";
    //page 默认值
    self.page = 1;
    
    [self  addObserverForPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 观察 page属性
- (void)addObserverForPage
{
    [self   addObserver:self forKeyPath:@"page" options:NSKeyValueObservingOptionNew |
     NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"change: %@", change);
}

//观察者
- (IBAction)handleObserverBtn:(UIButton *)sender
{
    /*
     观察者原理, 简单说, 就是重写了被观察属性(page)的set方法。
     自然, 一般情况下, 只有通过set方法对值(self.page++)进行改变, 才会触发kvo。
     直接访问实例变量(_page++)修改值是不会触发kvo的。
     */
    
    //1.直接访问实例变量(_page++)修改值是不会触发kvo
    //_page ++;
    
    //2.通过set方法对值(self.page++)进行改变, 会触发kvo
    self.page ++;
    [sender  setTitle:[NSString stringWithFormat:@"观察page:%d", self.page] forState:UIControlStateNormal];
}

@end
