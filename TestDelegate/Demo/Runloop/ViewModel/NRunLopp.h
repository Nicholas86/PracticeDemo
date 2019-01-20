//
//  NRunLopp.h
//  TestDelegate
//
//  Created by 泽娄 on 2019/1/19.
//  Copyright © 2019 a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NRunLopp;
NS_ASSUME_NONNULL_BEGIN

@protocol NRunLoppDelegate <NSObject>

- (void)runLoop:(NRunLopp *)runLoop;

@end

@interface NRunLopp : NSObject

@property (nonatomic, assign) id<NRunLoppDelegate>delegate;

- (instancetype)initWithDelegate:(id<NRunLoppDelegate>)delegate;

+ (instancetype)runLoopWithDelegate:(id<NRunLoppDelegate>)delegate;

- (instancetype)init OBJC_UNAVAILABLE("use '-initWithDelegate:' or '+runLoopWithDelegate:' instead");

+ (instancetype)new OBJC_UNAVAILABLE("use '-initWithStrategy:' or '+runLoopWithDelegate:' instead");

- (void)run;

// 告诉 Worker 任务来了
// 把 Worker 拎起来干事
- (void)notifyWakeUp;

@end

NS_ASSUME_NONNULL_END
