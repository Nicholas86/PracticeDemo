//
//  NFileCache.h
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NFileCache_fileExpires  (1 * 24 * 60 * 60)

@interface NFileCache : NSObject
/// 路径
@property (nonatomic, copy, readonly) NSString *diskCachePath;

/// The maximum size of the cache, in bytes
@property (assign, nonatomic) NSUInteger maxCacheSize;

/// 有效期, 默认1天
@property (nonatomic, assign) NSTimeInterval maxCacheTimeInterval;


//单例
+ (instancetype)share;

/// 用新路径建立一个cache
- (id)initWithDiskPath:(NSString *)diskPath;

///便利构造器
+ (id)fileCacheWithDiskPath:(NSString *)diskPath;

/// 返回key对应的文件路径
- (NSString *)filePathForKey:(NSString *)key;

/// 返回value: 存字符串, 返回字符串类型; 存UIImage, 返回UIImage类型。
- (id)objectForKey:(NSString *)key objectClass:(Class)aClass;

/// 清除当前 diskCachePath 所有的文件
- (void)clearDisk;

/// 清除当前 diskCachePath 所有的文件
- (void)clearDiskOnCompletion:(void(^)(void))completion;


#pragma mark - Private Methods
//是否含有某个key对应的值
- (BOOL)hasObjectForKey:(NSString *)key;

//添加key-value
- (void)setObject:(id)object forKey:(NSString *)key;

//取key对应的value
- (id)objectForKey:(NSString *)key;

//删除对应key的值
- (void)removeObjectForKey:(NSString *)key;

//删除全部数据 - 清除当前 diskCachePath 所有的文件
- (void)removeAllObjects;

@end


