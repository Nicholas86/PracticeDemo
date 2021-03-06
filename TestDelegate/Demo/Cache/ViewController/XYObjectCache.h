//
//  XYObjectCache.h
//  JoinShow
//
//  Created by Heaven on 14-1-21.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//
//  Copy from bee Framework

//#import "XYQuick_Predefine.h"

#import <Foundation/Foundation.h>

@class XYMemoryCache;
@class XYFileCache;

@interface XYObjectCache : NSObject

@property (nonatomic, weak, readonly) Class objectClass;  // 缓存对象的类
@property (atomic, strong) XYMemoryCache *memoryCache;  // 内存缓存
@property (atomic, strong) XYFileCache   *fileCache;  // 文件缓存

//单例
+ (XYObjectCache *)shareInstance;

- (void)registerObjectClass:(Class)aClass;

- (id)objectForKey:(NSString *)key;

- (void)saveObject:(id)anObject forKey:(NSString *)key;

- (void)deleteObjectForKey:(NSString *)key;

- (void)deleteAllObjects;

//////////////////////////////////////////////////////////////
- (BOOL)hasCachedForKey:(NSString *)key;

- (BOOL)hasFileCachedForKey:(NSString *)key;

- (BOOL)hasMemoryCachedForKey:(NSString *)key;


- (id)fileObjectForKey:(NSString *)key;
- (id)memoryObjectForKey:(NSString *)key;

- (void)saveObject:(id)anObject forKey:(NSString *)key async:(BOOL)async;
- (void)saveToMemory:(id)anObject forKey:(NSString *)key;
- (void)saveToData:(NSData *)data forKey:(NSString *)key;


@end


@protocol XYObjectCacheDelegate <NSObject>

@end
