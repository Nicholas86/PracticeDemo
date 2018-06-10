//
//  NEmpoyeeManager.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/6/9.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NEmployee;

@interface NEmployeeManager : NSObject

//移动新节点到链表头部
- (void)bringEmployeeToHead:(NEmployee *)employee;

//插入新节点到链表头部
- (void)insertEmployeeAtHead:(NEmployee *)employee;

//插入新节点到链表中间
- (void)insertEmployeeAtMiddle:(NEmployee *)employee;

//插入新节点到链表尾部
- (void)insertEmployeeAtTail:(NEmployee *)employee;

//查找某个节点
- (NEmployee *)employeeForKey:(NSString *)key;

//移除头部节点
- (void)removeEmployeeAtHead;

//移除中间节点
- (void)removeEmployeeAtMiddle:(NEmployee *)employee;

//移除尾部节点
- (void)removeEmployeeAtTail;

//移除尾部节点
- (void)removeEmployee:(NEmployee *)employee;

//移除所有节点
- (void)removeAllEmployee;

//遍历所有节点数据
- (void)enumAllEmployee;


@end







