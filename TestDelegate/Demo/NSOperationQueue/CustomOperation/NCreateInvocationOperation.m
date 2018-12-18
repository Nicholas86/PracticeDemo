//
//  NCreateInvocationOperation.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/18.
//  Copyright © 2018 a. All rights reserved.
//

#import "NCreateInvocationOperation.h"

@implementation NCreateInvocationOperation
- (NSInvocationOperation *)invocationOperationWithData:(id)data {
    return [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(myTaskMethod1:) object:data];
}

- (NSInvocationOperation *)invocationOperationWithData:(id)data userInput:(NSString *)userInput {
    NSInvocationOperation *invocationOperation = [self invocationOperationWithData:data];
    
    if (userInput.length == 0) {
        invocationOperation.invocation.selector = @selector(myTaskMethod2:);
    }
    
    return invocationOperation;
}

- (void)myTaskMethod1:(id)data {
    NSLog(@"Start executing %@ with data: %@, mainThread: %@, currentThread: %@", NSStringFromSelector(_cmd), data, [NSThread mainThread], [NSThread currentThread]);
    sleep(3);
    NSLog(@"Finish executing %@", NSStringFromSelector(_cmd));
}

- (void)myTaskMethod2:(id)data {
    NSLog(@"Start executing %@ with data: %@, mainThread: %@, currentThread: %@", NSStringFromSelector(_cmd), data, [NSThread mainThread], [NSThread currentThread]);
    sleep(3);
    NSLog(@"Finish executing %@", NSStringFromSelector(_cmd));
}

@end
