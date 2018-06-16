//
//  NNodeManager.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/6/16.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NNode;

@interface NNodeManager : NSObject
//移动新节点到链表头部
- (void)bringNodeToHead:(NNode *)node;

//插入新节点到链表头部
- (void)insertNodeAtHead:(NNode *)node;

//插入新节点到链表尾部
- (void)insertNodeAtTail:(NNode *)node;

//是否包含某个节点
- (BOOL)hasNodeForKey:(NSString *)key;
//查找某个节点
- (NNode *)nodeForKey:(NSString *)key;

//移除头部节点
- (void)removeNodeAtHead;

//移除中间节点
- (void)removeNodeAtMiddle:(NNode *)node;

//移除尾部节点
- (NNode *)removeNodeAtTail;

//移除某个节点
- (void)removeNode:(NNode *)node;

//移除所有节点
- (void)removeAllNode;

//遍历所有节点数据
- (void)enumAllNode;

@end
