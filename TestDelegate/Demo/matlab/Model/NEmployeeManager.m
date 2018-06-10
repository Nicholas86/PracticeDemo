//
//  NEmployeeManager.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/6/9.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NEmployeeManager.h"
#import "NEmployee.h"

@interface NEmployeeManager (){
    NEmployee *_head; //头部节点
    NEmployee *_ptr;  //临时节点, 充当尾部节点
    CFMutableDictionaryRef _dic; //保存节点到内存字典
}
@end

@implementation NEmployeeManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //建立链表头
        //_head = [[NEmployee  alloc] init];
        _head = _ptr = nil; //默认置nil, 不开辟空间。第一次添加的数据就是链表头部。
        //初始化
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }return self;
}

//移动新节点到链表头部
- (void)bringEmployeeToHead:(NEmployee *)employee
{
    if (_head == employee) {
        //移动的节点恰好是头部节点, 直接返回
        NSLog(@"移动的节点恰好是头部节点, 直接返回");
        return;
    }
    
    if (_ptr == employee) {
        //移动的节点恰好是末尾节点, 末尾节点 重新指向 末尾节点的上一个节点
        _ptr = employee.lLink;
        _ptr.rLink = nil;
    }else{
        //移动的节点不是末尾节点, 是中间节点
        employee.rLink.lLink = employee.lLink;
        employee.lLink.rLink = employee.rLink;
    }
    
    employee.rLink = _head;
    employee.lLink = nil;
    _head.lLink = employee;
    _head = employee;//_head被重新赋值成最新的employee
}

//插入新节点到链表头部
- (void)insertEmployeeAtHead:(NEmployee *)employee
{
    if (employee == nil) {
        NSLog(@"employee is null");
        return;
    }
    //添加到缓存字典
    CFDictionarySetValue(_dic, (__bridge const void *)(employee.key), (__bridge const void *)(employee));
    if (_head) {
        employee.rLink = _head;
        _head.lLink = employee;
        _head = employee;//_head被重新赋值成最新的employee
    }else{
        //双向链表是空的, 第一次添加的数据作为链表头
        _head = _ptr = employee;
        NSLog(@"双向链表是空的, 第一次添加的数据作为链表头。_ptr.lLink:%@, _ptr.rLink:%@, _ptr.key: %@", _ptr.lLink, _ptr.rLink, _ptr.key);
    }
    
    NSLog(@"添加到缓存, _head.key: %@", _head.key);
    /*
     将新节点的右指针指向原链表的第一个节点(_head),  原链表的第一个节点的左指针指向新节点,
     并将原链表的链表头指向新节点
     */
}

//插入新节点到链表中间
- (void)insertEmployeeAtMiddle:(NEmployee *)employee
{
    if (employee == nil) {
        NSLog(@"employee is null");
        return;
    }
    //添加到缓存字典
    CFDictionarySetValue(_dic, (__bridge const void *)(employee.key), (__bridge const void *)(employee));
    
    /*
     首先将中间节点(从外部传进来或者内存中间位置任一个临时变量, 这里用ptr代替)的右指针指向新节点,
     再将新节点的左指针指向ptr节点, 接着将ptr节点的下一个节点的左指针指向新节点, 最后将新节点的
     右指针的指向ptr的下一个节点
     */
}

//插入新节点到链表尾部
- (void)insertEmployeeAtTail:(NEmployee *)employee
{
    if (employee == nil) {
        NSLog(@"employee is null");
        return;
    }
    
    if (_head == nil) {
        NSLog(@"头部为空, 设置head = employee");
        _head = employee;
    }
    
    //添加到缓存字典
    CFDictionarySetValue(_dic, (__bridge const void *)(employee.key), (__bridge const void *)(employee));
    
    if (_ptr) {
        _ptr.rLink = employee;
        employee.lLink = _ptr;
        employee.rLink = nil;
    }
    _ptr = employee;//_ptr必须被重新赋值成最新的employee
    
    /*
     原链表的最后一个节点的右指针指向新节点, 将新节点的左指针指向原链表的最后一个节点
     并将新节点的右指针指向nil
     */
}

//查找某个节点
- (NEmployee *)employeeForKey:(NSString *)key
{
    NEmployee *employee = CFDictionaryGetValue(_dic, (__bridge const void *)(key));
    return employee;
}

//移除头部节点
- (void)removeEmployeeAtHead
{
    if (_head == nil) {
        NSLog(@"_head is null");
        return;
    }

    CFDictionaryRemoveValue(_dic, (__bridge const void *)(_head.key));

    if (_head == _ptr) {
        NSLog(@"移除头部节点,head == _ptr, %@", _head.key);
        _head = _ptr = nil;
    }else{
        NSLog(@"移除头部节点, head != _ptr,%@", _head.key);
        _head = _head.rLink; //重新赋值头部节点
        _head.lLink = nil; //头部节点的左指针指向nil
    }
}

//移除中间节点
- (void)removeEmployeeAtMiddle:(NEmployee *)employee
{
    
}

//移除尾部节点
- (void)removeEmployeeAtTail
{
    if (!_ptr) {
        /*
         如果_ptr为nil, 也有可能先从左向右遍历所有节点导致的。
         */
        NSLog(@"_ptr is null");
        return;
    }

    CFDictionaryRemoveValue(_dic, (__bridge const void *)(_ptr.key));
    if (_head == _ptr) {
        _head = _ptr = nil;
    }else{
        _ptr = _ptr.lLink; //重新赋值尾部节点
        _ptr.rLink = nil; //尾部节点的上一个节点的右指针指向nil
        /*
         删除尾部节点后, 必须重新赋值尾部节点
         _ptr.lLink.rLink = nil 这个操作没有重新赋值尾部节点
         */
    }
}

//移除某个节点
- (void)removeEmployee:(NEmployee *)employee
{
    if (_head == nil) {
        NSLog(@"双向链表是空的");
        return;
    }
    
    if (employee == nil) {
        NSLog(@"employee is null");
        return;
    }
    
    //内存字典中移除
    CFDictionaryRemoveValue(_dic, (__bridge const void *)(employee.key));
    
    if (_ptr == employee) {
        //删除的节点恰好是末尾节点, 末尾节点 重新指向 末尾节点的上一个节点
        _ptr = employee.lLink;
        _ptr.rLink = nil;//清除尾部节点
    }
    
    if (_head == employee) {
        //删除的是头部节点
        _head = employee.rLink;
        _head.lLink = nil;
    }
    
    //移除的是中间节点 -- 画图理解
    if (employee.lLink && employee.rLink) {
        NSLog(@"移除的是中间节点");
        employee.lLink.rLink = employee.rLink;
        employee.rLink.lLink = employee.lLink;
    }
    
    employee = nil;
}


//移除所有节点
- (void)removeAllEmployee
{
    
}

//遍历所有节点数据
- (void)enumAllEmployee
{
    //将临时节点(也就是尾部节点)保存起来
    NEmployee *ptr = _ptr;
    
    //从头部节点开始便利
    _ptr = _head;

    NSLog(@"①---从头部节点, 由左向右便利所有节点数据---");
    while (_ptr != nil) {
        /*
        if (_ptr.rLink == nil) {
            break;
        }
         */
        NSLog(@"%@, %@", _ptr.name, _ptr.key);
        
        /*
         这一步会将尾部节点_ptr置nil, 会导致删除尾部不成功
         */
        _ptr = _ptr.rLink;
    }
    
    
    /*
    NSLog(@"②---从尾部节点, 由右向左便利所有节点数据---");
    while (_ptr != nil) {
        NSLog(@"%@, %@", _ptr.name, _ptr.key);
        
        if (_ptr.lLink == _head) {
            break;
        }
        _ptr = _ptr.lLink;
    }
    */
    
    //遍历完成后, 尾部节点恢复成原来
    _ptr = ptr;
}

- (void)dealloc
{
    NSLog(@"employee_manager dealloc");
    CFRelease(_dic);
}
@end






