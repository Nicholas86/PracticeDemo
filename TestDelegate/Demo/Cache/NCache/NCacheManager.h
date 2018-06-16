//
//  NCacheManager.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NFileCache, NMemoryCache;

@interface NCacheManager : NSObject

@property (nonatomic, strong) Class aClass;

@property (nonatomic, strong) NFileCache *fileCache;

@property (nonatomic, strong) NMemoryCache *memoryCache;

//单例
+ (instancetype)share;

//注册要保存对象的类型
- (void)registerClass:(Class)aClass;

/////////////////////////////////////////////////
/// 是否含有某个key对应的值
- (BOOL)hasObjectForKey:(NSString *)key;
- (BOOL)hasFileCacheForKey:(NSString *)key;
- (BOOL)hasMemoryCacheForKey:(NSString *)key;

/// 添加key-value
- (void)setObject:(id)object forKey:(NSString *)key isAsync:(BOOL)isAsync;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)setFileCacheObject:(id)object forKey:(NSString *)key;
- (void)setMemoryCacheObject:(id)object forKey:(NSString *)key;

/// 取key对应的value
- (id)objectForKey:(NSString *)key;
- (id)fileCacheObjectForKey:(NSString *)key;
- (id)memoryCacheObjectForKey:(NSString *)key;

/// 删除对应key的值
- (void)removeObjectForKey:(NSString *)key;
- (void)removeFileCacheObjectForKey:(NSString *)key;
- (void)removeMemoryCacheObjectForKey:(NSString *)key;

/// 删除全部数据 - 清除当前 diskCachePath 所有的文件
- (void)removeAllObjects;
- (void)removeAllFileCacheObjects;
- (void)removeAllMemoryCacheObjects;

@end

