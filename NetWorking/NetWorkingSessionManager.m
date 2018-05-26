//
//  NetWorkingSessionManager.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NetWorkingSessionManager.h"

@implementation NetWorkingSessionManager
//单例
+ (NetWorkingSessionManager *)shareInstance
{
    static NetWorkingSessionManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NetWorkingSessionManager manager];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        instance.requestSerializer.timeoutInterval = 20.f;
        [self  MonitorNetwork];
    });
    return instance;
}

/**
 网络监听
 */
+ (void)MonitorNetwork{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                break;
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
        }
    }];
}
@end


