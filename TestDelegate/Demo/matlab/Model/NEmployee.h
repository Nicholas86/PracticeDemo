//
//  NEmployee.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/6/9.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEmployee : NSObject
/*
 双向链表:实现LRU淘汰算法
 设计一个程序, 建立一个员工数据的双向链表, 并且允许可以在链表头部、链表末尾、链表中间3种不同位置
 插入新节点。 最后离开时, 列出此链表所有节点的数据字段内容。
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger salary;//薪水
@property (nonatomic, copy) NSString *no;//编号
@property (nonatomic, strong) NEmployee *lLink;//左指针
@property (nonatomic, strong) NEmployee *rLink;//右指针
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id value;

@end


