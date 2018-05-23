//
//  NCacheManager.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NCacheManager.h"
#import "NMemoryCache.h" //内存缓存
#import "NFileCache.h" //磁盘缓存

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.memoryCache = [NMemoryCache  share];
        self.fileCache = [NFileCache share];
    }return self;
}

//注册要保存对象的类型
- (void)registerClass:(Class)aClass
{
    _aClass = aClass;
}

/////////////////////////////////////////////////
/// 是否含有某个key对应的值
- (BOOL)hasObjectForKey:(NSString *)key
{
    //去内存读
    BOOL isHave= [self  hasMemoryCacheForKey:key];
    if (NO == isHave) {
        //去磁盘里读
        isHave = [self  hasFileCacheForKey:key];
    }
    return isHave;
}

- (BOOL)hasFileCacheForKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    return [self.fileCache  hasObjectForKey:md5Key];
}

- (BOOL)hasMemoryCacheForKey:(NSString *)key
{
    NSString *md5Key = [self  md5HashWithString:key];
    return [self.memoryCache  hasObjectForKey:md5Key];
}

/// 添加key-value
- (void)setObject:(id)object forKey:(NSString *)key isAsync:(BOOL)isAsync
{
    
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    
}

- (void)setFileCacheObject:(id)object forKey:(NSString *)key
{
    
}

- (void)setMemoryCacheObject:(id)object forKey:(NSString *)key
{
    
}

/// 取key对应的value
- (id)objectForKey:(NSString *)key
{
    return nil;
}

- (id)fileCacheObjectForKey:(NSString *)key
{
    return nil;
}

- (id)memoryObjectForKey:(NSString *)key
{
    return nil;
}

/// 删除对应key的值
- (void)removeObjectForKey:(NSString *)key
{
    
}

- (void)removeFileCacheObjectForKey:(NSString *)key
{
    
}

- (void)removeMemoryObjectForKey:(NSString *)key
{
    
}

/// 删除全部数据 - 清除当前 diskCachePath 所有的文件
- (void)removeAllObjects
{
    
}

- (void)removeAllFileCacheObjects
{
    
}

- (void)removeAllMemoryObjects
{
    
}

#pragma mark - Function Helper
- (NSString *)md5HashWithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}
@end
