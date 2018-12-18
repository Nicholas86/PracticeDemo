//
//  NAPPSingle.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/12/13.
//  Copyright © 2018 a. All rights reserved.
//

#import "NAPPSingle.h"

@implementation NAPPSingle
- (void)start
{
    [self creatTimerWithBlock:^{
        NSLog(@"NAPPSingle ++++ ");
    }];
}

@end
