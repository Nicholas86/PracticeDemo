//
//  NObserverViewController.m
//  TestDelegate
//
//  Created by a on 2018/5/21.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NObserverViewController.h"
#import "NPerson.h"
#import <objc/runtime.h>

@interface NObserverViewController ()
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NPerson *person;
@end

@implementation NObserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"KVO原理-动态生成类";
    //page 默认值
    self.page = 1;
    self.person = [[NPerson  alloc] init];
    [self.person setName:@"谢霆锋"];
    
    [self  addObserverForPage];
    
    [self  addObserverForPerson];
    
    //动态生成类
    [self  createCustomClass];
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


#pragma mark 观察 person name 属性
//https://www.jianshu.com/p/cf079e5433e4
- (void)addObserverForPerson
{
    //首先，我们利用runtime在添加监听之前和之后分别打印一下类对象
    NSLog(@"监听之前, 类%@", object_getClass(self.person));
    //监听前方法名
    [self.person  methodForSelector:@selector(setName:)];
    
    [self.person
     addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew |
     NSKeyValueObservingOptionOld context:nil];
    
    NSLog(@"监听之后, 类%@", object_getClass(self.person));
    //监听后方法名
    [self.person  methodForSelector:@selector(setName:)];

}
/*
 2018-05-22 11:09:10.598990+0800 TestDelegate[5895:1621960] 监听之前, 类NPerson
 2018-05-22 11:09:10.601901+0800 TestDelegate[5895:1621960] 监听之后, 类NSKVONotifying_NPerson
 
 我们发现添加监听之后，实例对象的类对象发生了变化，系统为我们动态添加了一个NSKVONotifying_+类名的类，因为我们改变对象属性的值是通过setter方法实现了，所以很明显是系统动态生成的NSKVONotifying_NPerson类重写了setter方法。不信的话，我们可以做一个实验，自己手动添加一个NSKVONotifying_NPerson类，看下会打印什么
 错误提示很明显，告诉我们创建NSKVONotifying_ZJPerson类失败
 */


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
    [self.person  setName:[NSString stringWithFormat:@"谢霆锋:%d", self.page]];
    [sender  setTitle:[NSString stringWithFormat:@"page:%d, name:%@", self.page, self.person.name] forState:UIControlStateNormal];
}



#pragma mark - Public
//runtime动态创建类
- (void)createCustomClass{
    // 创建类
    Class customClass = objc_allocateClassPair([NSObject class], "NCustomClass", 0);
    
    // 添加实例变量
#warning 参数//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
    
    class_addIvar(customClass, "age", sizeof(int), 0, "i");
    class_addIvar(customClass, "name", sizeof(NSString *), 0, "@");
    
    // 添加方法
    class_addMethod(customClass, @selector(custom_method), (IMP)custom_imp, "V@:");
    
    id myObjc = [[customClass alloc] init];
    
    // 注册到运行时环境
    objc_registerClassPair(customClass);
    NSLog(@"自定义类对象: %@", myObjc);
    
    NSLog(@"自定义类对象方法: %@", [self copyMethodsByClass:customClass]);
    NSLog(@"自定义类对象属性: %@", [self copyIvarsByClass:customClass]);
    
    [myObjc performSelector:@selector(custom_method)];
}

void custom_imp(id self, SEL _cmd)
{
    NSLog(@"custom_imp====");
}

- (void)custom_method
{
    NSLog(@"自定义方法");
}

#pragma mark - Util

- (NSString *)copyMethodsByClass:(Class)cls{
    unsigned int count;
    Method *methods = class_copyMethodList(cls, &count);
    
    NSString *methodStrs = @"";
    
    for (NSInteger index = 0; index < count; index++) {
        Method method = methods[index];
        
        NSString *methodStr = NSStringFromSelector(method_getName(method));
        
        methodStrs = [NSString stringWithFormat:@"%@ ", methodStr];
    }
    
    free(methods);
    
    return methodStrs;
}

- (NSString *)copyIvarsByClass:(Class)cls{
    unsigned int count;
    Ivar *ivars = class_copyIvarList(cls, &count);
    
    NSMutableString *ivarStrs = [NSMutableString string];
    
    for (NSInteger index = 0; index < count; index++) {
        Ivar ivar = ivars[index];
        
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];  //获取成员变量的名字
        
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)]; //获取成员变量的数据类型
        
        [ivarStrs appendString:@"\n"];
        [ivarStrs appendString:ivarName];
        [ivarStrs appendString:@"-"];
        [ivarStrs appendString:ivarType];
        
    }
    
    free(ivars);
    
    return ivarStrs;
}


- (void)dealloc
{
    [self  removeObserver:self forKeyPath:@"page"];
    [self.person  removeObserver:self forKeyPath:@"name"];
}

@end




