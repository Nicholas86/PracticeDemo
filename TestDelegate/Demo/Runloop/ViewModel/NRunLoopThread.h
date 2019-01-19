//
//  NRunLoopThread.h
//  TestDelegate
//
//  Created by 泽娄 on 2019/1/19.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(id responseObject);

@interface NRunLoopThread : NSThread

@property (nonatomic, strong, readonly) NSMutableArray *commands;

@property (nonatomic, copy) Block blcok;

+ (instancetype)share;

/// 添加元素
- (void)pushCommand:(NSString *)command;

/// 获取元素
- (NSString *)popCommand;

// 告诉 Worker 任务来了
// 把 Worker 拎起来干事
-(void)notifyWorker;

@end

NS_ASSUME_NONNULL_END
