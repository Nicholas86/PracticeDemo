//
//  NSubThread.h
//  TestDelegate
//
//  Created by 泽娄 on 2019/1/19.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block)(id responseObject);

NS_ASSUME_NONNULL_BEGIN

@interface NSubThread : NSThread

@property (nonatomic, strong, readonly) NSMutableArray *commands;

@property (nonatomic, copy) Block blcok;

+ (instancetype)share;

/// 添加元素
- (void)pushCommand:(NSString *)command;

/// 获取元素
- (NSString *)popCommand;

@end

NS_ASSUME_NONNULL_END
