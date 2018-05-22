//
//  NCacheManager.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NCacheManager.h"

@implementation NCacheManager
//单例
+ (instancetype)share
{
    static NCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NCacheManager  alloc] init];
    });
    return instance;
}


@end
