//
//  NSingle.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/13.
//  Copyright © 2018 a. All rights reserved.
//

#import "NSingle.h"

@interface NSingle ()

@end

@implementation NSingle

- (void)start
{
    [self creatTimerWithBlock:^{
        NSLog(@"NAPPSingle ++++ ");
    }];
}
@end
