//
//  NUseOperationQueue.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/18.
//  Copyright © 2018 a. All rights reserved.
//

#import "NUseOperationQueue.h"

@implementation NUseOperationQueue

- (void)executeOperationUsingOperationQueue {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(taskMethod) object:nil];
    [operationQueue addOperation:invocationOperation];
    
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Start executing blockOperation1, mainThread: %@, currentThread: %@", [NSThread mainThread], [NSThread currentThread]);
        sleep(3);
        NSLog(@"Finish executing blockOperation1");
    }];
    
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Start executing blockOperation2, mainThread: %@, currentThread: %@", [NSThread mainThread], [NSThread currentThread]);
        sleep(3);
        NSLog(@"Finish executing blockOperation2");
    }];
    
    [operationQueue addOperations:@[ blockOperation1, blockOperation2 ] waitUntilFinished:NO];
    
    [operationQueue addOperationWithBlock:^{
        NSLog(@"Start executing block, mainThread: %@, currentThread: %@", [NSThread mainThread], [NSThread currentThread]);
        sleep(3);
        NSLog(@"Finish executing block");
    }];
    
    [operationQueue waitUntilAllOperationsAreFinished];
}

- (void)taskMethod {
    NSLog(@"Start executing %@, mainThread: %@, currentThread: %@", NSStringFromSelector(_cmd), [NSThread mainThread], [NSThread currentThread]);
    sleep(3);
    NSLog(@"Finish executing %@", NSStringFromSelector(_cmd));
}

@end
