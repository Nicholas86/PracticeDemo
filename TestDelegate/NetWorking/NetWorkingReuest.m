//
//  NetWorkingReuest.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NetWorkingReuest.h"

@implementation NetWorkingReuest
//单例
+ (NetWorkingReuest *)shareInstance
{
    static NetWorkingReuest *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NetWorkingReuest manager];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        instance.requestSerializer.timeoutInterval = 20.f;
    });
    return instance;
}



@end
