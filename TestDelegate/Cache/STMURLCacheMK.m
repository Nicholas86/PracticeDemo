//
//  STMURLCacheMK.m
//  TestDelegate
//
//  Created by a on 2018/3/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import "STMURLCacheMK.h"
#import "STMURLCacheModel.h"

@implementation STMURLCacheMK

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheModel = [[STMURLCacheModel  alloc] init];
    }return self;
}

//内存容量
- (STMURLCacheMK *)memoryCapacity
{
    
    return self;
}


@end
