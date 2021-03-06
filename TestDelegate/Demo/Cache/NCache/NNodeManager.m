//
//  NNodeManager.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/6/16.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NNodeManager.h"
#import "NNode.h" //节点

@interface NNodeManager (){
    NNode *_head; //头部节点
    NNode *_ptr;  //临时节点, 充当尾部节点
    CFMutableDictionaryRef _dic; //保存节点到内存字典
}
@end

@implementation NNodeManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        //建立链表头
        _head = _ptr = nil; //默认置nil, 不开辟空间。第一次添加的数据就是链表头部。
        //初始化
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }return self;
}

//移动新节点到链表头部
- (void)bringNodeToHead:(NNode *)node
{
    if (_head == node) {
        //移动的节点恰好是头部节点, 直接返回
        NSLog(@"移动的节点恰好是头部节点, 直接返回");
        return;
    }
    
    if (_ptr == node) {
        //移动的节点恰好是末尾节点, 末尾节点 重新指向 末尾节点的上一个节点
        _ptr = node.lLink;
        _ptr.rLink = nil;
    }else{
        //移动的节点不是末尾节点, 是中间节点
        node.rLink.lLink = node.lLink;
        node.lLink.rLink = node.rLink;
    }
    
    node.rLink = _head;
    node.lLink = nil;
    _head.lLink = node;
    _head = node;//_head被重新赋值成最新的node
}

//插入新节点到链表头部
- (void)insertNodeAtHead:(NNode *)node
{
    if (node == nil) {
        NSLog(@"node is null");
        return;
    }
    //添加到缓存字典
    CFDictionarySetValue(_dic, (__bridge const void *)(node.key), (__bridge const void *)(node));
    if (_head) {
        node.rLink = _head;
        _head.lLink = node;
        _head = node;//_head被重新赋值成最新的node
    }else{
        //双向链表是空的, 第一次添加的数据作为链表头
        _head = _ptr = node;
        NSLog(@"双向链表是空的, 第一次添加的数据作为链表头。_ptr.lLink:%@, _ptr.rLink:%@, _ptr.key: %@", _ptr.lLink, _ptr.rLink, _ptr.key);
    }
    
    NSLog(@"添加到缓存, _head.key: %@", _head.key);
    /*
     将新节点的右指针指向原链表的第一个节点(_head),  原链表的第一个节点的左指针指向新节点,
     并将原链表的链表头指向新节点
     */
}


//插入新节点到链表尾部
- (void)insertNodeAtTail:(NNode *)node
{
    if (node == nil) {
        NSLog(@"node is null");
        return;
    }
    
    if (_head == nil) {
        NSLog(@"头部为空, 设置head = node");
        _head = node;
    }
    
    //添加到缓存字典
    CFDictionarySetValue(_dic, (__bridge const void *)(node.key), (__bridge const void *)(node));
    
    if (_ptr) {
        _ptr.rLink = node;
        node.lLink = _ptr;
        node.rLink = nil;
    }
    _ptr = node;//_ptr必须被重新赋值成最新的node
    
    /*
     原链表的最后一个节点的右指针指向新节点, 将新节点的左指针指向原链表的最后一个节点
     并将新节点的右指针指向nil
     */
}

//是否包含某个节点
- (BOOL)hasNodeForKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return NO;
    }
    
    BOOL isHave = CFDictionaryContainsKey(_dic, (__bridge const void *)(key));
    return isHave;
}

//查找某个节点
- (NNode *)nodeForKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return nil;
    }
    NNode *node = CFDictionaryGetValue(_dic, (__bridge const void *)(key));
    return node;
}

//移除头部节点
- (void)removeNodeAtHead
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
- (void)removeNodeAtMiddle:(NNode *)node
{
    if (_head == nil) {
        NSLog(@"双向链表是空的");
        return;
    }
    
    if (_head == node) {
        NSLog(@"移除的是链表头, 直接返回");
        return;
    }
    
    if (_ptr == node) {
        NSLog(@"移除的是尾部节点, 直接返回");
        return;
    }
    
    //移除的是中间节点 -- 画图理解
    if (node.lLink && node.rLink) {
        NSLog(@"移除的是中间节点");
        node.lLink.rLink = node.rLink;
        node.rLink.lLink = node.lLink;
    }
    
    node = nil;
}

//移除尾部节点
- (NNode *)removeNodeAtTail
{
    if (_head == nil) {
        NSLog(@"双向链表是空的");
        return nil;
    }
    
    if (!_ptr) {
        /*
         如果_ptr为nil, 也有可能先从左向右遍历所有节点导致的。
         */
        NSLog(@"_ptr is null");
        return nil;
    }
    
    //保存尾部节点, 并将尾部节点返回去
    NNode *ptr = _ptr;
    
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
    
    //外部需要销毁这个变量, 再或者返回bool变量
    return ptr;
}

//移除某个节点
- (void)removeNode:(NNode *)node
{
    if (_head == nil) {
        NSLog(@"双向链表是空的");
        return;
    }
    
    if (node == nil) {
        NSLog(@"node is null");
        return;
    }
    
    //内存字典中移除
    CFDictionaryRemoveValue(_dic, (__bridge const void *)(node.key));
    
    if (_ptr == node) {
        //删除的节点恰好是末尾节点, 末尾节点 重新指向 末尾节点的上一个节点
        _ptr = node.lLink; //_ptr尾部节点重新赋值
        _ptr.rLink = nil;//清除尾部节点
    }
    
    if (_head == node) {
        //删除的是头部节点, _head重新赋值
        _head = node.rLink;
        _head.lLink = nil;
    }
    
    //移除的是中间节点 -- 画图理解
    if (node.lLink && node.rLink) {
        NSLog(@"移除的是中间节点");
        node.lLink.rLink = node.rLink;
        node.rLink.lLink = node.lLink;
    }
    
    node = nil;
}


//移除所有节点
- (void)removeAllNode
{
    _head = _ptr = nil;
    if (CFDictionaryGetCount(_dic) > 0) {
        //清空缓存字典
        CFDictionaryRemoveAllValues(_dic);
        NSLog(@"清空缓存字典:%@", _dic);
    }
}

//遍历所有节点数据
- (void)enumAllNode
{
    //将临时节点(也就是尾部节点)保存起来
    NNode *ptr = _ptr;
    
    //从头部节点开始便利
    _ptr = _head;
    
    NSLog(@"①---从头部节点, 由左向右便利所有节点数据---");
    while (_ptr != nil) {
        /*
         if (_ptr.rLink == nil) {
         break;
         }
         */
        NSLog(@"%@, %@", _ptr.value, _ptr.key);
        
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
    NSLog(@"node_manager dealloc");
    CFRelease(_dic);
}

@end



