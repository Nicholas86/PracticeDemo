//
//  NTipsViewModel.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/5.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NTipsViewModel.h"
#import "NTipsModel.h" //封装模型model

@implementation NTipsViewModel
//请求iOS小知识数据
- (void)requestTipsDataWithPage:(NSInteger )page
                          cache:(CacheBlock )cache
                   successBlock:(SuccessBlock )successBlock
                   failureBlock:(FailureBlock )failureBlock
{
    NSDictionary *paramDic = @{
                               @"page":@(page),
                               @"version":@"1.0"
                               };
    NSString *url = [NSString  stringWithFormat:@"%@%@", IOS_TIPS_API_HOST, FEED_List];
    [NetWorkingRequest  netWorkTipsWithUrl:url parameters:paramDic cache:^(NSObject *responseObject) {
        if (cache && responseObject) {
            //缓存里不需要返回是否还有更多数据的
            [self  jsonObjectWithResponseObject:responseObject isCache:YES];
            //返回本地缓存的数据源
            cache(self.cacheDataSource);
        }
    } success:^(id responseObject, BOOL hasMoreData) {
        if (successBlock) {
#warning  标识并返回 是否有更多数据标识
            hasMoreData = [self  jsonObjectWithResponseObject:responseObject isCache:NO];
            //返回网络请求的数据源
            successBlock(self.httpDataSource, hasMoreData);
        }
    } failure:^(NSError *error) {
        //失败回调
        failureBlock(error);
    }];
}


- (BOOL )jsonObjectWithResponseObject:(id)responseObject isCache:(BOOL)isCache
{
    id responseDic = [NSJSONSerialization   JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
#warning 是否还有更多数据。默认么有(NO), 特别重要, 用于控制器控制是否需要加载更多数据的
    BOOL hasMoreData = NO;
    
    if ([responseDic  isKindOfClass:[NSDictionary class]] && [[responseDic  allKeys] count] > 0) {
        NSInteger code = [responseDic[@"code"] integerValue];
        if (code != NSuccessCode) {
            // 网络请求成功，但接口返回的 Code 表示失败，这里给 *error 赋值，后续走 failureBlock 回调
            NSLog(@"网络请求失败");
#warning 标识没有更多数据了
            hasMoreData = NO;
        } else {
            // 返回的 Code 表示成功，对数据进行加工过滤，返回给上层业务
            NSDictionary *resultData = responseDic[@"data"];
            NSArray *array = resultData[@"feeds"];
            //快速便利数组
            if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
                [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NTipsModel *model = [NTipsModel tipsModelWithDictionary:obj];
                    if (isCache) {
                        //如果是缓存的数据, 添加到缓存数组
                        [self.cacheDataSource  addObject:model];
                    }else{
                        //如果是网络请求的数据, 添加到网络请求的数组
                        [self.httpDataSource addObject:model];
                    }
                }];
#warning 标识还有更多数据
                hasMoreData = YES;
                NSLog(@"请求数据了: %ld", array.count);
            }else{
#warning 标识没有更多数据了
                hasMoreData = NO;
            }
        }
    }
    return hasMoreData;
}


#pragma mark setter && getter
//本地缓存的数据源
- (NSMutableArray<NTipsModel *> *)cacheDataSource
{
    if (!_cacheDataSource) {
        self.cacheDataSource = [NSMutableArray  arrayWithCapacity:0];
    }return _cacheDataSource;
}

//网络请求的数据源
- (NSMutableArray <NTipsModel *>*)httpDataSource
{
    if (!_httpDataSource) {
        self.httpDataSource = [NSMutableArray  arrayWithCapacity:0];
    }return _httpDataSource;
}


/*
 
 //NSLog(@"responseObject: %@", (NSDictionary *)responseObject);
 id responseDic = [NSJSONSerialization   JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
 //NSLog(@"responseDic: %@", responseDic);
 if ([responseDic  isKindOfClass:[NSDictionary class]] && [[responseDic  allKeys] count] > 0) {
 NSInteger code = [responseDic[@"code"] integerValue];
 if (code != NSuccessCode) {
 // 网络请求成功，但接口返回的 Code 表示失败，这里给 *error 赋值，后续走 failureBlock 回调
 NSLog(@"网络请求失败");
 successBlock(nil);
 } else {
 // 返回的 Code 表示成功，对数据进行加工过滤，返回给上层业务
 NSDictionary *resultData = responseDic[@"data"];
 //成功回调
 successBlock(resultData);
 }
 }
 */

@end
