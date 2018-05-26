//
//  NetWorkingRequest.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/25.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NetWorkingRequest.h"
#import "NCacheManager.h"//缓存类

@implementation NetWorkingRequest
//请求小知识
+ (void)netWorkTipsWithUrl:(NSString *)url
                parameters:(NSDictionary *)parameters
                     cache:(CacheBlock )cache
                   success:(SuccessBlock )success
                   failure:(FailureBlock )failure
{
    [self  netWorkGETUrl:url parameters:parameters cache:cache success:success failure:failure];
}


#pragma mark public 公共方法
+ (void)netWorkGETUrl:(NSString *)url
             parameters:(NSDictionary *)parameters
                cache:(CacheBlock )cache
              success:(SuccessBlock )success
              failure:(FailureBlock )failure
{
    id object = nil;
    if (cache != nil) {
        //先将缓存数据block出去
        object = [[NCacheManager  share] objectForKey:[self cacheKeyWithUrl:url parameters:parameters]];
        cache(object);
    }
    
    //网络判断
    
    
    //请求网络
    NetWorkingSessionManager *manager = [NetWorkingSessionManager  shareInstance];
    [manager  GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            //默认没有更多数据了, 外层根据具体需求修改
            success(responseObject, NO);
            //异步缓存数据
            [[NCacheManager  share] setObject:responseObject forKey:[self  cacheKeyWithUrl:url parameters:parameters] isAsync:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }else{
            NSLog(@"request error: %@", error);
        }
    }];
}

+ (NSString *)cacheKeyWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    if (parameters == nil || parameters.count == 0) {
        return url;
    }
    //将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    return [NSString  stringWithFormat:@"%@%@", url, paraString];
}


@end
