//
//  NManualExecuteOperation.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/18.
//  Copyright © 2018 a. All rights reserved.
//

#import "NManualExecuteOperation.h"

@implementation NManualExecuteOperation
- (BOOL)manualPerformOperation:(NSOperation *)operation {
    BOOL ranIt = NO;
    
    if (operation.isCancelled) {
        ranIt = YES;
    } else if (operation.isReady) {
        if (!operation.isConcurrent) {
            [operation start];
        } else {
            [NSThread detachNewThreadSelector:@selector(start) toTarget:operation withObject:nil];
        }
        ranIt = YES;
    }
    
    return ranIt;
}
@end
