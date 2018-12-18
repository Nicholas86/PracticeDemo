//
//  NonConcurrentOperation.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/16.
//  Copyright © 2018 a. All rights reserved.
//

#import "NonConcurrentOperation.h"

@interface NonConcurrentOperation ()

@property (strong, nonatomic) id data;

@end

@implementation NonConcurrentOperation
- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        self.data = data;
    }return self;
}

// 重写系统main
- (void)main
{
    [super main];
    NSLog(@"重写系统main");
    @try {
        if (self.cancelled) {
            NSLog(@"任务取消了0");
            return;
        }
        
        for (int i = 0; i < 6000; ++i) {
            if (self.isCancelled) {
                NSLog(@"任务取消了1");
                return;
            }
            
            sleep(1);
            NSLog(@"Loop %@", @(i));
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    } @finally {
        NSLog(@"任务完成了");
    }
}
@end
