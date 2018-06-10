//
//  NStudent.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/6/8.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 双向链表:实现LRU淘汰算法
 */
@interface NStudent : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger Math;
@property (nonatomic, assign) NSInteger Eng;
@property (nonatomic, copy) NSString *no;//学号
@property (nonatomic, strong) id lLink;//左指针
@property (nonatomic, strong) id rLink;//右指针
@end
