//
//  NMemoryCache.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NNodeManager;

@interface NMemoryCache : NSObject

@property (nonatomic, assign) BOOL clearWhenMemoryLow;//default is Yes
@property (nonatomic, assign) NSUInteger maxCacheCount; // default is 48

@property (nonatomic, assign, readonly) NSUInteger cachedCount;//缓存个数
@property (nonatomic, strong, readonly) NSMutableArray *cacheKeyArray; //保存所有key
@property (nonatomic, strong, readonly) NSMutableDictionary *cacheObjDic;//保存key-value

@property (nonatomic, strong) NNodeManager *nodeManager;

//单例
+ (instancetype)share;

//是否含有某个key对应的值
- (BOOL)hasObjectForKey:(NSString *)key;

//添加key-value
- (void)setObject:(id)object forKey:(NSString *)key;

//取对应key的value
- (id)objectForKey:(NSString *)key;

//删除对应key的值
- (void)removeObjectForKey:(NSString *)key;

//删除全部数据
- (void)removeAllObjects;


@end
